class CreateZones < ActiveRecord::Migration[6.0]
  def change
    create_table :zones do |t|
      t.integer :nature
      t.string :parameterized_name
      t.string :name
      t.string :abbreviation
      t.string :code
      t.float :lat
      t.float :lng
      t.references :parent

      t.timestamps
    end
  end
end
