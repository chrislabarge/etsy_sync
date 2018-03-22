require 'dotenv/load'
require 'metadown'
require 'diffy'
require_relative 'etsy_wrapper.rb'
require_relative 'product'
require_relative 'importer'
require_relative 'log'
require_relative 'sync_utilities'
require_relative 'markdown_generator'
require_relative 'existing_files'

class ProductSync
  def initialize
    @service = EtsyWrapper.new
  end

  def sync(option = nil)
    listings = gather_listings option

    import_any_new listings
    update_to listings
  rescue => e
    Log.error e
  end

  def import_any_new(listings)
    new_listings = find_new_listings listings

    if new_listings.empty?
      Log.no_new
    else
      import_products_from new_listings
    end
  end

  def update_to(listings)
    products = generate_products listings
    products.each { |product| update_old_product(product) }
    Log.up_to_date
  end

  def update_old_product(product)
    return unless remove_old_product(product)

    importer = Importer.new
    importer.import_product product
    Log.updated product.inspect
  end

  def remove_old_product(product)
    path = find_update_path product

    return unless path

    FileUtils.rm path

    true
  end

  def find_update_path(product)
    data = product.metadata
    existing = @existing_data.find { |old| old['id'] == data['id'] }

    return unless existing && SyncUtilities.needs_update?(existing, data)

    SyncUtilities.file_path(existing['title'])
  end

  def gather_listings(option)
    option == :new ? @service.get_listings : @service.request_all_listings
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
    @existing_data ||= ExistingFiles.data

    @existing_data.map { |data| data['id'] }
  end

  def import_products_from(listings)
    products = generate_products listings

    importer = Importer.new
    importer.import products
  end

  def generate_products(listings)
    listings.map do |listing|
      category = @service.get_category listing
      Product.new listing, category
    end
  end
end
