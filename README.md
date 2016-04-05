# Marvel

Ruby Client for Marvel API's just add gem in your project for using the Marvel API.
Marvel Ruby Client Provide apis for following resources: 
Character
Comic
Creator
Event
Series
Story

## Installation

Add this line to your application's Gemfile:

    gem 'marvel-api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install marvel-api

## Usage

### Require the gem

    require 'marvel_api'
    # => true

### Configuration

    Marvel::API.configure do |c|
      c.public_key = "<Marvel Public Key>" # Mandatory
      c.private_key = "<Marvel Private Key>" # Mandatory
    end
