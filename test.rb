require 'uri'
require 'dotenv/load'
require 'etsy'
require_relative 'markdown_generator'
require_relative 'image_downloader'
#if state is NOT active then I will not want to sync.
#title, description,  url price currency_code
#tags.... the taxonomy would be better
class EtsyApi
  def initialize
    @client = new_session
  end

  def new_session
    Etsy.api_key = ENV['ETSY_API_KEY']
    Etsy
  end

  def get_user(username)
    Etsy.user(username)
  end
  
  def get_listing(user)
    shop = user.shop
    limit = 5
    Etsy::Listing.find_all_by_shop_id(shop.id, limit: limit)
  end
end

class Product
  attr_accessor :etsy_image_url
  attr_accessor :title
  attr_accessor :description
  attr_accessor :url
  attr_accessor :price
  attr_accessor :image

  def initialize(listing)
    data = listing.result
    image = image_url(listing)

    @title = data["title"]
    @description = data["description"]
    @url = data["url"]
    @price = data["price"].to_s
    @image = image
  end

  def format(listing)
    @date = date
    @weight = 2
  end

  def image_url(listing)
    set_etsy_image(listing)
    
    name = URI(@etsy_image_url).path.split('/').last 
    'img/' + name
  end
  
  def set_etsy_image(listing)
    data = listing.image.result
    @etsy_image_url = data["url_570xN"]
  end
end
