# frozen_string_literal: true

# See https://developer.twitter.com/en/docs/tweets/search/api-reference/get-search-tweets for more info.
module Twitter
  class Search < Twitter::Api
    attr_accessor :q, :geocode, :lang, :locale, :result_type, :count, :until, :since_id, :max_id, :include_entities

    PATH = 'search/tweets.json'.freeze

    OPTIONS = {
      headers: {
        'Authorization': 'Bearer ' + BEARER_KEY,
        'Accept': 'application/json'
      }
    }.freeze

    def initialize(params = {})
      params.each { |k, v| send("#{k}=", v) }
    end

    def self.perform(params)
      new(params).perform
    end

    def perform
      HTTParty.get(url, OPTIONS)
    end
    
    private

      def query
        str = ''

        instance_variables.each do |key|
          str += "#{key.to_s.gsub('@', '')}=#{instance_variable_get(key)}&"
        end

        str
      end

      def url
        "#{BASE_URL}/#{PATH}?#{query}"
      end
  end
end