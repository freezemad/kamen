# Kamen

A light-weight api mock engine.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kamen'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kamen

## Usage

You will do nothing but add some comments above your action method

```ruby
class UsersController < ApplicationController

  # MockData
  # {
  #   id: 1,
  #   name: 'Frank',
  #   gender: 'M',
  # }
  # MockData

  def show
  end
end
```

Then call the api with curl or your favourite http client like postman

```ruby
$ curl http://example.com/users/1
$ { id: 1, name: 'Frank', gender: 'M'}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/kamen. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Kamen project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/kamen/blob/master/CODE_OF_CONDUCT.md).
