class CreateZones < ActiveRecord::Migration[6.0]
  def change
    create_table :zones do |t|
      t.integer :nature
      t.string :kebab_name, index: true
      t.string :name
      t.string :abbreviation
      t.string :code
      t.float :lat
      t.float :lng
      t.integer :population
      t.references :parent

      t.timestamps
    end
  end
end
