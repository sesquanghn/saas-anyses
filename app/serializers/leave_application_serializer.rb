# == Schema Information
#
# Table name: leave_applications
#
#  id                    :bigint           not null, primary key
#  application_confirmed :boolean          default(FALSE)
#  date_of_application   :date
#  leave_status          :integer
#  leave_type            :integer
#  remarks               :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  employee_id           :bigint           not null
#
# Indexes
#
#  index_leave_applications_on_employee_id  (employee_id)
#
# Foreign Keys
#
#  fk_rails_...  (employee_id => employees.id)
#
class LeaveApplicationSerializer < ApplicationSerializer
  belongs_to :employee

  attributes :remarks, :leave_type, :date_of_application, :leave_status, :application_confirmed, :employee_id

  attribute :can_modify do |object|
    Pundit.policy(object.employee.user, object).update?
  end
end
