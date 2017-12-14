module SponsoredApplications
  class SponsorCensusMemberBuilder
    attr_reader :sponsor_census_members

    def initialize(members)
      @sponsor_census_members = build_sponsored_members_from_array(members)
    end

    def build_sponsored_members_from_array(members)
      return members.map do |member|
        new_member = SponsorCensusMember.create(common_member_attributes(member))
        dependents = if member.is_a? Hash
          member[:census_dependents]
        else
          member.census_dependents
        end

        dependents.each do |dependent|
          new_member.census_dependents.create!(common_member_attributes(dependent))
        end
        new_member
      end
    end

    def build_census_members_from_sponsor_members
      return [] if @sponsor_census_members.any? { |m| m.ssn.blank? }
      @sponsor_census_members.map do |member|
        new_member = CensusMember.find_or_initialize_by(ssn: member.ssn)
        new_member.update_attributes!(common_member_attributes(member))
        new_member
      end
    end

    private

    def common_member_attributes(obj)
      common_keys = %i(first_name middle_name last_name name_sfx dob gender ssn employee_relationship)

      attributes = {}
      common_keys.each do |key|
        attributes[key] = if obj.is_a? Hash
          obj[key]
        else
          obj.send(key)
        end
      end
      attributes
    end
  end
end
