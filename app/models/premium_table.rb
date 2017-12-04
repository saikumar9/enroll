class PremiumTable
  include PlanModelConcerns::PremiumTableConcern
  
  embedded_in :plan
end
