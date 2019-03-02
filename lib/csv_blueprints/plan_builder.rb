module CsvBlueprints
  class PlanBuilder
    def initialize(blueprint)
      @blueprint = blueprint
      @plan = Plan.new(@blueprint)
    end

    def standard(number)
      number.times { @plan.add_row }
      self
    end

    def customized(number, overrides)
      number.times { @plan.add_row(overrides) }
      self
    end

    def write(out = StringIO.new)
      PlanWriter.new(@plan).write(out)
    end
  end
end
