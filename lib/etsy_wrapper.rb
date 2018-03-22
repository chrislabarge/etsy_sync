require 'uri'
require 'etsy'

class EtsyWrapper
  attr_accessor :client

  def initialize
    @client = new_session
    @user = Etsy.user ENV['ETSY_SHOP']
  end

  def new_session
    Etsy.api_key = ENV['ETSY_API_KEY']
    Etsy
  end

  def get_listings(limit = nil, offset = nil)
    shop = @user.shop
    options = {}
    options[:limit] = limit if limit
    options[:offset] = offset if offset
    Etsy::Listing.find_all_by_shop_id(shop.id, options)
  end

  def get_sections
    shop = @user.shop
    Etsy::Section.find_by_shop(shop)
  end

  def get_category(listing)
    data = listing.result
    id = data['shop_section_id']

    return 'Other' unless id

    @sections ||= get_sections
    ids = @sections.map(&:id)
    index = ids.index(id)

    @sections[index].title
  end

  def request_all_listings
    all_listings = []
    offset = 25
    count = 0
    switch = true

    while switch
      listings = get_listings nil, count
      all_listings << listings
      count += offset
      switch = (listings.count == offset)
    end

    all_listings.flatten
  end
end

