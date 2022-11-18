#!/bin/bash
if [[ $RAILS_ENV == 'production' ]]; then
  bundle install --without development test --jobs 3
else
  bundle install --jobs 3 --with development test
fi
script/worker
