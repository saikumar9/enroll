PlanModelConcerns.configure do |config|
  config.settings = Settings
  
  class PlanModelConcerns::TimeKeeper < TimeKeeper
  end

  class PlanModelConcerns::WorkflowStateTransition < WorkflowStateTransition
  end
end
