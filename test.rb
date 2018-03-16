require 'uri'
require 'dotenv/load'
require 'etsy'
#if state is active then I will not want to sync.
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
   
 # def get_shop(user)
 #   Etsy::Listing.find_all_by_shop_id(user)
 # end

  def test
    @client
  end

  def to_markdown(listing)
     
  end
end

class Product
  attr_accessor :etsy_image_url

  def initialize(listing)
    @obj = format(listing)
  end

  def format(listing)
    image = image_url(listing)
    date = Time.now.to_s

    {title: listing.title,
     description: listing.description,
     date: date,
     etsyLink: listing.url,
     price: price,
     weight: 2,
     image: image}  
  end

  def image_url(listing)
    set_etsy_image(listing)
    
    name = URI(@etsy_image_url).split('/').last 
    'img/' + name
  end
  
  def set_etsy_image(listing)
    @etsy_image_url = listing.image.url_570xN
  end
end
