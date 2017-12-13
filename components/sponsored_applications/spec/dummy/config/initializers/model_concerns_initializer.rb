Config.setup do |config|
  config.const_name = "Settings"
end

CoreModelConcerns.configure do |config|
  config.settings = Settings
end
ShopModelConcerns.configure do |config|
  config.settings = Settings
end
LocationModelConcerns.configure do |config|
  config.settings = Settings
end
