require_relative 'sync_utilities'

class ExistingFiles < SyncUtilities
  attr_accessor :products

  def initialize
    @products = []

    Dir.glob(file_path_prefix + '*.md') do |file|
      f = open file
      data = Metadown.render(f.read)

      @products << data.metadata
    end
  end
end
