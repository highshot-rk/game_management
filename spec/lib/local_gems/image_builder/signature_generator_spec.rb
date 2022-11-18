# frozen_string_literal: true
require 'rails_helper'

describe ImageBuilder::SignatureGenerator do
  let(:game) { create(:game) }

  subject { described_class.new(game) }

  before(:all) do
    ImageBuilder::Config.current[:temp_dir] = "#{Rails.root}/tmp/tmp_banner"
  end

  after(:all) { `rm -rf "#{Rails.root}/tmp/tmp_banner"` }

  it 'generates an image for a game' do
    file = subject.generate
    expect(File).to be_exist(file)
  end

  it 'is faster when running it multiple times' do
    `rm -rf "#{Rails.root}/tmp/tmp_banner"`
    time = Benchmark.measure { subject.generate }
    time2 = Benchmark.measure { subject.generate(true) }
    time3 = Benchmark.measure { subject.generate }
    expect(time.real).to be > time2.real
    expect(time2.real).to be > time3.real
  end
end
