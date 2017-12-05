CoreModelConcerns.configure do |config|
  config.settings = Settings

  class CoreModelConcerns::TimeKeeper < TimeKeeper
  end
end
