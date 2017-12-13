module SponsoredApplications
  class SponsorCensusMemberBuilder
    attr_reader :sponsor_census_members
    def initialize(members)
      @sponsor_census_members = build_sponsored_members_from_array(members)
    end

    def build_sponsored_members_from_array(members)
      return members
    end
  end
end
