require_relative 'lib/product_sync'

#task :import_all do
#  sync = ProductSync.new
#  sync.import_all
#end

task :sync do
  sync = ProductSync.new
  sync.sync
end

task :import_new do
  sync = ProductSync.new
  sync.sync :new
end
