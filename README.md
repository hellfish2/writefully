# Writefully

[![Build Status](https://travis-ci.org/codemy/writefully.svg?branch=master)](https://travis-ci.org/codemy/writefully) [![Coverage Status](https://coveralls.io/repos/codemy/writefully/badge.png?branch=master)](https://coveralls.io/r/codemy/writefully?branch=master) [![Code Climate](https://codeclimate.com/github/codemy/writefully.png)](https://codeclimate.com/github/codemy/writefully)

Allows developers who love to write to publish easily

## Getting Started

There are 2 ways to use Writefully, generate a brand new app or integrate it into an existing application.

Writefully depends on PostgreSQL with hstore extension activated so make sure you set that up if your going with the existing application route.

### New App

```bash
gem install writefully

wf-app new [name]
```

This will generate the boilerplate rails app to get you started using writefully.

### Existing App

```bash
gem 'writefully'
```

Once you've installed the gem run 

```bash
rake writefully:migrations:install
```

In `config/routes.rb` add the following

```ruby
mount Writefully::Engine, at: '/writefully'
```

Create any model for Writefully. This is the model writefully will use.

```bash
rails g model [ModelName (Post|Article|Whatever)] --skip-migration --parent=writefully/post
```

The last step is to run the migration to generate the database structure for writefully

```bash
rake db:migrate
```

## Configuration

### Github Application

Writefully integrates with github, which means you'll need to set up a github application.

[Create new Application](https://github.com/settings/applications/new)

Or just create an application in an organization.

### Config file (app/config/writefully.yml)

You'll need to fill out the configuration file for your development environment

```yaml
development: &default
  :pidfile: <%= Rails.root.join('log', 'writefully.log') %>
  :logfile: <%= Rails.root.join('tmp', 'pids', 'writefully.pid') %>
  :content: <%= Rails.root.join('content') %> # create a content folder for development
  :storage_key: 'aws-key'
  :storage_secret: 'aws-secret'
  :storage_folder: 'bucket-name'
  :storage_provider: "AWS" # only supports AWS for now
  :app_directory: <%= Rails.root %>
  :github_client: 'github-app-client'
  :github_secret: 'github-app-secret'
  :hook_secret: 'generate-with-securerandom' 

test:
  <<: *default
```

These settings might seem obvious in development however you might want to change this in your production / staging environment. We assume you use capistrano style deployment where you have a separate config for those environments

The `hook_secret` config is required to ensure that any web hooks you get from github is legitimate. You can generate it with anything you like. The most simplest thing to do is go into IRB and run

```ruby
require 'securerandom' ; SecureRandom.hex
```

I recommend you use a different one in production / staging than the one in development.

## Running Writefully

In development to run writefully all you have to do is 

```bash
# from your app root
bin/writefully config/writefully.yml
```

This will start the writefully process and start listening for changes in the `:content` folder.

## Admin Interface

Once you've set everything up simply head over to

```bash
http://localhost:3000/writefully
```

You will be asked to sign in with github. Once your logged in you'll have access to the admin interface and will be promted to setup your first site.



## Manifesto

+ Writefully Core
  + Separate lightweight process that manages all the work
  + Main rails process should be able to communicate with Writefully via Redis queue
    + When a site is created it sets up a repository / hooks with sample content
  + Manages content taxonomy via Tags / Taggings
  + Easily Extendable from main rails app
  + Content Localization
  + Backend Interface for managing sites
  + Receive WebHook from github and updates site
  + Turns repository collaborators into authors
  + Converts local based images into content provider URL
    + S3 / Cloudfront
    + Akamai
    + Cloudfiles
    + etc...

+ Writefully Desktop App
  + Probably going to use [node-webkit](https://github.com/rogerwang/node-webkit)
  + More details to com

+ Writefully mobile app
  + Probably going to use [Framework7](http://www.idangero.us/framework7/)
  + More details to come
