class CreateDataPoints < ActiveRecord::Migration[6.0]
  def change
    create_table :data_points do |t|
      t.references :zone
      t.integer :value
      t.integer :category
      t.date :date

      t.timestamps
    end
  end
end
