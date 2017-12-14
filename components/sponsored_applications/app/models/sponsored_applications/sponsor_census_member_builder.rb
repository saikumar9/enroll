module SponsoredApplications
  class SponsorCensusMemberBuilder
    attr_reader :sponsor_census_members

    def initialize(members)
      @sponsor_census_members = build_sponsored_members_from_array(members)
    end

    def build_sponsored_members_from_array(members)
      return members.map do |member|
        new_member = SponsorCensusMember.create(common_member_attributes(member))
        member.census_dependents.each do |dependent|
          new_member.census_dependents.create!(common_member_attributes(dependent))
        end
        new_member
      end
    end

    def build_census_members_from_sponsor_members
      array = @sponsor_census_members.map do |member|
        return if member.ssn.blank?
        new_member = CensusMember.find_or_initialize_by(ssn: member.ssn)
        new_member.update_attributes!(common_member_attributes(member))
        new_member
      end
      array
    end

    private

    def common_member_attributes(obj)
      common_keys = %i(first_name middle_name last_name name_sfx dob gender ssn employee_relationship)
      attributes = {}
      common_keys.each do |key|
        attributes[key] = obj.send(key)
      end
      attributes
    end
  end
end
