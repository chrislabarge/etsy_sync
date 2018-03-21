require_relative 'sync_utilities'

class MarkdownGenerator < SyncUtilities
  def initialize(product)
    @product = product
  end

  def product_metadata
    @metadata ||= construct_metadata
  end

  def construct_metadata
    metadata = {}
    date = Time.now.to_s

    metadata['id'] = "#{@product.id}"
    metadata['title'] = "#{@product.title}"
    metadata['date'] = "#{date}"
    metadata['description'] = "#{@product.description}"
    metadata['etsyLink'] = "#{@product.url}"
    metadata['price'] = "%.2f" % @product.price
    metadata['image'] = "#{@product.image}"
    metadata['catergory'] = "#{@product.category}"
    metadata['weight'] = 2

    metadata
  end

  def generate
    path = file_path(@product.title)
    file = File.open(path, 'w+')

    file.puts '---'
    product_metadata.each do |key, value|
      file.puts "#{key}: '#{value}'"
    end
    file.puts '---'

    file.close
  end
end
