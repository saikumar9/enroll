PlanModelConcerns.configure do |config|
  config.settings = Settings
  
  class PlanModelConcerns::Organization < Organization
  end
  
  class PlanModelConcerns::TimeKeeper < TimeKeeper
  end
end
