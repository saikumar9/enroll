class BrokerAgencies::EmployerProspectsController < ApplicationController
  layout 'single_column'

  def new
    @id = broker_agency_profile
    @provider = current_user.person

  end

  private
  helper_method :broker_agency_profile

  def broker_agency_profile
    @broker_agency_profile ||= BrokerAgencyProfile.find(params[:profile_id])
  end
end
