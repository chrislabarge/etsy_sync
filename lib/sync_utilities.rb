class SyncUtilities
  def file_path(title)
    filename = title.downcase.tr(' ', '_') + '.md'
    file_path_prefix + filename
  end

  def file_path_prefix
    ENV['SITE_PATH'] + 'content/products/'
  end

  def image_path(image_name)
    ENV['SITE_PATH'] + 'static/' + image_name
  end
end
