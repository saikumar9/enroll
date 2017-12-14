module SponsoredApplications
  class SponsorCensusDependent < SponsorCensusMemberBase
    def self.parent_member_class
      'SponsoredApplications::SponsorCensusMember'
    end
    include CensusDependentConcern
  end
end
