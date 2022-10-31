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
class LeaveApplication < ApplicationRecord
  belongs_to :employee

  has_many :aasm_status_histories, as: :historyable

  include AASM

  enum leave_status: %i[pending approved denied expired]
  enum leave_type: %i[morning afternoon full]

  validates :leave_type, presence: true
  validate :validate_leave_options

  before_save :auto_approved

  scope :order_leave_date, ->(with_order = :desc) { order(date_of_application: with_order) }

  aasm column: :leave_status, enum: true do
    state :pending, initial: true
    state :approved, :denied, :expired

    after_all_transitions :save_status_change

    event :deny_application do
      transitions from: :pending, to: :denied, after: :after_denied
    end

    event :approve_application do
      transitions from: [:pending, :denied], to: :approved, after: :after_approved
    end
  end

  private

  def after_denied; end

  def after_approved
    LeaveApplication::UpdateRemainDays.new(self, leave_type).perform
  end

  def auto_approved
    approve_application if application_confirmed && ((Date.current + 3.days) <= date_of_application)
  end

  def save_status_change
    aasm_status_histories << AasmStatusHistory.new(event_name: aasm.current_event,
                                                   changed_from: aasm.from_state,
                                                   changed_to: aasm.to_state)
  end

  def validate_leave_options
    return errors.add(:date_of_application, :blank) if date_of_application.blank?

    submitted_leave_types = LeaveApplication.where(date_of_application: date_of_application)
                                            .by_employee_id(employee_id)
                                            .where.not(id: id)
                                            .pluck(:leave_type)

    if submitted_leave_types.include?('full') ||
        submitted_leave_types.include?(leave_type) ||
        ((submitted_leave_types & ['morning', 'afternoon']).size == 2)
      errors.add(:leave_type, :taken)
    end
  end
end
