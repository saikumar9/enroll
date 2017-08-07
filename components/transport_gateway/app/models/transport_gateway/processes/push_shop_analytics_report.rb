module TransportGateway
  class Processes::PushShopAnalyticsReport < Process

    def initialize(report_file_name)
      super("Distribute system generated reports to defined data stores")

      @report_file_name = report_file_name

      add_step(TransportGateway::Steps::RouteTo(:aca_shop_analytics_outbound, report_file_name))
      add_step(TransportGateway::Steps::RouteTo(:aca_shop_analytics_archive, report_file_name))
      add_step(TransportGateway::Steps::DeleteFile(report_file_name))
    end

  end
end
