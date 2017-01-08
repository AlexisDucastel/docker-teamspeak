# aducastel/teamspeak

Teamspeak 3 Docker Image depending on MariaDB database.

## How to run

```
docker run -d -v /path/to/data:/data \
  -p 9987:9987/udp -p 30033:30033 -p 10011:10011 \
  --link maria -e MARIADB_HOST=maria -e \
  -e MARIADB_PORT=3306 MARIADB_DATABASE=ts3 \
  -e MARIADB_USER=ts3 -e MARIADB_PASSWD=toto \
  aducastel/teamspeak
```

## Docker compose sample (compatible with Rancher)

Please visit https://github.com/AlexisDucastel/docker-teamspeak to find docker-compose.yml and rancher-compose.yml sample

## Optional VAR
- DEFAULT_VOICE_PORT=9987 :  UDP port open for clients to connect to. This port is used by the first virtual server, subsequently started virtual servers will open on increasing port numbers. Default: The default voice port is 9987.

- FILETRANSFER_PORT=30033 : TCP Port opened for file transfers. Default: The default file tranfer port is 30033.

- FILETRANSFER_IP="0.0.0.0,0::0" : Comma separated IP list which the file transfers are bound to. Default: File transfers are bound on "any" IP address, both ipv4 and ipv6 if available.

- QUERY_PORT=10011 : TCP Port opened for ServerQuery connections. Default: The default ServerQuery port is 10011.

- QUERY_IP="0.0.0.0,0::0" : Comma separated IP list on which the server instance will listen for incoming ServerQuery connections. Default: ServerQuerys are bound on "any" IP address, both ipv4 and ipv6 if available.

- LOGPATH=/data/log : The physical path where the server will create logfiles.
  Default: The server will create logfiles in the /data/log subdirectory.

- LICENSEPATH="" : The physical path where your license file is located.
  Default: There is not .

- INIFILE=/data/config/ts3server.ini :The physical path including the filename where your config file is located.

- QUERY_IP_WHITELIST=/data/config/query_ip_whitelist.txt : The file containing whitelisted IP addresses for the ServerQuery interface. All hosts listed in this file will be ignored by the ServerQuery flood protection. Default: The whitelist file is located in /data/config/query_ip_whitelist.txt.

-  QUERY_IP_BLACKLIST=/data/config/query_ip_blacklist.txt : The file containing blacklisted IP addresses for the ServerQuery interface. All hosts listed in this file are not allowed to connect to the ServerQuery interface. Default: The whitelist file is located in  /data/config/query_ip_blacklist.txt.

- LOGAPPEND=0 : If set to 1, the server will not create a new logfile on every start. Instead, the log output will be appended to the previous logfile. The logfile name will only contain the ID of the virtual server. Default: The server will create a new logfile on every start.
