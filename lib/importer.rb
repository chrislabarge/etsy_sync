require_relative 'markdown_generator'
require_relative 'image_downloader'
require_relative 'sync_utilities'

class Importer
  def import(products)
    imported_count = 0

    products.each do |product|
      import_product product
      imported_count += 1
      Log.succcessful_import product
    end

    log_status products, imported_count
  end

  def import_product(product)
    generate_markdown product
    download_img product
  rescue => e
    Log.error e
  end

  def generate_markdown(product)
    generator = MarkdownGenerator.new product

    generator.generate
  end

  def download_img(product)
    store_path = SyncUtilities.image_path(product.image)

    return unless File.file?(store_path)

    downloader = ImageDownloader.new product
    downloader.download(store_path)
  end

  def log_status(items, count)
    non_imported = items.count - count

    Log.this "Imported #{count} Products"

    return unless non_imported > 0

    Log.this "Unable to import #{non_imported} Products"
  end
end

