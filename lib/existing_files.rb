require_relative 'sync_utilities'

class ExistingFiles
  def self.data
    products = []

    path = SyncUtilities.file_path_prefix

    Dir.glob(path + '*.md') do |file|
      f = open file
      data = Metadown.render(f.read)

      products << data.metadata
    end

    products
  end
end
