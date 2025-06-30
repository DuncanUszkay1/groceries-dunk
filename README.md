# Groceries App - Duncan Uszkay

A simple Rails app for managing a grocery list.

Production URL: https://guarded-bayou-90636-c6aae4ab3057.herokuapp.com

## Running the app locally via docker compose

Requires (Docker)[https://docs.docker.com/get-started/get-docker/].

`docker compose up` 

Visit `localhost:3000`

## Setting up the app for your local machine

Having a local setup is handy when running commands that modify files, like Rails generators, and for running system tests that use browser emulators.

If you just want to run the app, I recommend using the `docker compose` method detailed in the prior section.

1. Install Postgres and run it on your machine

1. Install chrome on your machine

1. Install dependencies with `bundle install`

1. Run DB migrations with `bin/rails db:migrate`

1. Run tests with `bin/rails test`

## Production Deployment (Maintainers only)

Deploy with Heroku by pushing the latest commit to the heroku remote:

```
git push heroku HEAD
```

To run DB migrations in production, run `heroku run bin/rails db:migrate`