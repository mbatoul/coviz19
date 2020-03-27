# frozen_string_literal: true

class FetchTweetsService
  include Service
  require 'net/http'
  require 'json'
  
  attr_accessor :zones

  KEYWORDS = %w[coronavirus covid]

  def call
    Twitter::Search.perform(
      q: "#{KEYWORDS.join(',')},#{zones}",
      count: '20',
      result_type: 'mixed'
    )
  end
end