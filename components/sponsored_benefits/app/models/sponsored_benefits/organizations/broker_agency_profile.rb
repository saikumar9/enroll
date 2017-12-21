module SponsoredBenefits
  module Organizations
    class BrokerAgencyProfile < Profile
      has_many :plan_design_organizations, class_name: "SponsoredBenefits::Organizations::PlanDesignOrganization", inverse_of: :broker_agency_profile

      field :entity_kind, type: String
      field :market_kind, type: String
      field :corporate_npn, type: String
      field :primary_broker_role_id, type: BSON::ObjectId
      field :default_general_agency_profile_id, type: BSON::ObjectId

      field :languages_spoken, type: Array, default: ["en"] # TODO
      field :working_hours, type: Boolean, default: false
      field :accept_new_clients, type: Boolean

      field :aasm_state, type: String
      field :aasm_state_set_on, type: Date
      embeds_many :documents, as: :documentable

    #  delegate :updated_by_id, :updated_by_id=, to: :organization, allow_nil: false
      delegate :updated_by, :updated_by=, to: :organization, allow_nil: false

      def updated_by_id=(val)
      end

      def inbox=(val)
      end
      # All PlanDesignOrganizations that belong to this BrokerRole/BrokerAgencyProfile
      def employer_leads
      end

      class << self

        def find(id)
          organizations = Organization.where("broker_agency_profile._id" => BSON::ObjectId.from_string(id)).to_a
          organizations.size > 0 ? organizations.first.broker_agency_profile : nil
        end

        def create_plan_design_org(broker_agency:, employer_profile:, office_locations:)
          #active_broker_agency = find(broker_agency.id)
          organization = Organization.where("broker_agency_profile._id" => BSON::ObjectId.from_string(broker_agency.id)).to_a.first.becomes(SponsoredBenefits::Organizations::Organization)
          organization.broker_agency_profile = broker_agency.becomes(SponsoredBenefits::Organizations::BrokerAgencyProfile)
          organization.save!

          puts organization
          puts organization.broker_agency_profile

        #  pdo = active_broker_agency.plan_design_organizations.find_or_initialize_by(fein: employer_profile.fein)
          # puts pdo
        #  puts active_broker_agency

          #
          # pdo.update_attributes!(
          #   owner_profile_id: active_broker_agency.id,
          #   customer_profile_id: employer_profile.id,
          #   plan_design_profile: {
          #     sic_code: employer_profile.sic_code
          #   },
          #   office_locations: office_locations,
          #   fein: employer_profile.fein,
          #   legal_name: employer_profile.legal_name,
          #   hbx_id: employer_profile.hbx_id
          # )

        end
      end
    end
  end
end
