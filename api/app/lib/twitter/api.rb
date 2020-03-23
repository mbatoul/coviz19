module Twitter
  class Api
    include HTTParty
    
    BEARER_KEY = ENV['TWITTER_API_BEARER_KEY'].freeze
    BASE_URL = 'https://api.twitter.com/1.1'
  end
end