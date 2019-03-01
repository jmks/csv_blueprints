# CsvBlueprints

A simple and small DSL to generate CSV files.

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

You can now use this blueprint to build a plan. You can override column values here as well:

```ruby
# only want 3 rows
plan = blueprint.plan.standard(3)

# two rows with duplicate IDs
plan_with_duplicate_ids = blueprint.plan.customized(2, "ID" => 999, "Notes" => "A great person")
```

Ready to write some CSVs? Just call `write(writable_io)` on the plan.

`plan` would produce something like this (modulo `faker` data):

```
ID,Name,Login,Email,Type,Notes
1,Val Kulas DVM,email1@example.com,email1@example.com,Client,
2,Marsha Sporer,email2@example.com,email2@example.com,Client,
3,Mrs. Bennett Bechtelar,email3@example.com,email3@example.com,Client,
```

while `plan_with_duplicate_ids` would produce something like:

```
ID,Name,Login,Email,Type,Notes
999,Harry Cummings Sr.,email1@example.com,email1@example.com,Client,A great person
999,Mrs. Dessie Wunsch,email2@example.com,email2@example.com,Client,A great person
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'csv_blueprints'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install csv_blueprints

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jmks/csv_blueprints.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
