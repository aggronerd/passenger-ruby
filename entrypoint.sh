#!/bin/bash

if [ -f "$SSL_CERT_CHAIN_FILE" ]
then
  export APACHE_ARGS="$APACHE_ARGS -D IncludeSiteSSLCertChainFile"
fi

rake db:create 
rake db:migrate && /usr/sbin/apache2ctl $APACHE_ARGS
