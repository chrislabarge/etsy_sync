class MarkdownGenerator
  def initialize(product)
    @product = product 
  end

  def generate
    filename = @product.title.downcase.gsub(' ', '_') + '.md'
    path = ENV['SITE_PATH'] + 'content/products/' + filename
    date = Time.now.to_s
    
    file = File.open(path, 'w+')  

    file.puts '---'
    file.puts 'title: ' + @product.title
    file.puts 'date: ' + date
    file.puts 'description: ' + @product.description
    file.puts 'etsyLink: ' + @product.url
    file.puts 'price: ' + @product.price
    file.puts 'image: ' + @product.image
    file.puts 'external_link: ""'
    file.puts 'weight: 2' 
    file.puts '---'

    file.close
  end
end
