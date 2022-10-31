class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_notfound
  rescue_from ArgumentError, RuntimeError, NoMethodError, with: :handle_system_error

  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pagy::Backend

  after_action { pagy_headers_merge(@pagy) if @pagy }

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

  def handle_system_error(exception)
    render json: {
      error: exception
    }, status: :internal_server_error
  end
end
