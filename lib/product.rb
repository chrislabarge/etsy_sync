class Product
  #:attr_accessor :id
  attr_accessor :etsy_image_url
 # attr_accessor :category
  attr_accessor :title
 # attr_accessor :description
 # attr_accessor :url
 # attr_accessor :price
  attr_accessor :image

  def initialize(listing, category)
    data = listing.result
    image = image_url(listing)

    @id = listing.id
    @date = Time.now.to_s
    @title = listing.title
    @category = category
    @description = listing.description
    @url = listing.url
    @price = listing.price
    @image = image
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

  def metadata
    @metadata ||= construct_metadata
  end

  def construct_metadata
    metadata = {}
    date = Time.now.to_s

    metadata['id'] = @id
    metadata['title'] = @title
    metadata['date'] = @date
    metadata['description'] = @description
    metadata['etsyLink'] = @url
    metadata['price'] = "%.2f" % @price
    metadata['image'] = @image
    metadata['categories'] = [@category]
    metadata['weight'] = @weight

    metadata
  end
end
