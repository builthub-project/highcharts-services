#!/bin/bash
docker build -t platform-highcharts-services .
docker run -d -it --restart=always --network=microsrv-net -p 9084:8080 --name platform-highcharts-services platform-highcharts-services


