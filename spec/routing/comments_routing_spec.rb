# frozen_string_literal: true
# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  game_id    :integer          not null
#  text       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :integer
#
# Indexes
#
#  index_comments_on_game_id  (game_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_03de2dc08c  (user_id => users.id)
#  fk_rails_8bbcb19e0f  (game_id => games.id)
#

require 'rails_helper'

RSpec.describe CommentsController, type: :routing do
  # describe "routing" do

  #   it "routes to #index" do
  #     expect(:get => "/comments").to route_to("comments#index")
  #   end

  #   it "routes to #new" do
  #     expect(:get => "/comments/new").to route_to("comments#new")
  #   end

  #   it "routes to #show" do
  #     expect(:get => "/comments/1").to route_to("comments#show", :id => "1")
  #   end

  #   it "routes to #edit" do
  #     expect(:get => "/comments/1/edit").to route_to("comments#edit", :id => "1")
  #   end

  #   it "routes to #create" do
  #     expect(:post => "/comments").to route_to("comments#create")
  #   end

  #   it "routes to #update via PUT" do
  #     expect(:put => "/comments/1").to route_to("comments#update", :id => "1")
  #   end

  #   it "routes to #update via PATCH" do
  #     expect(:patch => "/comments/1").to route_to("comments#update", :id => "1")
  #   end

  #   it "routes to #destroy" do
  #     expect(:delete => "/comments/1").to route_to("comments#destroy", :id => "1")
  #   end

  # end
end
