class ImportGeographicalDataService
  include Service

  require 'net/http'
  require 'json'
  require 'csv'
  
  SOURCE_URL = 'https://coviz-19-bucket.s3.eu-west-3.amazonaws.com/data/countries-geo.json'
  POPULATIONS_CSV_URL = 'https://coviz-19-bucket.s3.eu-west-3.amazonaws.com/data/population.csv'
  
  def call
    populations = {}
    CSV.parse(Net::HTTP.get(URI(POPULATIONS_CSV_URL)), encoding: 'utf-8', col_sep: ',', headers: true).each do |row|
      country = row.to_h
      populations[country['country_code'].to_i] = country['population'].gsub(/\s+/, '').to_i
    end
    
    response = Net::HTTP.get(URI(SOURCE_URL))
    features =  JSON.parse(response)['features']
    features.each do |feature|
      zone = CoupleFeatureWithZoneService.call(feature)
      zone&.update(population: populations[feature['properties']['iso_n3'].to_i])
      fmt_feature = zone.present? ? feature_with_zone_data(zone, feature) : feature
      GeojsonFeature.create(
        zone: zone,
        feature: fmt_feature
      )
    end
  end

  private

    def feature_with_zone_data(zone, feature)
      feature['zone_data'] = {
        name: zone.name,
        kebab_name: zone.kebab_name,
        iso_code: zone.code,
        death: zone.total('death'),
        confirmed: zone.total('confirmed'),
        recovered: zone.total('recovered')
      }

      feature
    end
end