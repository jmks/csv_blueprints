require "spec_helper"

RSpec.describe CsvBlueprints do
  describe ".specify" do
    it "writes static values" do
      blueprint = CsvBlueprints.specify do
        column "First Name", value: "Turd"
        column "Last Name", value: "Ferguson"
      end
      plan = blueprint.plan.standard(1)

      out = plan.write

      expect(out.string).to eql(<<~CSV)
        First Name,Last Name
        Turd,Ferguson
      CSV
    end

    it "writes empty values" do
      blueprint = CsvBlueprints.specify do
        column "Name", value: "Philip"
        column "Job", value: "Delivery Boy"
        column "Income", value: :blank
      end
      plan = blueprint.plan.standard(1)

      out = plan.write

      expect(out.string).to eql(<<~CSV)
        Name,Job,Income
        Philip,Delivery Boy,
      CSV
    end

    it "writes sequences" do
      blueprint = CsvBlueprints.specify do
        column "Count", value: :sequence
      end
      plan = blueprint.plan.standard(3)

      out = plan.write

      expect(out.string).to eql(<<~CSV)
        Count
        1
        2
        3
      CSV
    end

    it "writes computed values" do
      blueprint = CsvBlueprints.specify do
        column "Robots", computed: -> i { "Bender #{i}" }
      end
      plan = blueprint.plan.standard(3)

      out = plan.write

      expect(out.string).to eql(<<~CSV)
        Robots
        Bender 1
        Bender 2
        Bender 3
      CSV
    end

    it "customizes values" do
      blueprint = CsvBlueprints.specify do
        column "Number", value: :sequence
        column "Robots", computed: -> i { "Bender #{i}" }
      end

      plan =
        blueprint.plan
          .customized(1, "Robots" => "Bendotron 3000")
          .standard(2)
          .customized(2, "Robots" => "Roomba")

      # TODO: expect(plan).to write(<<~CSV)
      #         Header,Header2
      #         Value,Value2
      #       CSV
      out = plan.write

      expect(out.string).to eql(<<~CSV)
        Number,Robots
        1,Bendotron 3000
        2,Bender 2
        3,Bender 3
        4,Roomba
        5,Roomba
      CSV
    end

    xit "writes a single value to many columns" do
      blueprint = CsvBlueprints.specify do
        column "Name", value: "Bobby Bobberson"
        columns "Login", "Email", static: "bobby.bobberson@gmail.com"
      end
      plan = blueprint.plan.standard(1)

      out = plan.write

      expect(out.string).to eq(<<~CSV)
      Name,Login,Email
      Bobby Bobberson,bobby.bobberson@gmail.com,bobby.bobberson@gmail.com
      CSV
    end
  end
end
