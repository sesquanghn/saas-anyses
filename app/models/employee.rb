# == Schema Information
#
# Table name: employees
#
#  id                   :bigint           not null, primary key
#  joined_date          :date
#  leave_days_remaining :integer
#  name                 :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :bigint           not null
#
# Indexes
#
#  index_employees_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Employee < ApplicationRecord
  belongs_to :user

  has_many :leave_applications
end
