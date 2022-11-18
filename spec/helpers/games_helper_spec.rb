# frozen_string_literal: true
require 'rails_helper'

RSpec.describe GamesHelper, type: :helper do
  describe '#not_nan' do
    let(:nan) { 0 / 0.0 }
    let(:infinite) { 1 / 0.0 }
    let(:minus_infinite) { -1 / 0.0 }

    it 'transforms invalid numbers to "?"' do
      expect(helper.not_nan(nan)).to eq('?')
      expect(helper.not_nan(infinite)).to eq('?')
      expect(helper.not_nan(minus_infinite)).to eq('?')
    end
  end

  describe '#stats_list_since' do
    let(:input) do
      Array.new(3) { |i| [i.days.ago.to_date, i, i] }
    end

    it 'formats date and reverse list' do
      output_string = helper.stats_list_since(input)
      expect(helper.stats_list_since(input)).to be_a(String)
      parsed = JSON.parse("[#{output_string}]")
      expect(parsed).to have(3).elements
      expect(parsed.first.first).to match(%r{\A[0-9]+\/[0-9]+\Z})
    end
  end
end
