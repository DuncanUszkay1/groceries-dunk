FROM node:latest AS node_base
FROM ruby:3.2

COPY --from=node_base . .

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD bin/bundle exec puma -C config/puma.rb