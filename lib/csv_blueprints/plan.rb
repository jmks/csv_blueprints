module CsvBlueprints
  class Plan
    class StandardRow
      def values_for(index, blueprint)
        blueprint.default_values(index)
      end
    end

    class CustomizedRow < StandardRow
      def initialize(overrides)
        @overrides = overrides
      end

      def values_for(index, blueprint)
        values = super

        @overrides.each_pair do |column, value|
          if values.key?(column)
            values[column] = value
          end
        end

        values
      end
    end

    def initialize(blueprint)
      @blueprint = blueprint
      @rows = []
    end

    def add_row(overrides = {})
      if overrides.any?
        @rows << CustomizedRow.new(overrides)
      else
        @rows << StandardRow.new
      end
    end

    def column_names
      @blueprint.column_names
    end

    def each_row
      @rows.each.with_index do |row, index|
        yield row.values_for(index + 1, @blueprint)
      end
    end
  end
end
