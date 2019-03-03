RSpec::Matchers.define :write_csv do |csv_string|
  match do |plan|
    @actual = plan.write(StringIO.new).string

    values_match? csv_string, @actual
  end

  diffable
end
