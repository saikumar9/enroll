module SponsoredBenefits
  class ApplicationController < ActionController::Base
    before_action :set_broker_agency_profile_from_user

    private
      helper_method :active_tab, :generate_breadcrumb_links

      def active_tab
        "employers-tab"
      end

      def set_broker_agency_profile_from_user
        current_uri = request.env['PATH_INFO']
        if current_person.broker_role.present?
          @broker_agency_profile = ::BrokerAgencyProfile.find(current_person.broker_role.broker_agency_profile_id)
        elsif active_user.has_hbx_staff_role? && params[:plan_design_organization_id].present?
          @broker_agency_profile = ::BrokerAgencyProfile.find(params[:plan_design_organization_id])
        elsif params[:plan_design_proposal_id].present?
          org = SponsoredBenefits::Organizations::PlanDesignProposal.find(params[:plan_design_proposal_id]).plan_design_organization
          @broker_agency_profile = ::BrokerAgencyProfile.find(org.owner_profile_id)
        elsif params[:id].present?
          unless current_uri.include? 'broker_agency_profile'
            org = SponsoredBenefits::Organizations::PlanDesignProposal.find(params[:id]).plan_design_organization
            @broker_agency_profile = ::BrokerAgencyProfile.find(org.owner_profile_id)
          end
        end
      end

      def current_person
        current_user.person
      end

      def active_user
        current_user
      end

      def generate_breadcrumb_links(proposal, organization)
        if proposal.persisted?
          links = [sponsored_benefits.edit_organizations_plan_design_organization_plan_design_proposal_path(organization.id, proposal.id)]
          links << sponsored_benefits.new_organizations_plan_design_proposal_plan_selection_path(proposal)
        else
          links = [sponsored_benefits.new_organizations_plan_design_organization_plan_design_proposal_path(organization.id)]
        end
        unless proposal.active_benefit_group.nil?
          links << sponsored_benefits.new_organizations_plan_design_proposal_plan_review_path(proposal)
        end
        links
      end
  end
end
