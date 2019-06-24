# Lite::Memoize

[![Gem Version](https://badge.fury.io/rb/lite-memoize.svg)](http://badge.fury.io/rb/lite-memoize)
[![Build Status](https://travis-ci.org/drexed/lite-memoize.svg?branch=master)](https://travis-ci.org/drexed/lite-memoize)

Lite::Memoize provides an API for caching and memoizing locally expensive calculations including those with parameters.
The flexible API allows you to memoize results using class or instance level cache.

**NOTE:** If you are coming from `ActiveMemoize`, please read the [port](#port) section.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lite-memoize'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lite-memoize

## Table of Contents

* [Port](#port)
* [Klass](#klass)
* [Instance](#instance)

## Port

`Lite::Memoize` is compatible port of [ActiveMemoize](https://github.com/drexed/active_memoize).

Switching is as easy as renaming `ActiveMemoize::Klass` to `Lite::Memoize::Klass`
and  `ActiveMemoize::Instance` to `Lite::Memoize::Instance`.

## Klass

Class level memoization is the quickest way to get up and running using your cache, but provides the least amount of flexibility.
You can only cache results without access to any information about your cache.

```ruby
class Movies
  extend Lite::Memoize::Klass

  def random
    HTTP.get('http://movies.com/any')
  end

  memoize :random

  def search(title)
    HTTP.get("http://movies.com?title=#{title}")
  end

  memoize :search, as: :find

end
```

## Instance

Instance level memoization is a more involved way to setup your cache, but provides the most amount of flexibility.
You can access almost all methods in the `instance.rb` file.

```ruby
class Movies

  def cache
    @cache ||= Lite::Memoize::Instance.new
  end

  def all
    cache.memoize { HTTP.get("http://movies.com/all") }
  end

  def random
    cache['random'] ||= HTTP.get('http://movies.com/any')
  end

  def search(title)
    cache.memoize(as: :find, refresh: !cache.empty?) do
      HTTP.get("http://movies.com?title=#{title}")
    end
  end

end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/lite-memoize. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Lite::Memoize project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/lite-memoize/blob/master/CODE_OF_CONDUCT.md).
