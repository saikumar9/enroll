LocationModelConcerns.configure do |config|
  config.settings = Settings
  
  class LocationModelConcerns::TimeKeeper < TimeKeeper
  end

  class LocationModelConcerns::WorkflowStateTransition < WorkflowStateTransition
  end
end
