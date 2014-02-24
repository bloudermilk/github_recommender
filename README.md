# GitHub Recommender

An experiment using the githubarchive.org dataset to recommend GitHub projects
based off your Starred repositories.

## Installation

This app depends on JRuby and MySQL being installed on the host.

The following environment variables are used for configuration:

* `DATABASE_URL` (required): The URL of the database to connect to
* `DL_POOL` (optional): The number of concurrent downloaders to run when
  scraping.
* `PROC_POOL` (optional): The number of concurrent processors to run when
  scraping.

```bash
$ bundle
$ jbundle
$ rake db:create db:migrate
```

## Usage

### Scraping

This program comes with a scraper that fetches data from githubarchive.org.

```bash
# Scrape all of 2013
$ ./bin/scrape 2013 2014
```

### Recommending

This program also has an API to get recommendations.

```bash
$ rackup
$ curl http://localhost:9292/users/bloudermilk/recommendations
```
