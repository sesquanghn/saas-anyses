class LeaveApplication::ChangeApplicationStatus
  attr_reader :application, :leave_status

  def initialize(application, leave_status)
    @application = application
    @leave_status = leave_status
  end

  def perform
    application.approve_application! if leave_status == 'approved'
  end
end
