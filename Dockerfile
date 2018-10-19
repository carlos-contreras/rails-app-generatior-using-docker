FROM ruby:2.5.3

LABEL MAINTAINER="Carlos Contreras <carloscontreras0420@gmail.com>"

ENV APP_PATH=/usr/src/myapp

RUN wget -qO- https://deb.nodesource.com/setup_10.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs yarn
RUN mkdir $APP_PATH

WORKDIR ${APP_PATH}

ADD . $APP_PATH
