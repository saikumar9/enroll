module SponsoredApplications
  class SponsoredApplicationsController < ApplicationController
    helper Rails.application.routes.url_helpers
    def index
    end

    def new
    end

    private
    helper_method :broker_agency_profile, :sponsor

    def broker_agency_profile
      @broker_agency_profile ||= BrokerAgencyProfile.find(params[:broker_id])
    end

    def sponsor
      @employer_profile ||= EmployerProfile.find(params[:sponsor_id])
    end

  end
end
