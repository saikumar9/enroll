module TransportProfiles
  class Processes::PushNfpCommissionStatement < Processes::Process

    def initialize(report_file_name, gateway)
      super("Distribute system generated reports to defined data stores", gateway)

      @report_file_name = report_file_name
      # Need to place in the proper bucket based on the environment context

      add_step(TransportProfiles::Steps::UnzipFile.new(report_file_name, :statement_files, :temp_dir, gateway))
      #files = TransportProfiles::Steps::UnzipFile.new(report_file_name, :statement_files, :temp_dir, gateway)
      route = TransportProfiles::Steps::RouteTo.new(:s3_commission_statement_bucket, :statement_files, gateway)


      # This callback will only be invoked when a successful drop of a commission statement has taken in s3. Once
      # that has happened it will associate the s3 details for the statment on a document instance of the organization.
      # file_uri is type URI::Generic
      # full_path e.g., "/var/folders/np/kldmqqn90n10kb866pvdf4_00000gn/T/d20180308-87937-yqzxaw/12345678_030118_commision_12-12_R.pdf"
      # directory e.g., "/var/folders/np/kldmqqn90n10kb866pvdf4_00000gn/T/d20180308-87937-yqzxaw"
      route.on_success do |file_uri, uri, process_context|
        #TODO this is where I locally update the document models
        directory = process_context.get(:temp_dir).first
        full_path = file_uri.path
        commission_statement = full_path.split(directory)[1]
        statement_date = Date.strptime(commission_statement.split('_')[1], "%m%d%Y") rescue nil
        org = Organization.by_commission_statement_filename(commission_statement) rescue nil
        if statement_date && org && !Organization.commission_statement_exist?(statement_date, org)
          doc_uri = generate_s3_uri("commission-statements", commission_statement.split('/')[1])
          document = Document.new
          document.identifier = doc_uri
          document.date = statement_date
          document.format = 'application/pdf'
          document.subject = 'commission-statement'
          document.title = File.basename(file_path)
          org.documents << document
          logger.debug "associated commission statement #{file_path} with the Organization"
          return document
        else
          logger.warn("Unable to associate commission statement #{file_path}")
        end
      end
      self.steps << route
    end

    def self.used_endpoints
      [
        :s3_commission_statement_bucket
      ]
    end

    private

    def generate_s3_uri(bucket_name, key=SecureRandom.uuid)
      env_bucket_name = "#{Settings.site.s3_prefix}-enroll-#{bucket_name}-#{aws_env}"
      "urn:openhbx:terms:v1:file_storage:s3:bucket:#{env_bucket_name}##{key}"
    end

    def aws_env
      ENV['AWS_ENV'] || "qa"
    end

  end
end
