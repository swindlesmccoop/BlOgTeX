FROM debian:11
RUN apt-get update && apt-get install -y pandoc
WORKDIR /usr/share/blogtex