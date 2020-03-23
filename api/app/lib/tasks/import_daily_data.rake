desc 'Imports daily data points from CSSE'

task import_daily_data: :environment do
  Import::DataPoints::DailyService.call
end