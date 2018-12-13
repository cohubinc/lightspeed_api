require_relative "lightspeed_api/version"
require_relative 'lightspeed_api/configuration'
require_relative 'lightspeed_api/access_token'
require_relative 'lightspeed_api/lightspeed_call'
require_relative 'lightspeed_api/oauth_grant'
# require_relative 'lightspeed_api/shopify_hooks'
# require_relative 'lightspeed_api/shopify_draft_order_patch'
# require_relative 'lightspeed_api/shopify_order_patch'
module LightspeedApi
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
    check_required_config_settings
  end

  def self.check_required_config_settings
    settings = ['lightspeed_clientID',
                'lightspeed_clientSecret',
                'lightspeed_refresh_token',
                'lightspeed_account_id']
    settings.each do |setting|
      if !configuration.instance_variable_get("@#{setting}")
        raise <<-DOC
          \n Missing environment variable: #{setting}
          \n Must Have all settings: #{settings.join(',')} set in ENV.
          \n If you are sure they are set and this error keeps popping up.
          \n Try stopping spring with 'spring stop' and running again.
        DOC
      end
    end
  end



  def self.const_missing(name)
    self.const_set name.to_s, Class.new(LightspeedApi::Base)
  end
end

require_relative 'lightspeed_api/resources'
