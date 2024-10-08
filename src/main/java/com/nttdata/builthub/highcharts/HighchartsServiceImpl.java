package com.nttdata.builthub.highcharts;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.nio.charset.StandardCharsets;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Map;
import java.util.Locale;
import java.util.concurrent.LinkedTransferQueue;
import java.util.concurrent.TimeUnit;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import javax.ws.rs.Produces;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.Invocation.Builder;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.StatusType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.ContentDisposition;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.util.FileCopyUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;

@RestController
@CrossOrigin
public class HighchartsServiceImpl {

	static final String GRAPHDB_REPOSITORY = "BuiltHub";
	static final String DEFAULT_RESPONSE_TYPE = "text/csv; charset=UTF-8";

	static final Logger logger = LoggerFactory.getLogger(HighchartsServiceImpl.class);

	@Value("${builthub.sparql.entrypoint:http://172.31.41.170:7200/repositories}")
	private String SPARQL_ENTRYPOINT;
	private Client jerseyClient = null;

	@Autowired
	private JdbcTemplate jdbcTemplate;

	@PostConstruct
	public void initialize() {
		this.jerseyClient = ClientBuilder.newClient();
	}

	@PreDestroy
	public void clean() {
		try {
			this.jerseyClient.close();
		} catch (Throwable ignore) {

		}
	}

