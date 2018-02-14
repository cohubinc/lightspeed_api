class LightspeedCall
  def initialize
    @calls = OpenStruct.new(current_call_count: 0, time_since_last: 0, time_last: Time.now)
  end

  class << self
    @@bucket_level = 60
    @@used_points = 0

    def parse_headers(response)
      @@used_points = response.headers['x-ls-api-bucket-level'].split('/').first
      @@bucket_level = response.headers['x-ls-api-bucket-level'].split('/').last
      @drip_rate = response.headers['x-ls-api-drip-rate'].split('/').last
    rescue => e
      raise "Lightspeed Error : #{response} : #{e.message}"
    end

    def make(type)
      bucket_levels = LightspeedApi::Base.get_bucket_level
      parse_headers(bucket_levels)
      check_calls(type)
      response = yield
      parse_headers(response)
      if response.code != 200
        raise "Lightspeed Error : #{response}, #{bucket_levels} "
      end
      response
    end


    def check_calls(type)
      drip_rate = @@bucket_level.to_f / 60
      cost = case type
               when 'POST'
                 10
               when 'PUT'
                 10
               when 'DELETE'
                 10
               when 'GET'
                 1
             end
      puts @@used_points
      puts @@bucket_level
      puts cost
      if @@used_points.to_f + cost.to_f < (@@bucket_level.to_f - 20)
        puts 'Making Call'
      else
        puts 'waiting for drip rate'
        how_many_points = ((@@bucket_level.to_f - 20 ) - (@@used_points.to_f + cost.to_f)).abs
        how_many_points += 5
        wait_for = how_many_points * drip_rate
        if wait_for < drip_rate
          wait_for = drip_rate
        end
        sleep(wait_for)
        puts 'continuing'
      end
    end
  end
end