class SyncUtilities
  def file_path(title)
    filename = title.downcase.tr(' ', '_') + '.md'
    ENV['SITE_PATH'] + 'content/products/' + filename
  end

  def image_path(image_name)
    ENV['SITE_PATH'] + 'static/' + image_name
  end
end
