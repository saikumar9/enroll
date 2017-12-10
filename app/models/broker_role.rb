class BrokerRole
  include BrokerModelConcerns::BrokerRoleConcern
  include SetCurrentUser

  embeds_many :favorite_general_agencies, cascade_callbacks: true

  def search_favorite_general_agencies(general_agency_profile_id)
    favorite_general_agencies.where(general_agency_profile_id: general_agency_profile_id)
  end

  def included_in_favorite_general_agencies?(general_agency_profile_id)
    favorite_general_agencies.present? && favorite_general_agencies.map(&:general_agency_profile_id).include?(general_agency_profile_id)
  end

  private

  def send_invitation
    if active?
      Invitation.invite_broker!(self)
    end
  end

  def notify_broker_denial
    UserMailer.broker_denied_notification(self).deliver_now
  end

  def notify_broker_pending
    unchecked_carriers = self.carrier_appointments.select { |k,v| k if v != "true"}
    UserMailer.broker_pending_notification(self,unchecked_carriers).deliver_now if unchecked_carriers.present?  || !self.training
  end
end
