# Client Search

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

