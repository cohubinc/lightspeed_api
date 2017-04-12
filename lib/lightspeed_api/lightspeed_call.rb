class LightspeedCall
  def initialize
    @calls = OpenStruct.new(current_call_count: 0, time_since_last: 0, time_last: Time.now)
  end

  class << self
    @@bucket_level = 60
    @@used_points = 0

    def make(type)
      check_calls(type)
      response = yield
      @@used_points = response.headers['x-ls-api-bucket-level'].split('/').first
      @@bucket_level = response.headers['x-ls-api-bucket-level'].split('/').last
      if response.code != 200
        raise "Lightspeed Error : #{response} "
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
      if @@used_points.to_f + cost.to_f <= @@bucket_level.to_f
        puts 'Making Call'
      else
        puts 'waiting for drip rate'
        how_many_points = (@@bucket_level.to_f - (@@used_points.to_f + cost.to_f)).abs
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