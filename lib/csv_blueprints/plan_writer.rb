require "csv"

module CsvBlueprints
  class PlanWriter
    def initialize(plan, blueprint)
      @plan = plan
      @blueprint = blueprint
    end

    def write(out)
      csv = CSV.new(out, headers: @blueprint.column_names, write_headers: true)

      @plan.each.with_index do |element, index|
        csv << element.values_for_row(index + 1, @blueprint)
      end

      csv
    end
  end
end
