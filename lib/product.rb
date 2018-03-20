class Product
  attr_accessor :id
  attr_accessor :etsy_image_url
  attr_accessor :category
  attr_accessor :title
  attr_accessor :description
  attr_accessor :url
  attr_accessor :price
  attr_accessor :image

  def initialize(listing, category)
    data = listing.result
    image = image_url(listing)

    @id = data['listing_id']
    @title = data['title']
    @category = category
    @description = data['description']
    @url = data['url']
    @price = data['price'].to_s
    @image = image
  end

  def format(_listing)
    @date = date
    @weight = 2
  end

  def image_url(listing)
    load_etsy_image(listing)

    name = URI(@etsy_image_url).path.split('/').last
    'img/' + name
  end

  def load_etsy_image(listing)
    data = listing.image.result
    @etsy_image_url = data['url_570xN']
  end
end
