module SponsoredApplications
  class BenefitGroup
    include ShopModelConcerns::SharedBenefitGroupConcern

    embedded_in :sponsored_application

  end
end
