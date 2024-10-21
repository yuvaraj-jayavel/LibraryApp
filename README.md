# Library App

Library app written in Rails

## Technologies Used

- [Ruby on Rails (6.1.4)](https://guides.rubyonrails.org/v6.1.4/) 
- [Stimulus](https://stimulus.hotwired.dev/handbook/introduction)
- [PostgreSQL](https://www.postgresql.org/docs/14/index.html)
- [Heroku](https://devcenter.heroku.com/articles/getting-started-with-rails6)

## Usage

- Use docker compose to start docker containers
```
docker compose -f docker-compose.dev.yml up -d
```
- The app should have started in localhost:3000
- To run tests
```
docker compose -f docker-compose.dev.yml exec web rails t
```
- To access the container shell,
```
docker compose -f docker-compose.dev.yml exec web bash
```
