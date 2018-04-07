 module SponsoredBenefits
  module BenefitSponsorships
    class FamilyRelationshipBenefitMap

      RELATIONSHIP_KINDS = [
        :employee,
        :spouse,
        :domestic_partner,
        :child_under_26,
        :child_26_and_over
      ]

      RELATIONSHIP_MAP = {
        employee:           {
                              age_range: 0..0,
                              relationships: [
                                  :self
                                ],
                              is_disabled: :any,
                          },
        spouse:             {},
        domestic_partner:   {},
        child_under_26:     {
                              age_range: 0..25,
                              relationships: [
                                  :child, 
                                ],
                              is_disabled: :any,
          },
        child_26_and_over:  {
                              age_range: 26..0,
                              relationships: [
                                  :child,
                                ],
                              is_disabled: :any,
          },
      }


      embeds_many :family_relationship_benefit_items, 
                    class_name: "SponsoredBenefits::BenefitSponsorships::FamilyRelationshipBenefitItem"

    end

  end
end
