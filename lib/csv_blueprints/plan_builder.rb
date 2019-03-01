module CsvBlueprints
  class StandardElement
    def values_for_row(row, blueprint)
      blueprint.default_values(row)
    end
  end

  class CustomizedElement < StandardElement
    def initialize(overrides)
      @overrides = overrides
    end

    def values_for_row(row, blueprint)
      values = super

      @overrides.each_pair do |column, value|
        if values.key?(column)
          values[column] = value
        end
      end

      values
    end
  end

  class PlanBuilder
    attr_reader :rows

    def initialize(blueprint)
      @blueprint = blueprint
      @rows = []
    end

    def standard(number)
      number.times { @rows << StandardElement.new }
      self
    end

    def customized(number, overrides)
      number.times { @rows << CustomizedElement.new(overrides) }
      self
    end

    def write(out = StringIO.new)
      PlanWriter.new(self, @blueprint).write(out)
    end

    def each
      @rows.each
    end
  end
end
