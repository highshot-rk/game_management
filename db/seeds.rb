# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Genre.first_or_create(
  [
    { name: 'Platformer' },
    { name: 'RPG' },
    { name: 'AAA' }
  ])

Language.first_or_create(
  [
    { name: 'English', locale: 'en' },
    { name: 'Italiano', locale: 'it' }
  ])

Tool.first_or_create(
  [
    { name: 'RPG Maker' },
    { name: 'Unity3D' }
  ])

Platform.first_or_create(
  [
    { name: 'pc' },
    { name: 'OSX' },
    { name: 'IOS' },
    { name: 'Android' }
  ])

if Rails.env.development?
  require 'factory_girl'
  Dir[File.dirname(__FILE__) + '/../spec/factories/*.rb'].each do |file|
    require file
  end
  include FactoryGirl::Syntax::Methods

  if User.count == 0
    u = User.new(
      username: 'progm',
      email: 'johnny_du_spaghi@virgilio.it',
      password: 'pelliccia',
      password_confirmation: 'pelliccia'
    )
    u.skip_confirmation!
    u.save!
  end

  create_list(:game, 20, :with_resources, :with_downloads) if Game.count == 0
  user = User.find_by(username: 'progm')
  if user && user.games.count == 0
    create(:game, :with_resources, :with_downloads, user: user)
  end
end
