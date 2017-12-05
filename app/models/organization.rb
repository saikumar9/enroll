class Organization  
  include CoreModelConcerns::OrganizationConcern
  include BrokerModelConcerns::BrokerOrganizationConcern
  include SetCurrentUser
  
  include Acapi::Notifiers
  extend Acapi::Notifiers
  
  extend Mongorder


  embeds_one :employer_profile, cascade_callbacks: true, validate: true  ##Shop Concern
  embeds_one :carrier_profile, cascade_callbacks: true, validate: true ## PlanConcern
  
  embeds_many :documents, as: :documentable
  
  accepts_nested_attributes_for :employer_profile, :carrier_profile

  # CarrierProfile child model indexes
  index({"carrier_profile._id" => 1}, { unique: true, sparse: true })



  # EmployerProfile child model indexes
  index({"employer_profile._id" => 1}, { unique: true, sparse: true })
  index({"employer_profile.aasm_state" => 1})

  index({"employer_profile.plan_years._id" => 1}, { unique: true, sparse: true })
  index({"employer_profile.plan_years.aasm_state.start_on" => 1})
  index({"employer_profile.plan_years.start_on" => 1})
  index({"employer_profile.plan_years.end_on" => 1})
  index({"employer_profile.plan_years.open_enrollment_start_on" => 1})
  index({"employer_profile.plan_years.open_enrollment_end_on" => 1})
  index({"employer_profile.plan_years.benefit_groups._id" => 1})
  index({"employer_profile.plan_years.benefit_groups.reference_plan_id" => 1})

  index({"employer_profile.workflow_state_transitions.transition_at" => 1,
         "employer_profile.workflow_state_transitions.to_state" => 1},
         { name: "employer_profile_workflow_to_state" })

  index({"employer_profile.broker_agency_accounts._id" => 1})
  index({"employer_profile.broker_agency_accounts.is_active" => 1,
         "employer_profile.broker_agency_accounts.broker_agency_profile_id" => 1},
         { name: "active_broker_accounts_broker_agency" })
  index({"employer_profile.broker_agency_accounts.is_active" => 1,
         "employer_profile.broker_agency_accounts.writing_agent_id" => 1 },
         { name: "active_broker_accounts_writing_agent" })


  index({"employer_profile.general_agency_accounts._id" => 1})
  index({"employer_profile.broker_agency_accounts.is_active" => 1,
         "employer_profile.broker_agency_accounts.broker_agency_profile_id" => 1,
         "fein" => 1, "legal_name" => 1, "dba" => 1},
         { name: "broker_agency_employer_search_index" })

  scope :employer_by_hbx_id,                  ->( employer_id ){ where(hbx_id: employer_id, "employer_profile" => { "$exists" => true }) }
  scope :by_broker_agency_profile,            ->( broker_agency_profile_id ) { where(:'employer_profile.broker_agency_accounts' => {:$elemMatch => { is_active: true, broker_agency_profile_id: broker_agency_profile_id } }) }
  scope :by_broker_role,                      ->( broker_role_id ){ where(:'employer_profile.broker_agency_accounts' => {:$elemMatch => { is_active: true, writing_agent_id: broker_role_id                   } }) }
  scope :approved_broker_agencies,            ->{ where("broker_agency_profile.aasm_state" => 'is_approved') }
  scope :broker_agencies_by_market_kind,      ->( market_kind ) { any_in("broker_agency_profile.market_kind" => market_kind) }
  scope :all_employers_by_plan_year_start_on, ->( start_on ){ unscoped.where(:"employer_profile.plan_years.start_on" => start_on)  if start_on.present? }
  scope :plan_year_start_on_or_after,         ->( start_on ){ where(:"employer_profile.plan_years.start_on".gte => start_on) if start_on.present? }
  scope :by_general_agency_profile,           ->( general_agency_profile_id ) { where(:'employer_profile.general_agency_accounts' => {:$elemMatch => { aasm_state: "active", general_agency_profile_id: general_agency_profile_id } }) }
  scope :er_invoice_data_table_order,         ->{ reorder(:"employer_profile.plan_years.start_on".asc, :"legal_name".asc)}
  scope :all_employers_renewing,              ->{ unscoped.any_in(:"employer_profile.plan_years.aasm_state" => PlanYear::RENEWING) }
  scope :all_employers_renewing_published,    ->{ unscoped.any_in(:"employer_profile.plan_years.aasm_state" => PlanYear::RENEWING_PUBLISHED_STATE) }
  scope :all_employers_non_renewing,          ->{ unscoped.any_in(:"employer_profile.plan_years.aasm_state" => PlanYear::PUBLISHED) }

  # Enrolling Scopes
  scope :employer_profiles_enrolling,         ->{ where(:"employer_profile.plan_years.aasm_state".in => PlanYear::INITIAL_ENROLLING_STATE + PlanYear::RENEWING) }
  scope :employer_profiles_initial_eligible,  ->{ where(:"employer_profile.aasm_state" => "registered") }
  scope :employer_profiles_renewing,          ->{ where(:"employer_profile.plan_years.aasm_state".in => PlanYear::RENEWING) }
  scope :employer_profiles_open_enrollment,   ->{ where(:"employer_profile.plan_years.aasm_state".in => PlanYear::OPEN_ENROLLMENT_STATE) }
  scope :employer_profiles_binder_pending,    ->{ where(:"employer_profile.plan_years.aasm_state" => "invoice_generated") }
  scope :employer_profiles_binder_paid,       ->{ where(:"employer_profile.aasm_state" => "binder_paid") }

  # Enrolled Scopes
  scope :employer_profiles_enrolled,          ->{ where(:"employer_profile.aasm_state".in => EmployerProfile::ENROLLED_STATE) }
  scope :employer_profiles_suspended,         ->{ where(:"employer_profile.aasm_state" => "suspended") }

  # Applicant Scopes
  scope :employer_profiles_applicants,        ->{ where(:"employer_profile.aasm_state" => "applicant") }

  # Open enrollments
  scope :employer_profiles_renewing_open_enrollment,  -> { where(:"employer_profile.plan_years.aasm_state" => "renewing_enrolling") }
  scope :employer_profiles_initial_open_enrollment,  -> { where(:"employer_profile.plan_years.aasm_state" => "enrolling") }

  # Applicantion Pending
  scope :employer_profiles_renewing_application_pending,  -> { where(:"employer_profile.plan_years.aasm_state" => "renewing_publish_pending") }
  scope :employer_profiles_initial_application_pending,  -> { where(:"employer_profile.plan_years.aasm_state" => "publish_pending") }


  scope :all_employers_enrolled,              ->{ unscoped.where(:"employer_profile.plan_years.aasm_state" => "enrolled") }
  scope :all_employer_profiles,               ->{ unscoped.exists(employer_profile: true) }
  scope :invoice_view_all,                    ->{ unscoped.where(:"employer_profile.plan_years.aasm_state".in => EmployerProfile::INVOICE_VIEW_RENEWING + EmployerProfile::INVOICE_VIEW_INITIAL, :"employer_profile.plan_years.start_on".gte => TimeKeeper.date_of_record.next_month.beginning_of_month) }
  scope :employer_profile_renewing_coverage,  ->{ where(:"employer_profile.plan_years.aasm_state".in => EmployerProfile::INVOICE_VIEW_RENEWING) }
  scope :employer_profile_initial_coverage,   ->{ where(:"employer_profile.plan_years.aasm_state".nin => EmployerProfile::INVOICE_VIEW_RENEWING, :"employer_profile.plan_years.aasm_state".in => EmployerProfile::INVOICE_VIEW_INITIAL) }
  scope :employer_profile_plan_year_start_on, ->(begin_on){ where(:"employer_profile.plan_years.start_on" => begin_on) if begin_on.present? }
  scope :offset,                              ->(cursor = 0)      {skip(cursor) if cursor.present?}
  scope :limit,                               ->(page_size = 25)  {limit(page_size) if page_size_present?}
  scope :all_employers_by_plan_year_start_on_and_valid_plan_year_statuses,   ->(start_on){
    unscoped.where(
      :"employer_profile.plan_years" => {
        :$elemMatch => {
          :"aasm_state".in => PlanYear::PUBLISHED + PlanYear::RENEWING,
          start_on: start_on
        }
      })
  }

  scope :employer_attestations, -> { where(:"employer_profile.employer_attestation.aasm_state".in => ['submitted', 'pending', 'approved', 'denied']) }
  scope :employer_attestations_submitted, -> { where(:"employer_profile.employer_attestation.aasm_state" => 'submitted') }
  scope :employer_attestations_pending, -> { where(:"employer_profile.employer_attestation.aasm_state" => 'pending') }
  scope :employer_attestations_approved, -> { where(:"employer_profile.employer_attestation.aasm_state" => 'approved') }
  scope :employer_attestations_denied, -> { where(:"employer_profile.employer_attestation.aasm_state" => 'denied') }

  scope :employer_profiles_with_attestation_document, -> { exists(:"employer_profile.employer_attestation.employer_attestation_documents" => true) }

  def invoices
    documents.select{ |document| document.subject == 'invoice' }
  end

  def current_month_invoice
    documents.select{ |document| document.subject == 'invoice' && document.date.strftime("%Y%m") == TimeKeeper.date_of_record.strftime("%Y%m")}
  end

  def self.retrieve_employers_eligible_for_binder_paid
    date = TimeKeeper.date_of_record.end_of_month + 1.day
    all_employers_by_plan_year_start_on_and_valid_plan_year_statuses(date)
  end

  def self.open_enrollment_year
    if ("#{TimeKeeper.date_of_record.year}-11-01".to_date.."#{TimeKeeper.date_of_record.year}-12-31".to_date).cover?(TimeKeeper.date_of_record)
      TimeKeeper.date_of_record.year + 1
    else
      TimeKeeper.date_of_record.year
    end
  end

  def self.load_carriers(filters = { sole_source_only: false, primary_office_location: nil, selected_carrier_level: nil, active_year: nil })
    cache_string = "load-carriers"
    if (filters[:selected_carrier_level].present?)
      cache_string << "-for-#{filters[:selected_carrier_level]}"
    else
      cache_string << ""
    end

    if (filters[:primary_office_location].present?)
      office_location = filters[:primary_office_location]
      cache_string << "-#{office_location.address.zip}-#{office_location.address.county}"
    end

    if filters[:active_year].present?
      cache_string << "-carrier-names-at-#{filters[:active_year]}"
    else
      cache_string << "-carrier-names-at-#{TimeKeeper.date_of_record.year}"
    end

    Rails.cache.fetch(cache_string, expires_in: 2.hour) do
      Organization.exists(carrier_profile: true).inject({}) do |carrier_names, org|
        ## don't enable Tufts for now
        next carrier_names if org.fein == '800721489'

        unless (filters[:primary_office_location].nil?)
          next carrier_names unless CarrierServiceArea.valid_for?(office_location: office_location, carrier_profile: org.carrier_profile)
          if filters[:active_year]
            if filters[:active_year].to_s == '2017'
              # only include HNE, BMCHP, Fallon
              next carrier_names if ['041045815','042452600','234547586'].include? org.fein
            end
            next carrier_names if CarrierServiceArea.valid_for_carrier_on(address: office_location.address, carrier_profile: org.carrier_profile, year: filters[:active_year]).empty?
          end
        end
        if (filters[:sole_source_only]) ## Only sole source carriers requested
          next carrier_names unless org.carrier_profile.offers_sole_source?  # skip carrier unless it is a sole source provider
        end
        carrier_names[org.carrier_profile.id.to_s] = org.carrier_profile.legal_name if Plan.valid_shop_health_plans("carrier", org.carrier_profile.id).present?
        carrier_names
      end
    end
  end

  def self.valid_carrier_names(filters = { sole_source_only: false, primary_office_location: nil, selected_carrier_level: nil, active_year: nil })

    if (filters[:selected_carrier_level].present?)
      cache_string = "for-#{filters[:selected_carrier_level]}"
    else
      cache_string = ""
    end

    if (filters[:primary_office_location].present?)
      office_location = filters[:primary_office_location]
      cache_string << "-#{office_location.address.zip}-#{office_location.address.county}"
    end

    if filters[:active_year].present?
      cache_string << "-carrier-names-at-#{filters[:active_year]}"
    else
      cache_string << "-carrier-names-at-#{TimeKeeper.date_of_record.year}"
    end

    Rails.cache.fetch(cache_string, expires_in: 2.hour) do
      Organization.exists(carrier_profile: true).inject({}) do |carrier_names, org|
        ## don't enable Tufts for now
        next carrier_names if org.fein == '800721489'
        unless (filters[:primary_office_location].nil?)
          next carrier_names unless CarrierServiceArea.valid_for?(office_location: office_location, carrier_profile: org.carrier_profile)
          if filters[:active_year]
            next carrier_names if CarrierServiceArea.valid_for_carrier_on(address: office_location.address, carrier_profile: org.carrier_profile, year: filters[:active_year]).empty?
          end
        end
        if (filters[:sole_source_only]) ## Only sole source carriers requested
          next carrier_names unless org.carrier_profile.offers_sole_source?  # skip carrier unless it is a sole source provider
        end

        if (filters[:active_year])
          carrier_plans = Plan.valid_shop_health_plans("carrier", org.carrier_profile.id, filters[:active_year])
        else
          carrier_plans = Plan.valid_shop_health_plans("carrier", org.carrier_profile.id)
        end

        if (filters[:selected_carrier_level])
          case filters[:selected_carrier_level]
          when 'single_carrier'
            carrier_plans.select! { |plan| plan.is_vertical }
          when 'metal_level'
            carrier_plans.select! { |plan| plan.is_horizontal }
          when 'sole_source'
            carrier_plans.select! { |plan| plan.is_sole_source }
          end
        end
        carrier_names[org.carrier_profile.id.to_s] = org.carrier_profile.legal_name if carrier_plans.any?
        carrier_names
      end
    end
  end

  def self.valid_dental_carrier_names
    Rails.cache.fetch("dental-carrier-names-at-#{TimeKeeper.date_of_record.year}", expires_in: 2.hour) do
      Organization.exists(carrier_profile: true).inject({}) do |carrier_names, org|

        carrier_names[org.carrier_profile.id.to_s] = org.carrier_profile.legal_name if Plan.valid_shop_dental_plans("carrier", org.carrier_profile.id, 2016).present?
        carrier_names
      end
    end
  end

  def self.valid_carrier_names_filters
    Rails.cache.fetch("carrier-names-filters-at-#{TimeKeeper.date_of_record.year}", expires_in: 2.hour) do
      Organization.exists(carrier_profile: true).inject({}) do |carrier_names, org|
        carrier_names[org.carrier_profile.id.to_s] = org.carrier_profile.legal_name
        carrier_names
      end
    end
  end

  def self.valid_dental_carrier_names_for_options
    Organization.valid_dental_carrier_names.invert.to_a
  end

  def self.valid_carrier_names_for_options(**args)
    Organization.valid_carrier_names(args).invert.to_a
  end

  def self.upload_invoice(file_path,file_name)
    invoice_date = invoice_date(file_path) rescue nil
    org = by_invoice_filename(file_path) rescue nil
    if invoice_date && org && !invoice_exist?(invoice_date,org)
      doc_uri = Aws::S3Storage.save(file_path, "invoices",file_name)
      if doc_uri
        document = Document.new
        document.identifier = doc_uri
        document.date = invoice_date
        document.format = 'application/pdf'
        document.subject = 'invoice'
        document.title = File.basename(file_path)
        org.documents << document
        logger.debug "associated file #{file_path} with the Organization"
        return document
      end
    else
      logger.warn("Unable to associate invoice #{file_path}")
    end
  end

  def self.upload_invoice_to_print_vendor(file_path,file_name)
    org = by_invoice_filename(file_path) rescue nil
    if org.employer_profile.is_converting?
      bucket_name= Settings.paper_notice
      begin
        doc_uri = Aws::S3Storage.save(file_path,bucket_name,file_name)
      rescue Exception => e
        puts "Unable to upload invoices to paper notices bucket"
      end
    end
  end

  # Expects file_path string with file_name format /hbxid_mmddyyyy_invoices_r.pdf
  # Returns Date
  def self.invoice_date(file_path)
    date_string= File.basename(file_path).split("_")[1]
    Date.strptime(date_string, "%m%d%Y")
  end

  def self.invoice_exist?(invoice_date,org)
    docs =org.documents.where("date" => invoice_date)
    matching_documents = docs.select {|d| d.title.match(Regexp.new("^#{org.hbx_id}"))}
    return true if matching_documents.count > 0
  end

  def legal_name_or_fein_change_attributes
    @changed_fields = changed_attributes.keys
    notify_legal_name_or_fein_change if changed_attributes.keys.include?("fein")
  end

  def notify_legal_name_or_fein_change
    return unless self.employer_profile.present?
    FIELD_AND_EVENT_NAMES_MAP.each do |feild, event_name|
      if @changed_fields.present? && @changed_fields.include?(feild)
        notify("acapi.info.events.employer.#{event_name}", {employer_id: self.hbx_id, event_name: "#{event_name}"})
      end
    end
  end

  def notify_address_change(old_address_attribute,new_address_attribute)
    changed_address = []
    old_address_dup = old_address_attribute.clone
    new_address_attribute["office_locations_attributes"].each_value do |address|
      old_address = old_address_dup.select{|s| s["address"]["kind"] == address["address_attributes"]["kind"]}
      old_address_dup.delete_if{|s| s["address"]["kind"] == address["address_attributes"]["kind"]}
      keys = address["address_attributes"].keys
      new_address_values = address["address_attributes"].values
      old_addres_values = old_address.present? ? keys.map{|k| old_address[0]["address"]["#{k}"]} : []
      changed_address << (new_address_values == old_addres_values)
    end
    changed_address << false if old_address_dup.present?
    unless changed_address.all?
      notify("acapi.info.events.employer.address_changed", {employer_id: self.hbx_id, event_name: "address_changed"})
    end

  end

  class << self
    def employer_profile_renewing_starting_on(date_filter)
      employer_profile_renewing_coverage.employer_profile_plan_year_start_on(date_filter)
    end

    def employer_profile_initial_starting_on(date_filter)
      employer_profile_initial_coverage.employer_profile_plan_year_start_on(date_filter)
    end
  end
end
