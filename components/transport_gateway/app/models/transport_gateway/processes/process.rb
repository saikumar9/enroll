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

    def descriptions
      @steps.reduce([]) { |list, step| list << step.description + '\n'  }
    end

    def execute
      @steps.each do |step|
        step.execute
      end
    end

  end
end


process.add_command(generate_report(report_output_file))


process = distribute_notice.new(report_output_file)

process.add_command(route_to(aws_s3_archive, report_output_file))
process.add_command(route_to(cca_sftp_bi_folder, report_output_file))
process.add_command(delete_file(report_output_file))

process.execute