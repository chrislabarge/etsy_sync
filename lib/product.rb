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

    @id = listing.id
    @title = listing.title
    @category = category
    @description = listing.description
    @url = listing.url
    @price = listing.price
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
