# passenger-ruby

Passenger and Apache 2 Docker image suitable for using with a Ruby on Rails project (with SSL support).

## Prerequisites

Requires [Docker](https://www.docker.com) and runs on Mac OS or Linux using Shell Scripts.
	
## Usage

For a Ruby on Rails app ensure your Dockerfile includes the version of Ruby

Your Dockerfile must copy your apps root to /opt/app. That is where the base URL is. The example belows one way 

	FROM aggronerd/passenger-ruby:2.2.2
	
	# Dependencies for building Gems
	RUN apt-get update -qq
	RUN apt-get upgrade -y
	# For nokogiri and a JS runtime
	RUN apt-get install -y libxml2-dev libxslt1-dev nodejs
		
	# Setup app and install dependencies using Bundler
	ADD Gemfile* $APP_HOME/	
	RUN bundle --without=development install
	
	# Add the rest of your source
	ADD . $APP_HOME
	RUN chown -R www-data:www-data $APP_HOME

### Enabling SSL

Copy your public SSL certificate into /opt/ssl/cert and your private key into /opt/ssl/cert_key.

To enable HTTPS with HTTP redirecting to HTTPS:

	RUN a2ensite app_https
	RUN a2dissite app_http
	RUN chown -R www-data:www-data /opt/ssl
	RUN chmod -R 700 /opt/ssl

#### Self-signed

You can add a self signed config by adding the following to your Dockerfile

	RUN apt-get install -y openssl
	RUN openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=Your ISO country code/ST=Your State/L=Your Town/O=Your Company Name/CN=yourdomainname.com" -keyout $SSL_CERT_KEY_FILE -out $SSL_CERT_FILE
	RUN chown -R www-data:www-data /opt/ssl
	RUN chmod -R 700 /opt/ssl

## Building

Build for all the Ruby versions in RUBIES:

	./build.sh all

Build a container for a specific version of Ruby:

	./build.sh 2.2.2