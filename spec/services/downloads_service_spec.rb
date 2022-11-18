# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DownloadsService do
  let!(:user) { create(:user) }
  let!(:download_link) { create(:download_file) }

  subject { described_class.new(user: user) }

  describe '#create' do
    it 'creates a download' do
      expect do
        expect { subject.create(download_link) }.to change(Download, :count).by(1)
      end.to change { user.reload.score }.by(1)
    end
  end
end
