class MarkdownGenerator
  def initialize(product)
    @product = product 
  end

  def generate
    filename = @product.title.downcase.gsub(' ', '_')
    date = Time.now.to_s
    
    file = File.open('filename', 'w+')  

    file << '---'
    file << 'title: ' + @product.title
    file << 'date: ' + date
    file << 'description: ' + @product.description
    file << 'etsyLink: ' + @product.url
    file << 'price: ' + @product.price
    file << 'image: ' + @product.image
    file << 'weight: 2' 
    file << '---'

    file.close
  end
end
