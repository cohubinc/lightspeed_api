require_relative "lightspeed_api/version"
require_relative 'lightspeed_api/access_token'
require_relative 'lightspeed_api/lightspeed_call'
require_relative 'lightspeed_api/oauth_grant'
require_relative 'lightspeed_api/shopify_hooks'
require_relative 'lightspeed_api/shopify_draft_order_patch'
require_relative 'lightspeed_api/shopify_order_patch'

module LightspeedApi
  settings = ['lightspeed_clientID',
              'lightspeed_clientSecret',
              'lightspeed_refresh_token',
              'lightspeed_account_id']
  settings.each do |setting|
    if ENV[setting].nil? || !ENV[setting]
      raise <<-DOC
        \n Missing environment variable: #{setting}
        \n Must Have all settings: #{settings.join(',')} set in ENV. 
        \n If you are sure they are set and this error keeps popping up. 
        \n Try stopping spring with 'spring stop' and running again.
      DOC
    end
  end

  def self.const_missing(name)
    self.const_set name.to_s, Class.new(LightspeedApi::Base)
  end
end

require_relative 'lightspeed_api/resources'
