
# News Scraper module

Extracts data directly from the main Ecuadorian media press outlets (web sites).
It can extract single news (given a news url) or complete sets of news (given a provider name).

## Initial setup

Install all project dependencies:

`bundle install --path vendor/bundle`

## Run server

`bundle exec puma`

## Using it

### Querying single news

`curl https://localhost:9292/news/single\?url\="<url>"`

### Querying news set

`curl https://localhost:9292/news/<provider>`

**Note:** your ip could get blocked due to the large number of requests to the media server.