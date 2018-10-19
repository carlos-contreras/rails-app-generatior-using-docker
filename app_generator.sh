#!/bin/bash
echo "=================================="
echo "===--> Cleaning Up the ENV  <--==="
echo "=================================="
docker-compose down -v
docker-compose build web
echo "=================================="
echo "===--> Installing Rails Gem <--==="
echo "=================================="
docker-compose run --rm web gem install rails --version ">= 5.2" --no-document
echo "=================================="
echo "===--> Generating Rails App <--==="
echo "=================================="
docker-compose run --rm web rails new . --skip-coffee --skip-sprockets --skip-turbolinks --api --skip-test --webpack=react --database=postgresql