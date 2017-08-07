module TransportGateway
  class Processes::Process

    attr_reader :descriptions

    def initialize(description)
      @description = description
      @steps = []
    end

    def add_step(new_step)
      @steps << new_step
    end

    def step_descriptions
      @steps.map { |step| step[:description] + '\n'  }
    end

    def execute
      @steps.each do |step|
        begin
          # TODO add logging at start and end of step execution
          step.execute
        rescue => e
          # TODO add error logging
          # TODO determine if steps should continue when an error is raised
        end
      end
    end

  end
end
