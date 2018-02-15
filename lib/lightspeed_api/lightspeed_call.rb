class LightspeedCall
  def initialize
    @calls = OpenStruct.new(current_call_count: 0, time_since_last: 0, time_last: Time.now)
  end

  class << self

    def parse_headers(response)
      @used_points = response.headers['x-ls-api-bucket-level'].split('/').first
      @bucket_level = response.headers['x-ls-api-bucket-level'].split('/').last
      if response.headers['x-ls-api-drip-rate']
        @drip_rate = response.headers['x-ls-api-drip-rate'].split('/').last
      else
        @drip_rate = 2
      end
      if @token
        @token.used_points = @used_points.to_f
        @token.bucket_level = @bucket_level.to_f
        @token.save
      end
    rescue => e
      raise "Lightspeed Error : #{response} : #{e.message}"
    end

    def make(type)
      # bucket_levels = LightspeedApi::Base.get_bucket_level
      @token = AccessToken.find_by(app: 'lightspeed')
      @bucket_level = @token.try(:bucket_level).to_f > 0 ? @token.bucket_level : 60
      @used_points = @token.try(:used_points).to_f > 0 ? @token.used_points : 60
      @drip_rate ||= 2
      check_calls(type)
      response = yield
      parse_headers(response)
      if response.code != 200
        raise "Lightspeed Error : #{response}, #{@bucket_level}, #{@used_points}"
      end
      response
    end


    def check_calls(type)
      drip_rate = @drip_rate || @bucket_level.to_f / 60
      cost = case type
               when 'POST'
                 15
               when 'PUT'
                 15
               when 'DELETE'
                 15
               when 'GET'
                 5
             end
      puts @used_points
      puts @bucket_level
      puts cost
      # Stay 10 away from bucket level
      if @used_points.to_f + cost.to_f < (@bucket_level.to_f - 10)
        puts 'Making Call'
      else
        puts 'waiting for drip rate'
        if @used_points.to_f + cost.to_f >= (@bucket_level.to_f - 10)
          wait_for = (@used_points.to_f + cost.to_f - (@bucket_level.to_f - 10)) * 2
        else
          wait_for = 60
        end
        puts "Waiting for #{wait_for} seconds"
        sleep(wait_for)
        puts 'continuing'
      end
    end
  end
end