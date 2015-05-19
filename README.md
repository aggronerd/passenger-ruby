# passenger-ruby

Passenger and Apache 2 Docker image suitable for using with a Ruby on Rails project (with SSL support).

## Prerequisites

Requires [Docker](https://www.docker.com) and runs on Mac OS or Linux using Shell Scripts.

## Usage

Build for all the Ruby versions in RUBIES:

	sh build.sh all

Build a container for a specific version of Ruby:

	sh build.sh 2.2.2