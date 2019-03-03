RSpec::Matchers.define :write_csv do |csv_string|
  match do |plan|
    output = plan.write(StringIO.new).string

    expect(output).to eq(csv_string)
  end
end
