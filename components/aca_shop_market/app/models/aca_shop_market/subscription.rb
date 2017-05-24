module Subscription

  def initialize
    @subscribers = []
  end

  def subscribe(subscriber)
    @subscribers << subscriber
  end

  def unsubscribe(subscriber)
    @subscriber.delete(subscriber)
  end

  def subscribers
    @subscribers || klass.subscribers
  end

  def notify_subscriber
    @subscriber.each do |subscribers|
      subscriber.update(self)
    end
  end
  
  module ClassMethods
    # include SubscriptionInstanceMethods
    # extend SingletonMethods

  end

end