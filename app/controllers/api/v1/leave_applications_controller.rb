class Api::V1::LeaveApplicationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pagy, applications = pagy LeaveApplication.includes(employee: :user)
                                               .where(employee: { user: current_user })
                                               .order_leave_date

    render json: LeaveApplicationSerializer.new(applications, include_options)
  end

  def show
    application = authorize(LeaveApplication.find(params[:id]))

    render json: LeaveApplicationSerializer.new(application)
  end

  def create
    application = LeaveApplication.create!(application_params.merge(employee: current_user.employee))

    render json: LeaveApplicationSerializer.new(application)
  end

  def update
    application = authorize(LeaveApplication.find(params[:id]))
    application.update!(application_params)

    render json: LeaveApplicationSerializer.new(application)
  end

  def destroy
    application = authorize(LeaveApplication.find(params[:id]))
    application.destroy
  end

  private

  def application_params
    params.require(:leave_application).permit(:remarks, :date_of_application, :application_confirmed, :leave_type)
  end
end
