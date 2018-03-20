class MarkdownGenerator
  def initialize(product)
    @product = product
  end

  def product_metadata
    metadata = {}
    date = Time.now.to_s

    metadata['id'] = "#{@product.id}"
    metadata['title'] = "#{@product.title}"
    #metadata['date'] = "#{date}"
    metadata['description'] = "#{@product.description}"
    metadata['etsyLink'] = "#{@product.url}"
    metadata['price'] = @product.price
    metadata['image'] = "#{@product.image}"
    metadata['catergory'] = "#{@product.category}"
    metadata['external_link'] = '""'
    metadata['weight'] = 2

    metadata
  end

  def generate
    #handle the date on generation, dont include in the sync
    filename = @product.title.downcase.tr(' ', '_') + '.md'
    path = ENV['SITE_PATH'] + 'content/products/' + filename
    date = Time.now.to_s

    file = File.open(path, 'w+')

    file.puts '---'
    file.puts 'id: ' + "'#{@product.id}'"
    file.puts 'title: ' + "'#{@product.title}'"
    file.puts 'date: ' + "'#{date}'"
    file.puts 'description: ' + "'#{@product.description}'"
    file.puts 'etsyLink: ' + "'#{@product.url}'"
    file.puts 'price: ' + @product.price
    file.puts 'image: ' + "'#{@product.image}'"
    file.puts 'catergory: ' + "'#{@product.category}'"
    file.puts 'external_link: ""'
    file.puts 'weight: 2'
    file.puts '---'

    file.close
  end
end
