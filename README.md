# Groceries App - Duncan Uszkay

A simple Rails app for managing a grocery list.

Production URL: https://guarded-bayou-90636-c6aae4ab3057.herokuapp.com

Discussion of technical choices is available in DISCUSSION.md

## Running the app locally via docker compose

Enables you to:
- Build and run the app from source
- Run integration and unit tests, but not system tests (see DISCUSSION.md)

Requires (Docker)[https://docs.docker.com/get-started/get-docker/].

`docker compose up` 

Visit `localhost:3000`

## Setting up the app for your local machine

Enables you to:
- Run system tests
- Run Rails generators and other commands that generate files which must be committed

If you don't need either of those uses, I recommend just using docker compose.

Warning: These instructions were only tested on a single OSX machine, mileage may vary.

1. Install Postgres and run it on your machine

1. Install chrome on your machine

1. Install dependencies with `bundle install`

1. Setup the prod DB with `bin/rails db:setup`

1. Setup the test DB with `RAILS_ENV=test bin/rails db:setup`

1. Run system tests with `bin/rails test:system`

## Production Deployment (Maintainers only)

Deploy with Heroku by pushing the latest commit to the heroku remote:

```
git push heroku HEAD
```

To run DB migrations in production, run `heroku run bin/rails db:migrate`