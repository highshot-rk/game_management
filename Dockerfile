FROM ruby:2.3.3

RUN apt-get update -qq && apt-get install -y build-essential

# for postgres
RUN apt-get install -y libpq-dev

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# for imagemagick
RUN apt-get install -y imagemagick

# for a JS runtime
RUN apt-get install -y nodejs

# for a ZIP support
RUN apt-get install -y zip unzip

ENV APP_HOME /myapp
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle config --global silence_root_warning 1
RUN gem install foreman --no-ri --no-rdoc

RUN bundle install --without development test --jobs 3

ADD . $APP_HOME
