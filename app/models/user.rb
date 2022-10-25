# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  #   :confirmable, :lockable, :timeoutable, :trackable, :omniauthable, :validatable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :confirmable
  include DeviseTokenAuth::Concerns::User
end
