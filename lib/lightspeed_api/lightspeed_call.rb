class LightspeedCall
  def initialize
    @calls = OpenStruct.new(current_call_count: 0, time_since_last: 0, time_last: Time.now)
  end

  class << self

    def parse_headers(response)
      used_points = response.headers['x-ls-api-bucket-level'].split('/').first
      bucket_level = response.headers['x-ls-api-bucket-level'].split('/').last
      if response.headers['x-ls-api-drip-rate']
        @drip_rate = response.headers['x-ls-api-drip-rate'].split('/').last
      end
      if token
        token.used_points = used_points.to_f
        token.bucket_level = bucket_level.to_f
        token.save
      end
    rescue => e
      raise "Lightspeed Error : #{response} : #{e.message}, cost: #{@cost}, level:#{bucket_level}, used: #{used_points}" if !ENV['NO_ERRORS']
    end

    def token
      AccessToken.find_or_create_by(app: 'lightspeed')
    end

    def bucket_level
      token.try(:bucket_level).to_f > 0 ? token.bucket_level : 60
    end

    def used_points
      token.try(:used_points).to_f > 0 ? token.used_points : 60
    end

    def drip_rate
      @drip_rate ||= 2
    end

    def make(type)
      check_calls(type)
      response = yield
      parse_headers(response)
      if response.code != 200 && !ENV['NO_ERRORS']
        raise "Lightspeed Error : #{response}, #{bucket_level}, #{used_points}"
      end
      response
    end


    def check_calls(type)
      # being safe and adding 5 to each cost
      @cost = case type
                when 'POST'
                  15
                when 'PUT'
                  15
                when 'DELETE'
                  15
                when 'GET'
                  5
              end
      puts "Used: #{used_points}"
      puts "BucketLevel: #{bucket_level}"
      puts "#{@cost}"
      if total_if_made < bucket_level
        puts 'Making Call'
      elsif total_if_made >= bucket_level
        wait_for = amount_over / drip_rate
        puts "Waiting for #{wait_for} seconds"
        sleep(wait_for)
        puts 'continuing'
      end
    end

    def total_if_made
      used_points.to_f + @cost.to_f
    end

    def amount_over
      total_if_made - bucket_level
    end
  end
end