#!/bin/bash

git clone https://github.com/rbsec/sslscan.git

docker build -t sslscan:sslscan ./sslscan

rm -rf ./sslscan

docker-compose up -d --build