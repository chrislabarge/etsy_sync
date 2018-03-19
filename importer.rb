class Importer
  def import(products)
    products.each do |product|
      generator = MardownGenerator.new product
      downloader = ImageDownloader.new product

      generator.generate
      downloader.download
    end
  end
end

require 'dotenv/load'
require_relative 'etsy_wrapper.rb'
require_relative 'markdown_generator'
require_relative 'image_downloader'
require_relative 'product'

class ProductSync
  def import_all
    puts "Are you sure? (yes/no)"
    input = gets.strip.downcase[0]

    return unless input == 'y'

    listings = request_all_listings
    products = generate_products listings

#    mmore_listings = session.get_listing user, nil, 25
    #    I think i just need to keep checking offset until it doesnt equal it.
  end

  def request_all_listings
    session = EtsyApi.new
    all_listings = []
    offset = 25
    count = 0
    user = session.get_user ENV['ETSY_SHOP']
    switch = true

    while switch
      listings = session.get_listing user, nil, count
      all_listings << listings
      count += offset
      switch = listings.count == offset
    end

    all_listings
  end

  def generate_products(listings)
    listings.each do |listing|
      category = @session.category listing, user
    end
  end
end
