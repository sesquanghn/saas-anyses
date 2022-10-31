# == Schema Information
#
# Table name: aasm_status_histories
#
#  id               :bigint           not null, primary key
#  changed_from     :string(255)
#  changed_to       :string(255)
#  event_name       :string(255)
#  historyable_type :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  historyable_id   :bigint
#
# Indexes
#
#  index_aasm_status_histories_on_historyable  (historyable_type,historyable_id)
#
class AasmStatusHistory < ApplicationRecord
  belongs_to :historyable, polymorphic: true
end
