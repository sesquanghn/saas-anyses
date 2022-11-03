class Api::V1::LeaveApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_employee_id

  def index
    @pagy, applications = pagy(LeaveApplication.by_employee_id(@employee_id).order_leave_date)

    render json: LeaveApplicationSerializer.new(applications, include_options)
  end

  def show
    application = authorize(LeaveApplication.find(params[:id]))
    serializer_data = LeaveApplicationSerializer.new(application).serializable_hash

    render json: serializer_data
  end

  def create
    application = LeaveApplication.create!(application_params.merge(employee_id: @employee_id))
    serializer_data = LeaveApplicationSerializer.new(application).serializable_hash

    render json: serializer_data
  end

  def update
    application = authorize(LeaveApplication.find(params[:id]))
    application.update!(application_params)
    serializer_data = LeaveApplicationSerializer.new(application).serializable_hash

    render json: serializer_data
  end

  def destroy
    application = authorize(LeaveApplication.find(params[:id]))
    application.destroy
  end

  private

  def application_params
    params.require(:leave_application).permit(:remarks, :date_of_application, :application_confirmed, :leave_type)
  end

  def load_employee_id
    @employee_id = current_user.employee&.id
  end
end