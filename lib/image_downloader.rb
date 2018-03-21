require 'open-uri'

class ImageDownloader
  def initialize(product)
    @product = product
  end

  def download(store_path)
    @img_url = @product.etsy_image_url

    open(@img_url) do |f|
      File.open(store_path, 'wb') { |file| IO.copy_stream(f, file) }
    end
  end
end
