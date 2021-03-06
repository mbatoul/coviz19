# frozen_string_literal: true

class ImportCovidDataService
  include Service
  require 'net/http'
  require 'csv'
  require 'json'

  SOURCES = {
    confirmed: 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv',
    death: 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv',
    recovered: 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv',
  }

  COUNTRY_CODE_URL = 'https://restcountries.eu/rest/v2/name/{}?fullText=true'

  CHILDREN_NAMES = {
    us: 'state',
    china: 'province',
    france: 'region'
  }

  def call
    SOURCES.each do |category, url|
      csv = Net::HTTP.get(URI(url))
      csv = CSV.parse(csv, encoding: 'utf-8', col_sep: ',', headers: true)

      csv.each do |row|
        hash = row.to_h
      
        lat = hash['Lat'].to_f
        lng = hash['Long'].to_f

        parent_name = hash['Country/Region'].force_encoding(Encoding::UTF_8)
        kebab_name = parent_name.parameterize

        zone = Zone.find_or_create_by(kebab_name: kebab_name, nature: 'country') do |zone|
          zone.name = parent_name
          zone.lat = lat
          zone.lng = lng
          zone.code = get_code(kebab_name)
        end

        if hash['Province/State'].present?
          parent = zone
          child_name = hash['Province/State'].force_encoding(Encoding::UTF_8)
          kebab_name = child_name.parameterize
          nature = CHILDREN_NAMES[parent_name.downcase]
          zone = Zone.find_or_create_by(kebab_name: kebab_name) do |zone|
            zone.name = child_name
            zone.nature = Zone.natures[nature || 'state']
            zone.code = get_code(child_name.parameterize)
            zone.parent = parent
          end
        else
          zone.update_columns(
            lat: lat,
            lng: lng
          )
        end
        
        data_points = hash.select { |key, value| key.to_s.match(/\d{1,}\/\d{1,}\/\d{1,}/) }
        
        data_points.each do |date, value|
          new_data_point = DataPoint.find_or_create_by(date: Date.strptime(date, '%m/%d/%y'), zone: zone, value: value.to_i, category: category)

          active_data_point = DataPoint.find_or_create_by(date: Date.strptime(date, '%m/%d/%y'), zone: zone, category: 'active')
          case category.to_s
          when 'confirmed'
            active_value = active_data_point.value.to_i + new_data_point.value
          else
            active_value = active_data_point.value.to_i - new_data_point.value
          end
          active_data_point.update_columns(value: active_value)
        end
      end
    end
  end

  private

    def get_code(name)
      response = Net::HTTP.get(URI(COUNTRY_CODE_URL.gsub('{}', name)))
      code = JSON.parse(response)[0]['alpha2Code']
      code[0].downcase == name[0].downcase ? code : ''
    rescue StandardError => e
      Rails.logger.info "Failed to retrieve code for #{name}: #{e}"
      ''
    end
end
