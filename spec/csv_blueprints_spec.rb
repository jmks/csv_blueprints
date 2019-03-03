require "spec_helper"

RSpec.describe CsvBlueprints do
  describe ".specify" do
    it "writes static values" do
      blueprint = CsvBlueprints.specify do
        column "First Name", value: "Turd"
        column "Last Name", value: "Ferguson"
      end
      plan = blueprint.plan.standard(1)

      expect(plan).to write_csv(<<~CSV)
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

      expect(plan).to write_csv(<<~CSV)
        Name,Job,Income
        Philip,Delivery Boy,
      CSV
    end

    it "writes sequences" do
      blueprint = CsvBlueprints.specify do
        column "Count", value: :sequence
      end
      plan = blueprint.plan.standard(3)

      expect(plan).to write_csv(<<~CSV)
        Count
        1
        2
        3
      CSV
    end

    it "writes computed values" do
      blueprint = CsvBlueprints.specify do
        column "Robots", value: -> i { "Bender #{i}" }
      end
      plan = blueprint.plan.standard(3)

      expect(plan).to write_csv(<<~CSV)
        Robots
        Bender 1
        Bender 2
        Bender 3
      CSV
    end

    it "customizes values" do
      blueprint = CsvBlueprints.specify do
        column "Number", value: :sequence
        column "Robots", value: -> i { "Bender #{i}" }
      end
      plan = blueprint.plan
               .customized(1, "Robots" => "Bendotron 3000")
               .standard(2)
               .customized(2, "Robots" => "Roomba")

      expect(plan).to write_csv(<<~CSV)
        Number,Robots
        1,Bendotron 3000
        2,Bender 2
        3,Bender 3
        4,Roomba
        5,Roomba
      CSV
    end

    it "writes a single value to many columns" do
      blueprint = CsvBlueprints.specify do
        column "Name", value: "Philip J Fry"
        columns "Login", "Email", value: "philip.jfry@gmail.com"
      end
      plan = blueprint.plan.standard(1)

      expect(plan).to write_csv(<<~CSV)
        Name,Login,Email
        Philip J Fry,philip.jfry@gmail.com,philip.jfry@gmail.com
      CSV
    end

    it "writes the same computed value for multiple columns" do
      data_source = %w(Bender Flexo Bendher).cycle

      blueprint = CsvBlueprints.specify do
        column "Name", value: -> i { "Bender #{i}"}
        columns "Username", "Login", value: -> _ { data_source.next }
      end
      plan = blueprint.plan.standard(3)

      expect(plan).to write_csv(<<~CSV)
        Name,Username,Login
        Bender 1,Bender,Bender
        Bender 2,Flexo,Flexo
        Bender 3,Bendher,Bendher
      CSV
    end
  end
end
