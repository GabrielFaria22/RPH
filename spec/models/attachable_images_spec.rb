# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachableImages do
  subject(:resource) { build(factory_name) }

  shared_examples 'an attachable image resource' do
    it 'accepts portrait, cover, banner, crest, and up to 8 misc images' do
      attach_image(resource.portrait_image, filename: 'portrait.png', size: 1.kilobyte)
      attach_image(resource.cover_image, filename: 'cover.png', size: 1.kilobyte)
      attach_image(resource.banner_image, filename: 'banner.png', size: 1.kilobyte)
      attach_image(resource.crest_image, filename: 'crest.png', size: 1.kilobyte)
      8.times { |index| attach_image(resource.misc_images, filename: "misc-#{index}.png", size: 1.kilobyte) }

      expect(resource).to be_valid
    end

    it 'rejects image descriptions longer than 140 characters' do
      resource.portrait_image_description = 'a' * 141

      expect(resource).not_to be_valid
      expect(resource.errors[:portrait_image_description]).to include('is too long (maximum is 140 characters)')
    end

    it 'rejects more than 8 misc images' do
      9.times { |index| attach_image(resource.misc_images, filename: "misc-#{index}.png", size: 1.kilobyte) }

      expect(resource).not_to be_valid
      expect(resource.errors[:misc_images]).to include('can have at most 8 images')
    end

    it 'rejects oversized misc images' do
      attach_image(resource.misc_images, filename: 'large-misc.png', size: AttachableImages::MISC_IMAGE_MAX_SIZE + 1)

      expect(resource).not_to be_valid
      expect(resource.errors[:misc_images]).to include('must be 5MB or smaller')
    end

    it 'rejects non-image files' do
      resource.portrait_image.attach(
        io: StringIO.new('plain text'),
        filename: 'notes.txt',
        content_type: 'text/plain'
      )

      expect(resource).not_to be_valid
      expect(resource.errors[:portrait_image]).to include('must be a JPEG, PNG, WebP, or GIF')
    end

    it 'rejects horizontal portrait metadata' do
      attach_image(resource.portrait_image, filename: 'portrait.png', size: 1.kilobyte)
      resource.portrait_image.blob.metadata = { 'width' => 1200, 'height' => 800 }

      expect(resource).not_to be_valid
      expect(resource.errors[:portrait_image]).to include('must be vertically oriented')
    end

    it 'rejects vertical cover metadata' do
      attach_image(resource.cover_image, filename: 'cover.png', size: 1.kilobyte)
      resource.cover_image.blob.metadata = { 'width' => 800, 'height' => 1200 }

      expect(resource).not_to be_valid
      expect(resource.errors[:cover_image]).to include('must be horizontally oriented')
    end

    it 'rejects vertical banner metadata' do
      attach_image(resource.banner_image, filename: 'banner.png', size: 1.kilobyte)
      resource.banner_image.blob.metadata = { 'width' => 800, 'height' => 1200 }

      expect(resource).not_to be_valid
      expect(resource.errors[:banner_image]).to include('must be horizontally oriented')
    end
  end

  context 'with a universe' do
    let(:factory_name) { :universe }

    it_behaves_like 'an attachable image resource'
  end

  context 'with a world' do
    let(:factory_name) { :world }

    it_behaves_like 'an attachable image resource'
  end

  context 'with a character' do
    let(:factory_name) { :character }

    it_behaves_like 'an attachable image resource'
  end

  context 'with a location' do
    let(:factory_name) { :location }

    it_behaves_like 'an attachable image resource'
  end

  context 'with a family' do
    let(:factory_name) { :family }

    it_behaves_like 'an attachable image resource'
  end

  context 'with a faction' do
    let(:factory_name) { :faction }

    it_behaves_like 'an attachable image resource'
  end

  context 'with a family tree' do
    let(:factory_name) { :family_tree }

    it_behaves_like 'an attachable image resource'
  end

  def attach_image(target, filename:, size:)
    target.attach(
      io: StringIO.new('a' * size),
      filename: filename,
      content_type: 'image/png'
    )
  end
end
