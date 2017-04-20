module LightspeedApi
  class Customer < Base

    self.id_param_key = 'customerID'

    class << self
      def create(manufacturer)
        post_url = url
        mfg = {name: manufacturer.name}
        LightspeedCall.make('POST') { HTTParty.post(post_url, body: mfg.to_json, headers: {Authorization: "Bearer #{LightspeedApi::OauthGrant.token}", 'Accept' => 'application/json'}) }
      end

      def find_by_email(email)
        # TODO change this to email not mobile
        raise 'This is not setup yet. Change to email before cotinuing to use'
        find_url = url+'?load_relations=["Contact"]&Contact.mobile=' + email
        response = LightspeedCall.make('GET') {
          HTTParty.get(
              find_url,
              headers: {Authorization: "Bearer #{LightspeedApi::OauthGrant.token}", 'Accept' => 'application/json'}
          )}
      end

      def find_by(query)
        find_url = url
        response = LightspeedCall.make('GET') {
          HTTParty.get(
              find_url, query: query,
              headers: {Authorization: "Bearer #{LightspeedApi::OauthGrant.token}", 'Accept' => 'application/json'}
          )}
      end
    end
  end
end