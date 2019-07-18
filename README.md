# Lite::Memoize

[![Gem Version](https://badge.fury.io/rb/lite-memoize.svg)](http://badge.fury.io/rb/lite-memoize)
[![Build Status](https://travis-ci.org/drexed/lite-memoize.svg?branch=master)](https://travis-ci.org/drexed/lite-memoize)

Lite::Memoize provides an API for caching and memoizing locally expensive calculations including those with parameters. The flexible API allows you to memoize results using alias, class, instance, or mixin level cache.

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

* [Alias](#alias)
* [Klass](#klass)
* [Instance](#instance)
* [Mixin](#mixin)
* [Benchmarks](#benchmarks)
* [Port](#port)

## Alias

Alias level memoization is the fastest of the available methods, and provides a decent level
of control. It's the only one that can also be used to memoize class level methods. Method
arguments are automatically watched to cache dynamic values.

You can only cache results without access to any information about the `store`.

```ruby
class Movies
  extend Lite::Memoize::Alias

  class << self
    extend Lite::Memoize::Alias

    def random
      HTTP.get('http://movies.com/any')
    end

    memoize :random
  end

  def random
    HTTP.get('http://movies.com/any')
  end

  # NOTE: memoize must be before alias
  memoize :random
  alias rando random

  def search(title)
    HTTP.get("http://movies.com?title=#{title}")
  end

  memoize :search, as: :find

end

# NOTE: To reload a method just append the reload argument key
Movies.random               #=> Cached
Movies.random(reload: true) #=> New value

# NOTE: To flush the entire cache
Movies.clear_cache #=> New value
```

## Klass

Class level memoization is the quickest way to get up without polluting your class with new methods.
It's perfect for short lived or non-altering items like `activerecord` objects.

You can only cache results without access to any information about the `store`.

```ruby
class Movies
  extend Lite::Memoize::Klass

  def random
    HTTP.get('http://movies.com/any')
  end

  # NOTE: memoize must be before alias
  memoize :random
  alias rando random

  def search(title)
    HTTP.get("http://movies.com?title=#{title}")
  end

  memoize :search, as: :find

end
```

## Instance

Instance level memoization is the slowest of the available methods, but it provides
the most amount of flexibility and control. It's very useful for creating services or things
where control is paramount like clearing the cache or dumping it to JSON. Method arguments
are automatically watched to cache dynamic values. Please read the spec suite to see all
available actions.

You can access almost all methods in the `instance.rb` file.

```ruby
class Movies

  def cache
    @cache ||= Lite::Memoize::Instance.new
  end

  # NOTE: This method gets all relevent info like name and args automatically
  def all
    cache.memoize { HTTP.get("http://movies.com/all") }
  end

  def random(type)
    cache['random'] ||= HTTP.get("http://movies.com/any?type=#{type}")
  end

  alias rando random

  # NOTE: Arguments in the memoize method are optional
  def search(title)
    cache.memoize(as: :find, args: [title], reload: !cache.empty?) do
      HTTP.get("http://movies.com?title=#{title}")
    end
  end

end
```

## Mixin

Mixin level memoization is the leanest of the available methods, and provides a decent level
of control. Useful when you want to keep your class light weight.

You can access all methods to the `Hash` class.

```ruby
class Movies
  include Lite::Memoize::Mixin

  def all
    memoize(:all) { HTTP.get("http://movies.com/all") }
  end

  alias full all

  # NOTE: Arguments in the memoize method are optional with the exception of method name
  def search(title)
    memoize(:find, args: [title], reload: false) do
      HTTP.get("http://movies.com?title=#{title}")
    end
  end

end
```

## Benchmarks

The classes ranked from fastest to slowest are `Alias`, `Mixin`, `Klass`, and `Instance`.

View all how it compares to other libs by running the [benchmarks](https://github.com/drexed/lite-statistics/tree/master/benchmarks).

## Port

`Lite::Memoize` is a compatible port of [ActiveMemoize](https://github.com/drexed/active_memoize).

Switching is as easy as renaming `ActiveMemoize::Klass` to `Lite::Memoize::Klass`
and  `ActiveMemoize::Instance` to `Lite::Memoize::Instance`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/lite-memoize. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Lite::Memoize project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/lite-memoize/blob/master/CODE_OF_CONDUCT.md).
