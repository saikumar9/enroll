class BrokerAgencyAccount
  include BrokerModelConcerns::BrokerAgencyAccountConcern
  include ShopModelConcerns::BrokerAgencyAccountShopConcern
  include SetCurrentUser

  embedded_in :family

  # belongs_to broker_agency_profile

  def ba_name
    Rails.cache.fetch("broker-agency-name-#{self.broker_agency_profile_id}", expires_in: 12.hour) do
      legal_name
    end
  end

  # belongs_to writing agent (broker)
  def writing_agent=(new_writing_agent)
    raise ArgumentError.new("expected BrokerRole") unless new_writing_agent.is_a?(BrokerRole)
    self.writing_agent_id = new_writing_agent._id
    @writing_agent = new_writing_agent
  end

  def writing_agent
    return @writing_agent if defined? @writing_agent
    @writing_agent = BrokerRole.find(writing_agent_id)
  end
end
