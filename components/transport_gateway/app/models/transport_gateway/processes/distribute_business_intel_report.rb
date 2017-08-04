module TransportGateway
  class Processes::BusinessIntelReportProcess < Process

    def initialize(source_file)
      @source_file = source_file

      add_step(route_to(aws_s3_archive, source_file))
      add_step(route_to(cca_sftp_bi_folder, source_file))
      add_step(delete_file(source_file))
    end


  private
    def to_file()

    end

  end
end
