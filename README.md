# Library App

Library app written in Rails

## Technologies Used

- [Ruby on Rails (6.1.4)](https://guides.rubyonrails.org/v6.1.4/) 
- [Stimulus](https://stimulus.hotwired.dev/handbook/introduction)
- [PostgreSQL](https://www.postgresql.org/docs/14/index.html)
- [Heroku](https://devcenter.heroku.com/articles/getting-started-with-rails6)

## Usage

- Install [rvm](https://rvm.io) and configure it.
```shell
rvm 3.2.2
rvm gemset create LibraryApp
rvm 3.2.2@LibraryApp
```

```shell
npm install webpack-dev-server -g
```

- Install bundler
```shell
gem install bundler
bundle install
```

- Install and configure [PostgreSQL 14](https://www.postgresql.org/download/) for your platform

- Create database and run migrations
```shell
rails db:create
rails db:migrate
```

- (Optional) Seed database using values from `db/seeds`
```shell
rails db:seed
```

- Run development processes
```shell
./bin/dev
```

- The application is now available at `http://localhost:3000`!

## Deployment

- Deployment uses heroku hobby dyno.
- Make sure you're logged in via the `heroku-cli`
```shell
heroku login
```
- Run migrations
```shell
heroku run rails db:migrate
```
- Push code to the `heroku` remote to deploy
```shell
git push heroku master
```

## Roadmap

This will always be a moving target because, well, software development is an iterative process.

- [~~i18n~~](https://guides.rubyonrails.org/i18n.html) :earth_africa:
- Sorting tables :arrow_up::arrow_down:
- Different permissions for librarians and admins :man_technologist: :woman_technologist: 
- Handle renewals as a separate entity (currently renewals are done by returning and re-borrowing the book) :repeat_one:
- More filters :pencil:
- Potential optimisations :sparkles:
    - [Code splitting](https://webpack.js.org/guides/code-splitting/)
    - [Full text search GIN indexes](https://thoughtbot.com/blog/optimizing-full-text-search-with-postgres-tsvector-columns-and-triggers)
- Home page statistics :chart:
