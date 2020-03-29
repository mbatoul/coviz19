# frozen_string_literal: true

module Twitter
  class Api
    include HTTParty
    
    BEARER_KEY = ENV['TWITTER_API_BEARER_KEY']
    BASE_URL = 'https://api.twitter.com/1.1'
  end
end