class LeaveApplication::UpdateRemainDays
  attr_reader :application, :leave_type

  def initialize(application, leave_type)
    @application = application
    @leave_type = leave_type
  end

  def perform
    return if update_leave_day_already?

    employee = application.employee
    employee.with_lock do
      leave_amount = (leave_type == 'full' ? 1 : 0.5)
      remain_days = employee.leave_days_remaining - leave_amount
      employee.leave_days_remaining = remain_days
      employee.save!
    end
  end

  private

  def update_leave_day_already?
    LeaveApplication.where(date_of_application: application.date_of_application, leave_type: ['full', leave_type])
                    .by_employee_id(application.employee_id)
                    .exists?
  end
end
