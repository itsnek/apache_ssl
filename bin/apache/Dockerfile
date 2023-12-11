FROM ubuntu:latest

RUN apt-get -y update && \
    apt-get install -q -y curl apache2 software-properties-common vim net-tools sslscan python3 

RUN mkdir /root/certs
COPY ./certs /root/certs

RUN apt install -y ca-certificates && \
    cp /root/certs/cacerts/CA.crt /usr/local/share/ca-certificates && \
    update-ca-certificates

WORKDIR /etc/apache2/

ENTRYPOINT [ "/usr/sbin/apache2ctl", "-D", "FOREGROUND" ]