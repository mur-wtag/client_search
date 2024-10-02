# Client Search ![main](https://github.com/mur-wtag/client_search/actions/workflows/main.yml/badge.svg?branch=main)

## Description
This is a minimalist Ruby command-line application that provides two main features:
1. Search for clients by name.
2. Check for duplicate emails in the dataset.

## Requirements
- Ruby 2.6+
- Bundler (optional)

## Setup

1. Just `bundle` ruby gems (make sure dependent `ruby` version is installed in your system)
```shell
$ bundle
```

2. As it is a `command line` app, execute this command to your shell
```shell
$ ruby app.rb
```
You'll get all necessary option while using this app in the command-line. 

### Rubocop
The project uses [Rubocop](https://github.com/rubocop/rubocop) to lint code and enforce coding standards. We run Rubucop as part of the CI/CD process and it will fail builds if it detects any issues.

To check your code locally you can run:

```sh
$ bundle exec rubocop
```

### RSpec
For unit tests I am using `RSpec`. To run:
```shell
bundle exec rspec
```

### Github actions - CI/CD
On each commit being pushed to the repo we're running a CI workflow defined in `.github/workflows/main.yml`. The workflow is split into three separate parts:
* Linting and quality checks `rubocop`
* RSpec

### Future implementation
I have already developed a tiny web application using `Sinatra`. More feature could be added later e.g. exposing search results as json api response.
To checkout this web application, just use this command:
```shell
ruby webapp.rb
```

Cheers!
