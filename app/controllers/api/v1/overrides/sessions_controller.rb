class Api::V1::Overrides::SessionsController < DeviseTokenAuth::SessionsController
  protected

  def render_create_success
    render json: {
      email: @resource.email,
      role: @resource.role,
      name: @resource.name
    }
  end
end
