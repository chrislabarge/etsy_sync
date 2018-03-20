require 'dotenv/load'
require 'metadown'
require_relative 'etsy_wrapper.rb'
require_relative 'product'
require_relative 'importer'
require_relative 'log'
require_relative 'markdown_generator'

class ProductSync
  def initialize
    @service = EtsyWrapper.new
    @user = @service.get_user ENV['ETSY_SHOP']
  end

  def sync(option = nil)
    load_existing_data
    listings = gather_listings option

    #raise MarkdownGenerator.new(Product.new listings.first, @service.get_category(listings.first, @user)).product_metadata.inspect
    new_listings = find_new_listings listings

    return Log.up_to_date if new_listings.empty?

    import_products_from new_listings
  end

  def update_listing(listings)
    products = generate_products listings

    products.each do |product|
      generator = MarkdownGenerator.new product

      data = generator.product_metadata
      existing = @existing_data.find { |old| old['id'] == data['id'] }
      #now check the differences
    end
  end

  def gather_listings(option)
    option == :new ? recent_listings : request_all_listings
  end

  def find_new_listings(listings)
    ids = listings.map { |listing| listing.id.to_s }
    new_ids = ids - existing_ids

    new_ids.map do |id|
      i = ids.index id
      listings[i]
    end
  end

  def existing_ids
    @existing_data ||= load_existing_data

    @existing_data.map { |data| data['id'] }
  end

  def load_existing_data
    products = []
    Dir.glob(ENV['SITE_PATH'] + 'content/products/*.md') do |file|
      f = open file
      data = Metadown.render(f.read)
      raise data.metadata.inspect

      products << data.metadata
    end

    products
  end

  def recent_listings(offest = 0)
    @service.get_listing @user, nil, offest
  end

  def import_products_from(listings)
    products = generate_products listings

    importer = Importer.new
    importer.import products
  end

  def request_all_listings
    all_listings = []
    offset = 25
    count = 0
    switch = true

    while switch
      listings = recent_listings count
      all_listings << listings
      count += offset
      switch = (listings.count == offset)
    end

    all_listings.flatten
  end

  def generate_products(listings)
    listings.map do |listing|
      category = @service.get_category listing, @user
      Product.new listing, category
    end
  end
end
