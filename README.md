# LightspeedApi

API wrapper for [Lightspeed Retail](https://www.lightspeedhq.com)

API Docs [Lightspeed API](http://developers.lightspeedhq.com/retail/introduction/introduction/) 



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lightspeed_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lightspeed_api

### Generate Migrations

    $ rails g lightspeed_api:install

*Note:* 
This is only if you need a access_tokens table.
If you already have one just make sure you have these fields
  
  - access_token
  - expires_at
  - token_type
  - refresh_token
  - app 
    
## Usage

*Note:* ShopID is currently hardcoded to 1 :( as when making we only had 1 shop. 
Need to change to take user defined shop id.

Most endpoints have find,create,update,delete,all methods and endpoints.
    
    $ LightspeedApi::Item.find(1)
 
    $ LightspeedApi::Item.all
   

Some models are created that have special methods but many are made on the fly. 
The Model in Lightspeed you are calling is the class you would call with any of the above methods.

ie: If you want to find all Discounts. It does not have a model created but you can still call
  
    $ LightspeedApi::Discount.all
 
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/lightspeed_api.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

