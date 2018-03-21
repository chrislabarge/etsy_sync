ENV['RACK_ENV'] = 'test'

require_relative '../lib/product_sync.rb'
require 'rspec'

describe 'ProductSync' do
  let(:result) { {id: '123',
                  title: 'a product',
                  description: 'a description',
                  url: 'www.example.com',
                  price: '25.0'} }

  let(:listing) { double(:listing, result) }
  let(:service_wrapper) { double(:wrapper, get_user: 'store name') }
  let(:importer) { Importer.new }
  let(:category) { 'some category' }
  let(:logger) { double(:logger) }
  let(:prefix) { 'spec/tmp/' }

  before do
    allow(listing).to receive(:result) { result }
    allow(EtsyWrapper).to receive(:new) { service_wrapper }
    allow_any_instance_of(ProductSync).to receive(:file_path_prefix) { prefix }
    allow_any_instance_of(MarkdownGenerator).to receive(:file_path_prefix) { prefix }
    allow_any_instance_of(Importer).to receive(:download_img) { true }
    allow(service_wrapper).to receive(:get_category) { category }
    allow_any_instance_of(Product).to receive(:image_url) { 'example.com/picture.jpeg' }
    allow(Logger).to receive(:new) { logger }
    allow(Log).to receive(:up_to_date)
    allow(Log).to receive(:updated)
    allow(Log).to receive(:no_new)
    allow(logger).to receive(:info)

    product = Product.new(listing, category)
    importer.import [product]
  end

  context 'when there are no changes from the store service' do
    it 'Logs the up to date status message' do
      allow(service_wrapper).to receive(:get_listings) { [listing] }

      syncer = ProductSync.new

      syncer.sync

      expect(Log).to have_received(:no_new)
      expect(Log).to have_received(:up_to_date)
      expect(Log).not_to have_received(:updated)
    end
  end

  context 'when there are changes from the store service' do
    it 'updates the existing file' do
      change = 'some changes to the file'
      allow(listing).to receive(:description) { change }
      allow(service_wrapper).to receive(:get_listings) { [listing] }

      syncer = ProductSync.new

      syncer.sync

      actual = File.readlines(syncer.file_path(listing.title)).grep(/#{change}/).size > 0

      expect(Log).to have_received(:up_to_date)
      expect(Log).to have_received(:updated)
      expect(Log).to have_received(:no_new)
      expect(actual).to eq true
    end
  end
  j
  context 'when there is a new listing on the store service' do
    it 'imports the new listing/product' do
      allow(listing).to receive(:id) { 'new id' }
      allow(listing).to receive(:title) { 'new title' }
      allow(service_wrapper).to receive(:get_listings) { [listing] }

      syncer = ProductSync.new

      syncer.sync

      actual = Dir['**/spec/tmp/*'].length

      expect(actual).to eq 2
      expect(Log).not_to have_received(:no_new)
      expect(Log).to have_received(:up_to_date)
      expect(Log).not_to have_received(:updated)
    end
  end

  after do
    Dir.glob(prefix + '*.md').each do |path|
      FileUtils.rm path
    end
  end
end
