# frozen_string_literal: true
require 'rails_helper'

describe Html5GamePrepare do
  let(:download) { create(:download_link, file_file_name: 'simple_game.zip') }

  describe 'flash games extraction' do
    after(:each) { FileUtils.rm_rf("#{Rails.root}/public/html5/#{download.id}") }

    it 'extracts a non-compressed swf game' do
      allow_any_instance_of(Paperclip::Attachment).to receive(:path)
        .and_return("#{Rails.root}/spec/assets/flash/test.swf")

      described_class.perform_now(download.id)

      expect(download.reload).to be_play_online

      result_path = "#{Rails.root}/public/html5/#{download.id}/index.swf"
      expect(File).to be_exist(result_path)
      expect(download.play_online_name).to eq('index.swf')
      FileUtils.rm_rf("#{Rails.root}/public/html5/#{download.id}")
    end

    it 'extracts a compressed swf game' do
      allow_any_instance_of(Paperclip::Attachment).to receive(:path)
        .and_return("#{Rails.root}/spec/assets/flash/test.swf.zip")

      described_class.perform_now(download.id)

      expect(download.reload).to be_play_online

      result_path = "#{Rails.root}/public/html5/#{download.id}/test.swf"
      expect(File).to be_exist(result_path)
      expect(download.play_online_name).to eq('test.swf')
    end

    it 'does\'t extract a nested compressed swf game' do
      allow_any_instance_of(Paperclip::Attachment).to receive(:path)
        .and_return("#{Rails.root}/spec/assets/flash/nested.zip")

      described_class.perform_now(download.id)

      expect(download.reload).not_to be_play_online

      # result_path = "#{Rails.root}/public/html5/#{download.id}/test.swf"
      # expect(File).to be_exist(result_path)
      # expect(download.play_online_name).to eq('test.swf')
    end
  end

  describe 'html5 games extraction' do
    after(:each) { FileUtils.rm_rf(extract_folder) }
    let(:extract_folder) { "#{Rails.root}/public/html5/#{download.id}" }

    it 'extracts a simple html game' do
      allow_any_instance_of(Paperclip::Attachment).to receive(:path)
        .and_return("#{Rails.root}/spec/assets/simple_game.zip")

      described_class.perform_now(download.id)

      result_path = "#{extract_folder}/index.html"

      expect(File).to be_exist(result_path)
      expect(download.reload).to be_play_online
    end

    it 'extracts also strange-named files' do
      allow_any_instance_of(Paperclip::Attachment).to receive(:path)
        .and_return("#{Rails.root}/spec/assets/(simple) with terr@ble$name.zip")

      described_class.perform_now(download.id)

      result_path = "#{extract_folder}/index.html"

      expect(File).to be_exist(result_path)
      expect(File.read(result_path)).to include('document.domain =')
      expect(download.reload).to be_play_online
    end

    it 'extracts a nested html game' do
      allow_any_instance_of(Paperclip::Attachment).to receive(:path)
        .and_return("#{Rails.root}/spec/assets/nested_game.zip")

      described_class.perform_now(download.id)

      result_path = "#{extract_folder}/index.html"

      expect(File).to be_exist(result_path)
      expect(download.reload).to be_play_online
      FileUtils.rm_rf("#{Rails.root}/public/html5/#{download.id}")
    end

    it 'skips download_links already processed' do
      download.update(play_online: true)

      result_path = "#{Rails.root}/public/html5/#{download.id}/index.html"

      described_class.perform_now(download.id)
      expect(File).not_to be_exist(result_path)
    end

    it 'skips .apk files' do
      allow_any_instance_of(Paperclip::Attachment).to receive(:path)
        .and_return("#{Rails.root}/spec/assets/simple_game.apk")

      described_class.perform_now(download.id)

      result_path = "#{extract_folder}/index.html"

      expect(File).not_to be_exist(result_path)
    end

    it 'skips non-zips files' do
      allow_any_instance_of(Paperclip::Attachment).to receive(:path)
        .and_return("#{Rails.root}/spec/assets/not_a_zip.zip")

      described_class.perform_now(download.id)

      result_path = "#{extract_folder}/index.html"

      expect(File).not_to be_exist(result_path)
    end

    it 'skips zips without an index.html in it' do
      allow_any_instance_of(Paperclip::Attachment).to receive(:path)
        .and_return("#{Rails.root}/spec/assets/no_game.zip")

      described_class.perform_now(download.id)

      result_path = "#{extract_folder}/index.html"

      expect(File).not_to be_exist(result_path)
    end
  end
end