	@GetMapping("/highcharts/{graphName}")
	@Produces(DEFAULT_RESPONSE_TYPE)
	public ResponseEntity<StreamingResponseBody> graphdb(
			@PathVariable(name = "graphName", required = true) String graphName,
			@RequestParam Map<String, String> allParams) {
		try {
			final long startTime = System.currentTimeMillis();

			logger.info("Running SPARQL query " + graphName);
			/**/
			String filename = graphName.toLowerCase() + ".rq";
			Resource resource = new ClassPathResource(filename);
			InputStream inputStream = resource.getInputStream();
			byte[] data = FileCopyUtils.copyToByteArray(inputStream);
			String sparqlQuery = new String(data, StandardCharsets.UTF_8);

			Integer paramLimit = this.getQueryLimit(allParams);
			if (paramLimit != null) {
				sparqlQuery += " LIMIT " + paramLimit;
			}
			/**/
			for (Map.Entry<String, String> entry : allParams.entrySet()) {
				sparqlQuery = sparqlQuery.replaceAll("\\$P\\{" + entry.getKey() + "\\}", entry.getValue());
			}
			/**/
			// logger.info(sparqlQuery);

			final Entity<String> entity = Entity.entity(sparqlQuery, "application/sparql-query");
			final Builder request = this.jerseyClient.target(this.SPARQL_ENTRYPOINT).path(GRAPHDB_REPOSITORY)
					.request(DEFAULT_RESPONSE_TYPE);
			final Response response = request.post(entity);
			final int responseStatus = response.getStatus();
			if (responseStatus == HttpURLConnection.HTTP_OK) {
				final long queryTime = System.currentTimeMillis();
				logger.info("[" + graphName + ":query time] " + Long.toString(queryTime - startTime) + "ms");
				StreamingResponseBody responseBody = new StreamingResponseBody() {
					@Override
					public void writeTo(OutputStream out) throws IOException {
						InputStream dataIS = (InputStream) response.getEntity();
						byte[] dataBuffer = new byte[4 * 1024];
						int dataSize = 0;

						while ((dataSize = dataIS.read(dataBuffer)) > 0) {
							out.write(dataBuffer, 0, dataSize);
							out.flush();
						}

						out.flush();

						final long finishTime = System.currentTimeMillis();
						logger.info(
								"[" + graphName + ":execution time] " + Long.toString(finishTime - startTime) + "ms");
					}
				};

				final long requestTime = System.currentTimeMillis();
				logger.info("[" + graphName + ":request time] " + Long.toString(requestTime - startTime) + "ms");

				return new ResponseEntity<StreamingResponseBody>(responseBody, HttpStatus.OK);
			}

			StatusType status = response.getStatusInfo();
			logger.error("*** AWS GRAPHDB REQUEST ERROR [" + Integer.toString(status.getStatusCode()) + "]: "
					+ status.getReasonPhrase());
			if (response.hasEntity()) {
				logger.error(response.readEntity(String.class));
			}

			throw new ResponseStatusException(status.getStatusCode(), status.getReasonPhrase(), null);
		} catch (ResponseStatusException rse) {
			throw rse;
		} catch (Throwable t) {
			logger.error(t.getMessage(), t);

			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, t.getMessage(), t);
		}
	}

	@GetMapping("/highcharts/datamart/{queryName}")
	public ResponseEntity<StreamingResponseBody> datamart(
			@PathVariable(name = "queryName", required = true) String queryName,
			@RequestParam Map<String, String> allParams) {
    	Boolean download = false;
		try {
			final long startTime = System.currentTimeMillis();

			logger.info("Running SQL query " + queryName);
			/**/
			String filename = queryName.toLowerCase() + ".sql";
			Resource resource = new ClassPathResource(filename);
			InputStream inputStream = resource.getInputStream();
			byte[] data = FileCopyUtils.copyToByteArray(inputStream);
			String sqlQuery = new String(data, StandardCharsets.UTF_8);

			Integer paramLimit = this.getQueryLimit(allParams);
			if (paramLimit != null) {
				sqlQuery += " LIMIT " + paramLimit;
			}
			/**/
			for (Map.Entry<String, String> entry : allParams.entrySet()) {
				sqlQuery = sqlQuery.replaceAll("\\$P\\{" + entry.getKey() + "\\}", entry.getValue());
			}
			/**/
			//logger.info(sqlQuery);

			StreamingResponseBodyResultSetExtractor responseBody = new StreamingResponseBodyResultSetExtractor(
					queryName, startTime);
			
			this.jdbcTemplate.query(sqlQuery, responseBody);

			final long requestTime = System.currentTimeMillis();
			logger.info("[" + queryName + ":request time] " + Long.toString(requestTime - startTime) + "ms");

	//******************************************** */

			// text/csv ******* application/pdf ******* application/json
			String mime_response_type = this.getQueryFormat(allParams);

			if(mime_response_type != null){
				download=true;
			}
			
            if(download){
				MediaType mediaType = new MediaType(mime_response_type.split("/")[0], mime_response_type.split("/")[1]);
				
                HttpHeaders responseHeaders = new HttpHeaders();
				responseHeaders.set(HttpHeaders.CONTENT_ENCODING, StandardCharsets.UTF_8.name());
				responseHeaders.setContentLanguage(Locale.ENGLISH);
				responseHeaders.setContentType(mediaType);
				responseHeaders
						.setContentDisposition(ContentDisposition.parse("attachment; filename="+queryName.toLowerCase()+"."+ mime_response_type.split("/")[1]));

			    return new ResponseEntity<StreamingResponseBody>(responseBody, responseHeaders, HttpStatus.OK);
            }
            else{
			    return new ResponseEntity<StreamingResponseBody>(responseBody, HttpStatus.OK);
            }
	//******************************************** */
		} catch (ResponseStatusException rse) {
			throw rse;
		} catch (Throwable t) {
			logger.error(t.getMessage(), t);

			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, t.getMessage(), t);
		}
	}

	private final Integer getQueryLimit(final Map<String, String> allParams) {
		Integer result = null;

		try {
			result = Integer.valueOf(allParams.getOrDefault("limit", null));
		} catch (NumberFormatException ignore) {
		}

		return result;
	}

	//******************************************** */
	private final String getQueryFormat(final Map<String, String> allParams) {
		String result = null;

		try {
			result = allParams.getOrDefault("format", null);
		} catch (NumberFormatException ignore) {
		}

		return result;
	}
	//******************************************** */

	private final class StreamingResponseBodyResultSetExtractor
			implements StreamingResponseBody, ResultSetExtractor<Void> {
		static final String DELIMITER = ",";
		static final String EOL = "\n";

		private LinkedTransferQueue<String> queue = new LinkedTransferQueue<String>();
		private String queryName = "";
		private long startTime = 0L;

		/**
		 * @param startTime
		 */
		public StreamingResponseBodyResultSetExtractor(final String queryName, final long startTime) {
			super();
			this.queryName = queryName;
			this.startTime = startTime;
		}

		@Override
		public Void extractData(ResultSet rs) throws SQLException {
			try {
				ResultSetMetaData rsmd = rs.getMetaData();
				final int columnCount = rsmd.getColumnCount();

				String header = "";
				for (int i = 1; i <= columnCount; i++) {
					header = header + rsmd.getColumnName(i);
					if (i != columnCount) {
						header = header + DELIMITER;
					}
				}

				queue.add(header + EOL);

				while (rs.next()) {
					String record = "";
					for (int i = 1; i <= columnCount; i++) {
						final Object value = rs.getObject(i);
						record = record + this.getCSVValue(value);
						if (i != columnCount) {
							record = record + DELIMITER;
						}
					}
					queue.add(record + EOL);
				}
			} finally {
				queue.add("");
			}

			return null;
		}

		@Override
		public void writeTo(OutputStream outputStream) throws IOException {
			try {
				String record = queue.poll(30, TimeUnit.SECONDS);
				while (StringUtils.hasText(record)) {
					outputStream.write(record.getBytes(StandardCharsets.UTF_8));
					outputStream.flush();

					record = queue.poll(30, TimeUnit.SECONDS);
				}

				outputStream.flush();
			} catch (InterruptedException ignored) {
			}

			final long finishTime = System.currentTimeMillis();
			logger.info("[" + queryName + ":execution time] " + Long.toString(finishTime - startTime) + "ms");
		}
		
		private String getCSVValue(final Object value) {
			String result = "";
			if (value == null) return "";
			result = value.toString();
			
			return result;
		}
	}
}
