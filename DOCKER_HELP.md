Steps for creating a Rails project using just Docker
====

# Need to have a Dockerfile

This `Dockerfile` does not run bundle because we prefer having a volume for storing the gems and preserve them even if the web container is removed, in a similar way the database is handled, more info in the next step

```
FROM ruby:2.5.3

LABEL MAINTAINER="Carlos Contreras <carloscontreras0420@gmail.com>"

ENV APP_PATH=/usr/src/myapp

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir $APP_PATH

WORKDIR ${APP_PATH}

ADD . $APP_PATH
```

# Need to have a docker-compose.yml file

This file has all postgres config commented on purpose, at this point we don't need postgres

```
version: '3'
services:
  # db:
  #   image: postgres:11.0
  #   volumes:
  #     - postgres:/var/lib/postgresql/data
  #   env_file: .env
  web:
    build: .
    command: bundle exec rails s -p 3000 -b '0.0.0.0'
    volumes:
      - .:/usr/src/myapp
      - gems:/usr/local/bundle # $BUNDLE_PATH and $GEM_HOME located at /usr/local/bundle
    ports:
      - "3000:3000"
    env_file: .env
    # depends_on:
    #   - db
volumes:
  # postgres: {}
  gems: {}
```

# Need and .env file for basic configurations

```
POSTGRES_PASSWORD=example
RACK_ENV=development
RAILS_ENV=development
```

# Need a .ruby-version file matching the container version
```
2.5.3
```

# Finally run a docker-compose based generator for the app

```
#!/bin/bash
docker-compose down -v
docker-compose build web
echo "===--> Installing Rails Gem..."
docker-compose run --rm web gem install rails --version ">= 5.2" --no-document
echo "===--> Generating Rails App..."
docker-compose run --rm web rails new . --skip-coffee --skip-sprockets --skip-turbolinks --api --skip-test --webpack=react --database=postgresql
```