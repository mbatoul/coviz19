desc 'Imports historical data points from CSSE'

task import_historical_data: :environment do
  Import::DataPoints::HistoricalService.call
end