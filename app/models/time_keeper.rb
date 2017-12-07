class TimeKeeper
  include CoreModelConcerns::TimeKeeperConcern
  include ShopModelConcerns::ShopTimeKeeperConcern

  include Config::AcaModelConcern
  include Acapi::Notifiers
  extend Acapi::Notifiers

  def push_date_of_record
    Family.advance_day(self.date_of_record) if individual_market_is_enabled?
    HbxEnrollment.advance_day(self.date_of_record)
    CensusEmployee.advance_day(self.date_of_record)
    ConsumerRole.advance_day(self.date_of_record)
    super
  end

  def push_date_change_event
    ModelEvents::PlanYear.date_change_event(self.date_of_record)
  end
end
