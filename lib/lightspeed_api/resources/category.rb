module LightspeedApi
  class Category < Base

    self.id_param_key = 'categoryID'

    class << self

      def find_by_name(name)
        find_url = url
        LightspeedCall.make('GET') { HTTParty.get(find_url, params: {name: name}.to_json, headers: {Authorization: "Bearer #{Lightspeed::OauthGrant.token}", 'Accept' => 'application/json'}) }
      end

      def create(category)
        post_url = url
        category = {name: category.name}
        LightspeedCall.make('POST') { HTTParty.post(post_url, body: category.to_json, headers: {Authorization: "Bearer #{Lightspeed::OauthGrant.token}", 'Accept' => 'application/json'}) }
      end
    end
  end
end