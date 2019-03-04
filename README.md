# CSV Blueprints

[![Build Status](https://travis-ci.com/jmks/csv_blueprints.svg?branch=master)](https://travis-ci.com/jmks/csv_blueprints)

A simple and small DSL to generate CSV files.

## Usage

Declaratively specify a CSV blueprint:

```ruby
require "csv_blueprints"
require "faker"

blueprint = CsvBlueprints.specify do
  column "ID", value: :sequence
  column "Name", value: -> i { Faker::Name.name }
  columns "Login", "Email", value: -> i { "email#{i}@example.com" }
  column "Type", static: "Client"
  column "Notes", value: :blank
end
```

> We're using the [faker](https://github.com/stympy/faker) gem here for realistic names

This one blueprint can generate multiple plans. E.g. differing numbers of rows or to override the row's values:

```ruby
# three rows
plan = blueprint.plan.standard(3)
plan.write
```

will generate a CSV like:

```
ID,Name,Login,Email,Type,Notes
1,Val Kulas DVM,email1@example.com,email1@example.com,Client,
2,Marsha Sporer,email2@example.com,email2@example.com,Client,
3,Mrs. Bennett Bechtelar,email3@example.com,email3@example.com,Client,
```

Another plan from the same blueprint

```ruby
# two rows with duplicate IDs and a note
plan_with_duplicate_ids = blueprint.plan.customized(2, "ID" => 999, "Notes" => "Imported on #{Date.today.strftime('%Y-%m-%d')}")
plan_with_duplicate_ids.write
```

would generate

```
ID,Name,Login,Email,Type,Notes
999,Tiffanie Schaden,email1@example.com,email1@example.com,Client,Imported on 2019-03-04
999,Mr. Arie Stroman,email2@example.com,email2@example.com,Client,Imported on 2019-03-04
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem "csv_blueprints"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install csv_blueprints

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jmks/csv_blueprints.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
