require_relative 'sync_utilities'

class MarkdownGenerator
  def initialize(product)
    @product = product
  end

  def generate
    path = SyncUtilities.file_path(@product.title)
    file = File.open(path, 'w+')

    file.puts '---'
    @product.metadata.each do |key, value|
      file.puts "#{key}: '#{value}'"
    end
    file.puts '---'

    file.close
  end
end
