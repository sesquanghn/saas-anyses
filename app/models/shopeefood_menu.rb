# == Schema Information
#
# Table name: shopeefood_menus
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  url        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ShopeefoodMenu < ApplicationRecord
  validates :name, presence: true
  validate :shopeefood_url

  private

  def shopeefood_url
    errors.add(:url, :invalid) unless url.start_with?('https://shopeefood.vn/')
  end
end
