#!/bin/bash

[ "$DEFAULT_VOICE_PORT" = "" ] && DEFAULT_VOICE_PORT=9987
[ "$FILETRANSFER_PORT" = "" ] && FILETRANSFER_PORT=30033
[ "$QUERY_PORT" = "" ] && QUERY_PORT=10011
#[ "$MACHINE_ID" = "" ] && MACHINE_ID="$(hostname)"
[ "$LOGPATH" = "" ] && LOGPATH=/data/log
[ "$INIFILE" = "" ] && INIFILE=/data/config/ts3server.ini
INIDIR=$(dirname $INIFILE)
[ "$QUERY_IP_WHITELIST" = "" ] && QUERY_IP_WHITELIST=/data/config/query_ip_whitelist.txt
[ "$QUERY_IP_BLACKLIST" = "" ] && QUERY_IP_BLACKLIST=/data/config/query_ip_blacklist.txt
[ "$LOGAPPEND" = "" ] && LOGAPPEND=0

[ ! -d "$LOGPATH" ] && mkdir -p "$LOGPATH"
[ ! -d "$INIDIR" ] && mkdir -p "$INIDIR"
[ ! -f "$QUERY_IP_WHITELIST" ] && touch "$QUERY_IP_WHITELIST"
[ ! -f "$QUERY_IP_BLACKLIST" ] && touch "$QUERY_IP_BLACKLIST"

for i in MARIADB_HOST MARIADB_DATABASE MARIADB_USER MARIADB_PASSWD
do
  [ "${!i}" = "" ] && echo "Missing mandatory parameter $i" && exit 1
done

[ "$MARIADB_PORT" = "" ] && MARIADB_PORT=3306

(
  echo "[config]"
  echo "host=$MARIADB_HOST"
  echo "port=$MARIADB_PORT"
  echo "username=$MARIADB_USER"
  echo "password=$MARIADB_PASSWD"
  echo "database=$MARIADB_DATABASE"
  echo "socket="
) > /opt/ts3/ts3db_mariadb.ini

until nc -z -v -w5 $MARIADB_HOST $MARIADB_PORT
do
  echo "Waiting for MariaDB server $MARIADB_HOST to be reachable on port $MARIADB_PORT ..."
  sleep 5
done

echo "Starting TS3 Server"
 
cd /opt/ts3/
exec ./ts3server_minimal_runscript.sh \
  default_voice_port=$DEFAULT_VOICE_PORT \
  filetransfer_port=$FILETRANSFER_PORT \
  query_port=$QUERY_PORT \
  machine_id=$MACHINE_ID \
  logpath=$LOGPATH \
  licensepath=$LICENSEPATH \
  inifile=$INIFILE \
  createinifile=1 \
  query_ip_whitelist=$QUERY_IP_WHITELIST \
  query_ip_blacklist=$QUERY_IP_BLACKLIST \
  logquerycommands=1 \
  logappend=$LOGAPPEND \
  dbplugin=ts3db_mariadb \
  dbsqlcreatepath=create_mariadb/ \
  dbpluginparameter=/opt/ts3/ts3db_mariadb.ini

#exec syslogd -n -O /dev/stdout
