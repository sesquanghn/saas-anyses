class Api::V1::Admin::LeaveApplicationsController < ApplicationController
  before_action :authenticate_admin!

  def index
    q = LeaveApplication.ransack(params[:q])
    @pagy, applications = pagy(q.result.includes(employee: :user).order_leave_date)

    render json: LeaveApplicationSerializer.new(applications, include_options)
  end

  def show
    # application = authorize(LeaveApplication.find(params[:id]))
    # serializer_data = LeaveApplicationSerializer.new(application).serializable_hash
    #
    # render json: serializer_data
  end

  def create
    # application = LeaveApplication.create!(application_params.merge(employee_id: @employee_id))
    # serializer_data = LeaveApplicationSerializer.new(application).serializable_hash
    #
    # render json: serializer_data
  end

  def update
    application = authorize(LeaveApplication.find(params[:id]))

    if (leave_status = params.dig(:leave_application, :leave_status)).present?
      LeaveApplication::ChangeApplicationStatus.new(application, leave_status).perform
    else
      application.update!(application_params)
      serializer_data = LeaveApplicationSerializer.new(application).serializable_hash
    end

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
