# Contactually-API

[![Code Climate](https://codeclimate.com/github/railslove/contactually-api/badges/gpa.svg)](https://codeclimate.com/github/railslove/contactually-api)
[![Build
Status](https://travis-ci.org/railslove/contactually-api.svg?branch=master)](https://travis-ci.org/railslove/contactually-api)

This is a simple API Wrapper for the contactually API. It is not feature complete, as it does not support all available API endpoints yet, but I guess for most use cases this will be fine. Feel free to contribute!

## Installation

Add this line to your application's Gemfile:

    gem 'contactually-api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install contactually-api

## Usage

### Configuration

As `contactually-api` is shipped with sensible defaults, that will allow you
to start right away, there are a couple of settings you may want to adjust,
depending on your applications requirements.

The available configuration options are:

* api_key (your contactually api_key)
* contactually_url (Default: "https://www.contactually.com/api/v1/")

Configuration goes as follows:

```ruby
    Contactually.configure do |c|
      c.api_key           = "YOURKEY"
      c.contactually_url  = "URL"
    end
```

#### How to use the gem

```ruby
    contactually = Contactually::API.new
    contacts = contactually.contacts.index
    notes = contactually.notes.index
    groupings = contactually.groupings.index

    contact = { contact: { first_name: 'Jane', last_name: 'Doe', ... } }
    contactually.contacts.create(contact)

    ...
```

Implemented endpoints are:

* Accounts
* Contact Groupings
* Contacts
* Contents
* Groupings
* Notes
* Tasks

The API is documented here: [Contactually API Docs](http://developers.contactually.com/docs/)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
