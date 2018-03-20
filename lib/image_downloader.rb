require 'open-uri'

class ImageDownloader
  def initialize(product)
    @product = product
  end

  def download
    @img_url = @product.etsy_image_url
    path = ENV['SITE_PATH'] + 'static/' + @product.image

    open(@img_url) do |f|
      File.open(path, 'wb') { |file| IO.copy_stream(f, file) }
    end
  end
end
