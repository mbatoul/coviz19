# frozen_string_literal: true

module Import
  module DataPoints
    class DailyService
      include Service
      require 'net/http'
      require 'csv'
      require 'json'
      
      BASE_URL = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports'.freeze

      def call
        url = today_url
        csv = Net::HTTP.get(URI(url))
        csv = CSV.parse(csv, encoding: 'utf-8', col_sep: ',', headers: true)

        csv.each do |row|
          hash = row.to_h
          zone = find_zone_from(hash)

          return unless zone.present?

          last_update_date = hash['Last Update'].to_date

          unless zone.data_points.where(date: last_update_date).present?
            %w[death confirmed recovered].each do |category|
              zone.data_points.create(
                value: hash['Deaths'].to_i,
                category: category,
                date: last_update_date
              )
            end
          end
        end
      end

      private

        def today_url
          date = Date.today - 1.days
          "#{BASE_URL}/#{date.strftime('%m-%d-%Y')}.csv"
        end

        def find_zone_from(hash)
          searchable = hash['Province/State'] || hash['Country/Region']
          searchable = searchable.force_encoding(Encoding::UTF_8).parameterize
          Zone.find_by(kebab_name: searchable)
        end
    end
  end
end