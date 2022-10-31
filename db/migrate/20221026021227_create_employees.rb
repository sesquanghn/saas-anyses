class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.date :joined_date
      t.string :name
      t.decimal :leave_days_remaining, precision: 3, scale: 1
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
