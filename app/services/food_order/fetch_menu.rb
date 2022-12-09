require 'net/http'

class FoodOrder::FetchMenu < ApplicationService
  attr_reader :shopee_food_url
  attr_accessor :delivery_id

  SHOPEE_FOOD_HEADERS = {
    'x-foody-client-language' => 'vi',
    'x-foody-client-type' => '1',
    'x-foody-client-version' => '3.0.0',
    'x-foody-api-version' => '1',
    'x-foody-app-type' => '1004',
    'x-foody-access-token' => '',
    'x-foody-client-id' => '',
  }.freeze

  def initialize(shopee_food_url)
    @shopee_food_url = shopee_food_url
  end

  def execute
    set_delivery_id
    return [] if delivery_id.zero?

    create_shopeefood_menu
    load_shopeefood_menu
  rescue Exception => e
    Rails.logger.error(e)
    []
  end

  private

  def create_shopeefood_menu
    shop_url = shopee_food_url.split('/').last
    shop_name = shop_url.split('.').first.gsub('-', ' ')
    ShopeefoodMenu.find_or_create_by(url: shopee_food_url, name: shop_name)
  end

  def request_to_shopeefood(url, queries)
    uri = URI(url)
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |https|
      uri.query = URI.encode_www_form(queries)
      req = Net::HTTP::Get.new(uri)
      SHOPEE_FOOD_HEADERS.each { |header_key, header_value| req[header_key] = header_value }

      https.request(req)
    end
  end

  def set_delivery_id
    queries = { url: shopee_food_url.delete_prefix('https://shopeefood.vn/') }
    res = request_to_shopeefood('https://gappapi.deliverynow.vn/api/delivery/get_from_url', queries)
    body = JSON.parse(res.body)
    @delivery_id = body.dig('reply', 'delivery_id')
  end

  def get_available_dishes(dishes)
    dishes.inject([]) do |result, dish|
      dish['is_deleted'] ? result : result << [dish['name'], dish.dig('price', 'text')]
    end
  end

  def load_shopeefood_menu
    queries = { id_type: 2, request_id: delivery_id }
    res = request_to_shopeefood('https://gappapi.deliverynow.vn/api/dish/get_delivery_dishes', queries)
    body = JSON.parse(res.body)
    menu_infos = body.dig('reply', 'menu_infos')
    menu_infos.map do |menu_info|
      { menu_info['dish_type_name'] => get_available_dishes(menu_info['dishes']) }
    end
  end
end
