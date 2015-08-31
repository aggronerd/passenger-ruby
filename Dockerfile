FROM ruby:!!RUBY_VERSION!!

RUN apt-get update -qq
RUN apt-get upgrade -y
RUN apt-get install -y build-essential ssh-client libsqlite3-dev git libpq-dev apache2 apache2-dev libxml2-dev libxslt1-dev nodejs

# Set up apache2
RUN service apache2 stop
RUN a2dissite 000-default

# Install and build passenger extensions
RUN gem install passenger
RUN mkdir /var/lock/apache2
RUN passenger-install-apache2-module -a --languages ruby | tee /tmp/passenger-compile.log
RUN grep -e "^\s*LoadModule" /tmp/passenger-compile.log | xargs  > /etc/apache2/mods-available/passenger.load
RUN echo "export PASSENGER_ROOT=`grep PassengerRoot /tmp/passenger-compile.log | sed -r \"s/^ *PassengerRoot (.*)$/\1/g\"`" >> /etc/apache2/envvars
RUN echo "export PASSENGER_DEFAULT_RUBY=`grep PassengerDefaultRuby /tmp/passenger-compile.log | sed -r \"s/^ *PassengerDefaultRuby (.*)$/\1/g\"`" >> /etc/apache2/envvars
ADD passenger.conf /etc/apache2/mods-available/passenger.conf

# Final setup items for apache2
RUN a2enmod rewrite
RUN a2enmod passenger
RUN a2enmod ssl
ADD app_http.conf /etc/apache2/sites-available/app_http.conf
ADD app_https.conf /etc/apache2/sites-available/app_https.conf
RUN a2ensite app_http

# Setup folder for SSL certificates
RUN mkdir -p /opt/ssl
RUN chown -R www-data:www-data /opt/ssl
RUN chmod -R 700 /opt/ssl

# Setup entrypoint
RUN mkdir -p /opt/docker
ADD entrypoint.sh /opt/docker/entrypoint.sh
RUN chmod +x /opt/docker/entrypoint.sh

ENV SSL_CERT_FILE=/opt/ssl/cert
ENV SSL_CERT_KEY_FILE=/opt/ssl/cert_key
ENV SSL_CERT_CHAIN_FILE=""
ENV APP_HOME=/opt/app
ENV RAILS_ENV=production

WORKDIR $APP_HOME
RUN mkdir -p $APP_HOME

RUN apt-get autoremove -y

ONBUILD EXPOSE 80 443
ONBUILD CMD ["/opt/docker/entrypoint.sh"]
