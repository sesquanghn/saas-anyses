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
    submitted_leave_types = LeaveApplication.where(date_of_application: application.date_of_application)
                                            .by_employee_id(application.employee_id)
                                            .where.not(id: application.id)
                                            .pluck(:leave_type)

    submitted_leave_types.include?('full') ||
      submitted_leave_types.include?(leave_type) ||
      ((submitted_leave_types & ['morning', 'afternoon']).size == 2)
  end
end
