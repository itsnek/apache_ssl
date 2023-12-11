FROM ubuntu:latest

RUN apt-get -y update && \
    apt-get install -q -y curl apache2 software-properties-common vim net-tools sslscan python3 

RUN mkdir /root/certs 
COPY ./certs /root/certs

RUN apt install -y ca-certificates && \
    cp /root/certs/cacerts/CA.crt /usr/local/share/ca-certificates && \
    update-ca-certificates

WORKDIR /etc/apache2/

RUN mkdir ssl_keys && \
    cp /root/certs/apache_webserver/apache_webserver.key ./ssl_keys && \
    cp /root/certs/apache_webserver/apache_webserver.crt ./ssl_keys

# RUN touch /etc/apache2/sites-available/default-ssl
# RUN <<EOF > /etc/apache2/sites-available/default-ssl 
#     SSLCertificateFile /etc/apache2/mySSLKeys/serverCert.pem 
#     SSLCertificateKeyFile /etc/apache2/mySSLKeys/serverKey.key 
# EOF

ENTRYPOINT [ "/usr/sbin/apache2ctl", "-D", "FOREGROUND" ]