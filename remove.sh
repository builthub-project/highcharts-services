#!/bin/bash
docker kill platform-highcharts-services
docker container rm platform-highcharts-services
docker rmi -f platform-highcharts-services

