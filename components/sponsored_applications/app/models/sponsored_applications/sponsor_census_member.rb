module SponsoredApplications
  class SponsorCensusMember < SponsorCensusMemberBase
    def self.dependent_class
      'SponsoredApplications::SponsorCensusDependent'
    end
    
    include Behaviors::CensusDependentBehaviors
  end
end
