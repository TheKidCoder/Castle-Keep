# Castle::Keep

This is a minimal implementation of the Castle.io Server-Side API.
This gem exists because the official [castle-rb](https://github.com/castle/castle-ruby) gem has quite a few external dependencies that can cause compatibility issues.

The code for the initial version of this gem was taken directly from [carlhoerberg](https://github.com/carlhoerberg)'s [gist](https://gist.github.com/carlhoerberg/d5537dd3990c7e3042942f587801b9cd)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'castle-keep'
```

Load and configure the library with your Castle API secret in an initializer or similar.

```ruby
Castle.api_secret = 'YOUR_API_SECRET'
```

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/castle-keep.
