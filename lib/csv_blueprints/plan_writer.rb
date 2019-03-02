require "csv"

module CsvBlueprints
  class PlanWriter
    def initialize(plan)
      @plan = plan
    end

    def write(out)
      csv = CSV.new(out, headers: @plan.column_names, write_headers: true)

      @plan.each_row { |row| csv << row }

      csv
    end
  end
end
