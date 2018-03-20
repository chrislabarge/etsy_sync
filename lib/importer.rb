require_relative 'markdown_generator'
require_relative 'image_downloader'

class Importer
  def import(products)
    imported_count = 0

    products.each do |product|
      generator = MarkdownGenerator.new product
      downloader = ImageDownloader.new product

      begin
        generator.generate
        downloader.download
      rescue => e
        Log.error e
      end

      imported_count += 1
      Log.succcessful_import product
    end

    log_status products, imported_count
  end

  def log_status(items, count)
    non_imported = items.count - count

    Log.this "Imported #{count} Products"

    return unless non_imported > 0

    Log.this "Unable to import #{non_imported} Products"
  end
end

