class SyncUtilities
  def self.file_path(title)
    filename = title.downcase.tr(' ', '_') + '.md'
    file_path_prefix + filename
  end

  def self.file_path_prefix
    ENV['SITE_PATH'] + 'content/products/'
  end

  def self.image_path(image_name)
    ENV['SITE_PATH'] + 'static/' + image_name
  end

  def self.needs_update?(old, new)
    old.find do |key, value|
      next if key == 'date'
      difference?(new[key].to_s, value.to_s)
    end
  end

  def self.difference?(val1, val2)
    Diffy::Diff.new(remove_whitespace(val1),
                    remove_whitespace(val2)).count > 0
  end

  def self.remove_whitespace(val)
    val.gsub(/\s+/, "")
  end
end
