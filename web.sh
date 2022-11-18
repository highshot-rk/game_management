#!/bin/bash
if [[ $RAILS_ENV == 'production' ]]; then
  bundle install --without development test --jobs 3
  bundle exec rake db:create db:migrate assets:precompile assets:clean
else
  bundle install --jobs 3 --with development test
  bundle exec rake db:create
  bundle exec rake db:migrate
  bundle exec rake assets:clobber
fi
script/web
