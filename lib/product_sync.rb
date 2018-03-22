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

class ProductSync < SyncUtilities
  def initialize
    @service = EtsyWrapper.new
  end

  def sync(option = nil)
    listings = gather_listings option
    new_listings = find_new_listings listings

    if new_listings.empty?
      Log.no_new
    else
      import_products_from new_listings
    end

    update_to listings
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
    data = product.metadata
    existing = @existing_data.find { |old| old['id'] == data['id'] }

    return false unless existing && needs_update?(existing, data)

    path = file_path(existing['title'])

    Log.this existing['title']
    Log.this path

    FileUtils.rm path

    true
  end

  def needs_update?(old, new)
    old.find do |key, value|
      next if key == 'date'
      difference?(new[key].to_s, value.to_s)
    end
  end

  def difference?(val1, val2)

    Diffy::Diff.new(remove_whitespace(val1), remove_whitespace(val2)).count > 0
  end

  def remove_whitespace(val)
    val.gsub(/\s+/, "")
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
    @existing_data ||= ExistingFiles.new.products

    @existing_data.map { |data| puts data[:id]; data['id'] }
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
