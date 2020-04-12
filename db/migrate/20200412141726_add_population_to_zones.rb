class AddPopulationToZones < ActiveRecord::Migration[6.0]
  def change
    add_column :zones, :population, :integer
  end
end
