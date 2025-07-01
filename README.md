# Groceries App - Duncan Uszkay

A simple Rails app for managing a grocery list.

Production URL: https://guarded-bayou-90636-c6aae4ab3057.herokuapp.com

## For reviewers

The Rails template in use, pulled from Heroku's site, has a fair amount of boilerplate that would be of little interest to read. If you want to peruse the source files, here's a list of files of interest, that I've made substantial changes to after scaffolding:
- [line_item.rb](/app/models/list_item.rb)
    - [Corresponding test](/test/models/list_item_test.rb)
- [line_item_controller.rb](/app/controllers/list_item_controller.rb)
    - [Corresponding test](/test/controllers/list_item_controller_test.rb)
- [all.html.erb](/app/views/list_item/all.html.erb)
- [Browser-driven end-to-end tests](/test/system/list_items_test.rb)

Discussion about choices made can be found in [DISCUSSION.md](/DISCUSSION.md)

Discuss about possible expansions can be found in [EXPANSION.md](/EXPANSION.md)

## Running the app locally via docker compose

Enables you to:
- Build and run the app from source
- Run integration and unit tests, but not system tests (see [DISCUSSION.md](/DISCUSSION.md))

Requires (Docker)[https://docs.docker.com/get-started/get-docker/].

1. `docker compose up` 
2. Visit `localhost:3000`

## Setting up the app for your local machine

Enables you to:
- Run system tests
- Run Rails generators and other commands that generate files which must be committed

**If you don't need either of those uses, I recommend using docker compose.**

Warning: These instructions were only tested on a single OSX machine, mileage may vary.

1. Install Postgres and run it on your machine

1. Install Chrome on your machine

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