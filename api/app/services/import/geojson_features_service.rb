module Import
  class GeojsonFeaturesService
    include Service

    require 'net/http'
    require 'json'
    
    SOURCE_URL = 'https://coviz-19-bucket.s3.eu-west-3.amazonaws.com/data/countries-geo.json'
    
    def call
      GeojsonFeature.destroy_all

      response = Net::HTTP.get(URI(SOURCE_URL))
      features =  JSON.parse(response)['features']

      features.each do |feature|
        zone = CoupleFeatureWithZoneService.call(feature)
        
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
end