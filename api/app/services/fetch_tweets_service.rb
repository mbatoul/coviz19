class FetchTweetsService
  include Service
  require 'net/http'
  require 'json'
  
  attr_accessor :country

  KEYWORDS = %w[coronavirus covid]

  def call
    Twitter::Search.perform(
      q: "#{KEYWORDS.join(',')},#{country}",
      count: '20',
      result_type: 'popular'
    )
  end
end