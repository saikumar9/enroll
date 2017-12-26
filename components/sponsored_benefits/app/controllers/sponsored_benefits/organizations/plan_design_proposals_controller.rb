module SponsoredBenefits
  class Organizations::PlanDesignProposalsController < ApplicationController
    include Config::BrokerAgencyHelper
    include DataTablesAdapter

    before_action :load_plan_design_organization
    before_action :load_plan_design_proposal, only: [:edit, :update, :destroy]

    def index
      @datatable = effective_datatable
    end

    def new
      @plan_design_proposal = SponsoredBenefits::Forms::PlanDesignProposal.new(organization: @plan_design_organization, proposal_id: params[:proposal_id])
      init_employee_datatable
    end

    def show
      # load relevant quote (not nested)
      # plan_design_proposal
    end

    def edit
      @plan_design_proposal = SponsoredBenefits::Forms::PlanDesignProposal.new(organization: @plan_design_organization, proposal_id: params[:id])
      init_employee_datatable
    end

    def create
      proposal_form = SponsoredBenefits::Forms::PlanDesignProposal.new({
        organization: @plan_design_organization
        }.merge(plan_design_proposal_params))

      respond_to do |format|
        if proposal_form.save
          @plan_design_proposal = proposal_form
          format.html { redirect_to edit_organizations_plan_design_organization_plan_design_proposal_path(@plan_design_organization, proposal_form.proposal), :flash => { :success => "Quote information save successfully."} } 
        else
          format.html { redirect_to :back, :flash => { :error => "Failed! unable to save quote information."} }
        end
      end
    end

    def update
      proposal_form = SponsoredBenefits::Forms::PlanDesignProposal.new({
        organization: @plan_design_organization, proposal_id: params[:id]
        }.merge(plan_design_proposal_params))

      respond_to do |format|
        if proposal_form.save
          @plan_design_proposal = proposal_form
          format.html { redirect_to edit_organizations_plan_design_organization_plan_design_proposal_path(@plan_design_organization, proposal_form.proposal), :flash => { :success => "Quote information updated successfully."} } 
        else
          format.html { redirect_to :back, :flash => { :error => "Failed! unable to update quote information."} }
        end
      end
    end

    def destroy
      plan_design_proposal.destroy!
      redirect_to benefit_sponsorship_plan_design_proposals_path(plan_design_proposal.benefit_sponsorship)
    end

    private

    helper_method :customer, :broker, :plan_design_organization

    def broker
      @broker ||= SponsoredBenefits::Organizations::BrokerAgencyProfile.find(plan_design_organization.owner_profile_id)
    end

    def customer
      @customer ||= ::EmployerProfile.find(plan_design_organization.customer_profile_id)
    end

    def effective_datatable
      ::Effective::Datatables::BrokerEmployerQuotesDatatable.new(organization_id: @plan_design_organization._id)
    end

    def load_plan_design_organization
      @plan_design_organization = SponsoredBenefits::Organizations::PlanDesignOrganization.find(params[:plan_design_organization_id])
      broker_agency_profile
    end

    def broker_agency_profile
      @broker_agency_profile = @plan_design_organization.broker_agency_profile
    end


    # def benefit_sponsorship
    #   broker.benefit_sponsorships.first || broker.benefit_sponsorships.new
    # end

    # def benefit_sponsorship_applications
    #   @benefit_sponsorship_applicatios ||= benefit_sponsorship.plan_design_proposals
    # end

    def load_plan_design_proposal
      @plan_design_proposal ||= Organizations::PlanDesignProposal.find(params[:id])
    end

    def plan_design_proposal_params
      params.require(:forms_plan_design_proposal).permit(
        :title,
        :effective_date,
        profile: [
          benefit_sponsorship: [
            :initial_enrollment_period,
            :annual_enrollment_period_begin_month_of_year,
            benefit_application: [
              :effective_period,
              :open_enrollment_period
            ]
          ]
        ]
        )
    end

    def init_employee_datatable
      sponsorship = @plan_design_proposal.profile.benefit_sponsorships.first
      @census_employees = sponsorship.census_employees
      @datatable = Effective::Datatables::PlanDesignEmployeeDatatable.new({id: sponsorship.id, scopes: params[:scopes]})
    end
  end
end