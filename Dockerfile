FROM openjdk:17-jdk-slim
RUN apt-get update && apt-get install -y curl
COPY ./highcharts.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-Xms512m", "-Xmx4g", "-jar","./app.jar"]
HEALTHCHECK CMD curl -f -G http://localhost:8080/api/health || exit 1
