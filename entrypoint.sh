#!/bin/bash
rake db:create || rake db:migrate || /usr/sbin/apache2ctl -D FOREGROUND