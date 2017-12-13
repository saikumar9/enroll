class SponsorCensusDependent
  include ShopModelConcerns::CensusDependentConcern

  def self.parent_member_class
    'SponsorCensusMember'
  end

end
