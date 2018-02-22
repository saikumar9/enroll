module TransportProfiles
  class Processes::PushNfpCommissionStatement < Processes::Process

    def initialize(report_file_name, gateway)
      super("Distribute system generated reports to defined data stores", gateway)

      @report_file_name = report_file_name

      add_step(TransportProfiles::Steps::UnzipFile.new(report_file_name, :statement_files, :temp_dir, gateway))
       route = TransportProfiles::Steps::RouteTo.new(:s3_commision_statement_bucket_name, :statement_files, gateway)
       route.on_success do |a,b,c|
         puts "Hello"
         puts a.to_s
       end

       add_step(route)
    end

    def self.used_endpoints
      [
        :aca_shop_analytics_archive,
        :aca_shop_analytics_outbound
      ]
    end

  end
end
