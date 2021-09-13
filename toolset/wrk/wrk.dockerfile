FROM buildpack-deps:bionic
FROM adoptopenjdk/openjdk11:latest

RUN apt-get update && apt-get install -yqq libluajit-5.1-dev libssl-dev luajit unzip wget

WORKDIR /wrk
RUN wget https://github.com/Hyperfoil/Hyperfoil/releases/download/release-0.13/hyperfoil-0.13.zip
RUN unzip hyperfoil-0.13.zip

WORKDIR /
# Required scripts for benchmarking
COPY pipeline.lua pipeline.lua
COPY concurrency.sh concurrency.sh
COPY pipeline.sh pipeline.sh
COPY query.sh query.sh

RUN chmod 777 pipeline.lua concurrency.sh pipeline.sh query.sh

# Environment vars required by the wrk scripts with nonsense defaults
ENV name name
ENV server_host server_host
ENV levels levels
ENV duration duration
ENV max_concurrency max_concurrency
ENV max_threads max_threads
ENV pipeline pipeline
ENV accept accept
