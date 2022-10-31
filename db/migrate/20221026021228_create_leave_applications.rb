class CreateLeaveApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :leave_applications do |t|
      t.string :remarks
      t.boolean :application_confirmed, default: false
      t.date :date_of_application
      t.integer :leave_type, limit: 1
      t.integer :leave_status, limit: 1
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
