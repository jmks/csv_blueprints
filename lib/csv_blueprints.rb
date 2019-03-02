require "csv_blueprints/plan"
require "csv_blueprints/plan_writer"
require "csv_blueprints/plan_builder"
require "csv_blueprints/blueprint"

require "csv_blueprints/version"

module CsvBlueprints
  def self.specify(&block)
    Blueprint.new.tap do |blueprint|
      blueprint.instance_eval(&block) if block_given?
    end
  end
end
