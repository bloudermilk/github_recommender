# GitHub Recommender

An experiment using the githubarchive.org dataset to recommend GitHub projects
based off your Starred repositories.

## Installation

This app depends on JRuby and MySQL being installed on the host.

The following environment variables are used for configuration:

* `DATABASE_URL` (required): The URL of the database to connect to

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

## License

Copyright (c) 2014 Brendan Loudermilk

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
