# Apache Webserver  

## Description  
Implementation of an apache image, as well as sslyze and sslscan. On apache certs are created and passed to the specified paths. More to come.  

## How to run  
- `./build.sh` | For first time execution.  
- `docker-compose up -d` | For following executions, when you need to start/restart the containers.  
- `docker-compose up -d --build` | For when you need to rebuild the containers(add service name at 
the end of the container if you need to specify which you want to rebuild).  

### Used commands  

#### CA & Server certs  
- `openssl genrsa -aes256 -out CA.key 4096`  
- `openssl req -x509 -new -nodes -key CA.key -sha256 -days 3650 -out CA.crt`  
- `openssl req -new -nodes -out apache_webserver.csr -newkey rsa:4096 -keyout apache_webserver.key -subj '/CN=localhost/C=GR/ST=Attica/L=Athens/O=Unipi'`   
- ```
    cat > apache_webserver.v3.ext << EOF
    [ server ]
    authorityKeyIdentifier=keyid,issuer
    basicConstraints=CA:FALSE
    keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
    extendedKeyUsage = serverAuth
    nsCertType = server
    EOF
  ```  
- `openssl x509 -req -in apache_webserver.csr -CA CA.crt -CAkey CA.key -CAcreateserial -out apache_webserver.crt -days 365 -sha256 -extensions server -extfile apache_webserver.v3.ext`  

#### Client certs  
- `openssl genrsa -out client.key 2048`  
- `openssl req -new -out client.req -newkey rsa:4096 -key client.key -subj '/CN=client/C=GR/ST=Attica/L=Athens/O=Unipi`  
- `openssl x509 -req -in client.req -CA ../cacerts/CA.crt -CAkey ../cacerts/CA.key -CAcreateserial -out client.cer -days 365 -sha256 -extfile client.v3.ext`  
- `openssl pkcs12 -export -inkey client.key -in client.cer -out client.p12`  

#### SSLyze && SSLScan  
- `docker run -it --rm -v "./certs/client:/certs" --network host nablac0d3/sslyze:latest localhost:443 --cert /certs/client.cer --key /certs/client.key > ./results/sslyze.log`  
- `docker run -it --rm -v "./certs/client:/certs" --network host sslscan:sslscan /sslscan --pk=/certs/client.p12 --pkpass=myCert localhost:443 > ./results/sslscan.log`  
- `docker run -it --rm -v "./certs/client:/certs" --network host sslscan:sslscan /sslscan --certs=/certs/client.cer --pk=/certs/client.key --pkpass=myCert localhost:443 > ./results/sslscan.log` 
- To check security measures: `wget -S --spider https://localhost:443 --certificate=certs/client/client.cer --private-key=certs/client/client.key --no-check-certificate`

### Sources  
- https://arminreiter.com/2022/01/create-your-own-certificate-authority-ca-using-openssl/  
- https://linuxconfig.org/apache-web-server-ssl-authentication   
- https://linuxhint.com/enable-https-apache-web-server/  
- https://community.apachefriends.org/f/viewtopic.php?t=75613&p=256430#  
- https://docs.miarec.com/admin-guide/security/security-hardening-for-apache-web-server/   
- https://webhostinggeeks.com/blog/8-easy-steps-to-safeguard-an-apache-web-server-and-prevent-ddos/  
