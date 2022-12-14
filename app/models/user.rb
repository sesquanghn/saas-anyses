# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  email                  :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  provider               :string(255)      default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  role                   :integer          default("user")
#  tokens                 :text(65535)
#  uid                    :string(255)      default(""), not null
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  #   :confirmable, :lockable, :timeoutable, :trackable, :omniauthable, :validatable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :confirmable

  enum role: [:user, :admin], _suffix: true

  has_one :employee, dependent: :destroy
  has_many :leave_applications, dependent: :destroy

  delegate :name, to: :employee

  include DeviseTokenAuth::Concerns::User

  before_save :assign_employee, if: :new_record?

  private

  def assign_employee
    return if employee.present?

    build_employee.tap do |empl|
      name, _ = empl.user.email.split('@')
      empl.name = if name.include?('.')
                    lastname, firstname = name.split('.')
                    "#{firstname.capitalize} #{lastname&.upcase}"
                  else
                    name.capitalize
                  end

      empl.leave_days_remaining = 0
    end
  end
end
