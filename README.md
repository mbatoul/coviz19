# Coviz19

> Visualization dashboard for coronavirus pandemic built with Ruby-On-Rails and VueJS

## Table of Contents

- [Introduction](#introduction)
- [Setup](#setup)
- [Database design](#database-design)
- [Import COVID data](#import-covid-data)
- [Import geographic data](#import-geographic-data)
- [Usage](#usage)

## Introduction

Coviz19 is a visualization dashboard for coronavirus spread.

It is built as a Ruby-On-Rails 6 API and VueJS front-end.

It currently provides an interactive map and several sets of charts. The data used is sourced from [John Hopkins University](https://github.com/CSSEGISandData/COVID-19). A script downloads the CSV files provided by on this [repository](https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series) and stores the data in the database.

In your development environment, the scripts must be executed as explained below.

## Setup

### Requirements

Make sure you have the following softwares:

- Brew on Mac OS X to install the following softwares (instructions [here](https://brew.sh/))
- Curl to download example files (`brew install curl` on Mac OS X or more instructions [here](https://github.com/curl/curl/blob/master/docs/INSTALL.md))
- Git to download the application source code (`brew install git` on Mac OS X or more instructions [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git))
- Ruby to run the application (`brew install ruby` on Mac OS X or more instructions [here](https://www.ruby-lang.org/en/documentation/installation/))
- Postgres is the database used by the application (`brew install postgres` on Mac OS X or more instructions [here](https://www.postgresql.org/docs/current/tutorial-install.html))
- Bundler to install the application's dependencies (`gem install bundler`)

### Install application

Clone application:

```sh
git clone https://github.com/mbatoul/coviz19.git
cd coviz
```

Install dependencies:

```sh
bundle install
```
```sh
cd client && yarn install
```

Create database schema and run migrations (by default it will be a local database named `coviz_dev`):

```sh
createdb coviz_dev
```

```sh
rails db:migrate
```
## Database design

The database has three tables:

![Image of database design](https://coviz-19-bucket.s3.eu-west-3.amazonaws.com/erd-1.jpg)

### `zones`

It represents a geographic region on which we have COVID data.

The table is designed to handle different level of granularity using tree based relations with a `parent_id`.

Currently, a zone has four possible natures: `country`, `province`, `region` and `state`. `country` being the current highest level division, any lower level division within this country will reference the corresponding `country` record.

For instance, the country zone China has_many children of nature `province`.

### `data_points`

It represents a point of data in a single `zone` at a precise date in a single category. It `belongs_to` to a `zone` record.

It has four possible categories:

- Confirmed: the number of confirmed cases. [See the data](https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv)
- Death: the number of deaths? [See the data](https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv)
- Recovered: the number of recoveries. [See the data](https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv)
- Active: the number of current active cases (confirmed - deaths - recovered)

### `geojson_features`

It stores the geographic data displayed on the map. It `belongs_to` to a `zone` record.

[Learn more about GeoJSON](https://fr.wikipedia.org/wiki/GeoJSON)

## Import COVID data

The COVID data used by Coviz19 is sourced from this [repo](https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series).

To download the data, use the `import_covid_data` rake task.

```sh
rake import_covid_data
```

It currently successively downloads the following CSV files and format the data in order to fit the database schema.

1. [Confirmed cases data](https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv)

Finds or creates the corresponding `zone` record  for each line and creates a `data_point` of category `confirmed` for each column.

2. [Deaths data](https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv)

Finds or creates the corresponding `zone` record  for each line and creates a `data_point` of category `death` for each column.

3. [Recovered cases data](https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv)

Finds or creates the corresponding `zone` record  for each line and creates a `data_point` of category `recovered` for each column.

It also creates a `data_point` of category `active` for each date. Its value is calculated as `confirmed - death - recovered` of each zone at a precise date.

## Import geographic data

Use the `import_geojson_features` rake task

```sh
rake import_geojson_features
```

It downloads 232 GeoJSON features from a remote AWS S3 bucket, find the corresponding `zone` record and stores the GeoJSON in the `geojson_features` table.


## Usage

The rake task `start` executes our `Procfile.dev` file that runs our API and client servers.

```sh
rake start
```
