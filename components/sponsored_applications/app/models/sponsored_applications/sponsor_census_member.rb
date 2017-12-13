class SponsorCensusMember
  include CoreModelConcerns::Behaviors::CensusMemberCoreBehaviors
  include ShopModelConcerns::Behaviors::CensusDependentBehaviors

  def self.dependent_class
    "SponsorCensusDependent"
  end
end
