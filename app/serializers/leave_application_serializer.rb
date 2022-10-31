class LeaveApplicationSerializer < ApplicationSerializer
  attributes :remarks, :leave_type, :date_of_application, :leave_status, :application_confirmed
end
