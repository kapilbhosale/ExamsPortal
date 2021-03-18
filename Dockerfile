FROM ruby:2.5.1-slim
# FROM ruby:2.5.1-alpine

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN apt-get install -y nodejs postgresql-client
RUN apt-get install -y imagemagick libmagickwand-dev
# sudo apt install redis-server
# sudo apt install npm
# npm install --global yarn


# Setting env up
ENV BUNDLER_VERSION=2.0.2
ENV RAILS_ENV='production'
ENV RACK_ENV='production'

# set label
LABEL Name=smartexamsrails Version=0.0.1

EXPOSE 3000

# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1

WORKDIR /app
# COPY . /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)"
RUN bundle install

CMD ["bundle", "exec", "rails s"]
