FROM ruby:2.5.1
# FROM ruby:2.5.1-slim
# FROM ruby:2.5.1-alpine
# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN apt-get install -y postgresql-client
RUN apt-get install -y imagemagick libmagickwand-dev

RUN apt-get update && apt-get install -y curl
RUN curl https://deb.nodesource.com/setup_10.x | bash -
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y nodejs yarn

# sudo apt install redis-server
# sudo apt install npm
# npm install --global yarn

# Setting env up
ENV BUNDLER_VERSION=2.0.2
ENV RAILS_ENV='development'
ENV RACK_ENV='development'

# set label
LABEL Name=smartexamsrails Version=0.0.1

# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1

WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
COPY . /myapp

RUN gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)"
RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# RUN yarn
# RUN bundle exec rails assets:precompile
# RUN bundle exec rake webpacker:compile

CMD ["bundle", "exec", "puma"]

# CMD ["rails", "server", "-b", "0.0.0.0"]
