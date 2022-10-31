class CreateAasmStatusHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :aasm_status_histories do |t|
      t.string :changed_from
      t.string :changed_to
      t.string :event_name
      t.references :historyable, polymorphic: true

      t.timestamps
    end
  end
end
