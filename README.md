# Teamstuff

This gem provides programmatic access to the Teamstuff system. As Teamstuff does not provide official support for API's,
this gem uses the same APIs as used by the webapp.

Code was based on an older (unmaintained) Pyhton package: 'teamstuff-api'. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'teamstuff'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install teamstuff

## Usage

Most rspec tests are run against the actual teamstuff API. For the tests to run/pass, please provide valid credentials 
in these environment variables: `TS_USERNAME`, `TS_PASSWORD`.

e.g. run tests like

```bash
TS_USERNAME='grotemeneer@haagscherugbyclub.nl' TS_PASSWORD='ewirfjwpqo43098j' rake
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eflukx/teamstuff. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in this project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/teamstuff/blob/master/CODE_OF_CONDUCT.md).
