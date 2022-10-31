class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!, except: :create

  def create
    auth_headers = User::GenerateAuthHeaders.new(params.dig(:user, :access_token)).perform
    response.headers.merge!(auth_headers)

    render json: {
      message: 'OK'
    }
  end

  def show
    render json: {
      email: current_user.email
    }
  end
end
