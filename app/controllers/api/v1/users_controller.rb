class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!, except: :create

  def create
    result = User::GenerateAuthHeaders.new(params.dig(:user, :access_token)).perform
    response.headers.merge!(result[:auth_headers])

    render_user_info(result[:user])
  end

  def show
    render_user_info(current_user)
  end

  private

  def render_user_info(user)
    render json: {
      email: user.email,
      role: user.role
    }
  end
end
