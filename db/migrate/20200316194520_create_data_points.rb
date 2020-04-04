class CreateDataPoints < ActiveRecord::Migration[6.0]
  def change
    create_table :data_points do |t|
      t.references :zone
      t.integer :value
      t.integer :diff_with_previous_date
      t.integer :category, index: true
      t.date :date, index: true

      t.timestamps
    end
  end
end
