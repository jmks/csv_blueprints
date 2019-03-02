module CsvBlueprints
  Column = Struct.new(:name, :value) do
    def value_for(i)
      if value.respond_to?(:call)
        value.call(i)
      else
        value
      end
    end
  end

  class RepeatedValue
    def initialize(callable, times)
      @callable = callable
      @times = times
      @invocations = 0
    end

    def call(i)
      if @invocations < @times
        @repeated_value ||= @callable.call(i)
      else
        @invocations = 0
        @repeated_value = @callable.call(i)
      end

      @invocations += 1
      @repeated_value
    end
  end

  class Blueprint
    def initialize
      @columns = []
    end

    def column(name, value: nil)
      @columns << column_for_value(name, value)
    end

    def columns(*names, value:)
      wrapped_value = value.respond_to?(:call) ? RepeatedValue.new(value, names.length) : value

      names.each { |name| column(name, value: wrapped_value) }
    end

    def plan
      PlanBuilder.new(self)
    end

    def column_names
      @columns.map(&:name)
    end

    def default_values(row)
      Hash[@columns.map { |c| [c.name, c.value_for(row)] }]
    end

    private

    def column_for_value(name, value)
      case value
      when :blank
        Column.new(name, nil)
      when :sequence
        Column.new(name, -> i { i })
      else
        Column.new(name, value)
      end
    end
  end
end
