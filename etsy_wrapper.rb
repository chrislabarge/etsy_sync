require 'uri'
require 'etsy'
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

  def get_listing(user, limit = 5, offset = nil)
    shop = user.shop
    options = {}
    options[:limit] = limit if limit
    options[:offset] = offset if offset || offset > 0
    Etsy::Listing.find_all_by_shop_id(shop.id, options)
  end

  def get_sections(user)
    shop = user.shop
    Etsy::Section.find_by_shop(shop)
  end

  def category(listing, user)
    data = listing.result
    id = data['shop_section_id']
    @sections ||= get_sections(user)
    ids = @sections.map(&:id)
    index = ids.index(id)

    @sections[index].title
  end
end

