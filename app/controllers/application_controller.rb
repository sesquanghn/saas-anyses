class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_notfound
  rescue_from Pundit::NotAuthorizedError, with: :handle_forbidden
  rescue_from ArgumentError, RuntimeError, NoMethodError, with: :handle_system_error

  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit::Authorization
  include Pagy::Backend

  after_action { pagy_headers_merge(@pagy) if @pagy }

  protected

  def authenticate_admin!
    unless current_user&.admin_role?
      render json: {
        errors: ['You are not Admin']
      }
    end
  end

  def include_options
    included = params[:included].presence || ''

    {
      include: included.split(',')
    }
  end

  private

  def handle_record_invalid(exception)
    render json: {
      error: exception.record.errors.full_messages
    }, status: :unprocessable_entity
  end

  def handle_record_notfound(exception)
    render json: {
      error: exception.message
    }, status: :not_found
  end

  def handle_forbidden(exception)
    render json: {
      error: exception.message
    }, status: :forbidden
  end

  def handle_system_error(exception)
    render json: {
      error: exception
    }, status: :internal_server_error
  end
end
