FROM ruby:2.6.5-alpine
RUN apk update \
&& apk upgrade \
&& apk add --update --no-cache \
build-base postgresql-dev

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN gem install bundler
RUN bundle install

ADD . $APP_HOME

CMD bundle exec puma ./app.rb