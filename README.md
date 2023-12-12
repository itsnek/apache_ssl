# Apache Webserver  

## Description  
Implementation of an apache image, as well as sslyze and sslscan. On apache certs are created and passed to the specified paths. More to come.  

## How to run  
- `./build.sh` | For first time execution.  
- `docker-compose up -d` | For following executions, when you need to start/restart the containers.  
- `docker-compose up -d --build` | For when you need to rebuild the containers(add service name at 
the end of the container if you need to specify which you want to rebuild).  

### Used commands  
- `openssl genrsa -aes256 -out CA.key 4096`  
- `openssl req -x509 -new -nodes -key CA.key -sha256 -days 3650 -out CA.crt`  
- `openssl req -new -nodes -out apache_webserver.csr -newkey rsa:4096 -keyout apache_webserver.key -subj '/CN=localhost/C=GR/ST=Attica/L=Athens/O=Unipi'`  
- ```
    cat > apache_webserver.v3.ext << EOF
    authorityKeyIdentifier=keyid,issuer
    basicConstraints=CA:FALSE
    keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
    EOF
  ```  
- `openssl x509 -req -in apache_webserver.csr -CA CA.crt -CAkey CA.key -CAcreateserial -out apache_webserver.crt -days 365 -sha256 -extfile apache_webserver.v3.ext`  

### Sources  

- https://arminreiter.com/2022/01/create-your-own-certificate-authority-ca-using-openssl/  