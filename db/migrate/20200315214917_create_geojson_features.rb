class CreateGeojsonFeatures < ActiveRecord::Migration[6.0]
  def change
    create_table :geojson_features do |t|
      t.references :zone
      t.json :feature

      t.timestamps
    end
  end
end
