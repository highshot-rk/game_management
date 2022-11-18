# frozen_string_literal: true
require 'rails_helper'

describe IndiepadInjector do
  subject { described_class.new(file) }

  describe 'when index has a head tag' do
    let(:file) { "#{Rails.root}/spec/assets/index_with_head.html" }

    it 'injects script tag' do
      expect(File).to receive(:write) do |_, text|
        expect(text).to include('document.domain = "indiexpo.net"')
      end
      subject.inject!
    end
  end

  describe 'when index has no a head tag' do
    let(:file) { "#{Rails.root}/spec/assets/index_without_head.html" }

    it 'injects script tag' do
      expect(File).to receive(:write) do |_, text|
        expect(text).to include('document.domain = "indiexpo.net"')
      end
      subject.inject!
    end
  end
end
