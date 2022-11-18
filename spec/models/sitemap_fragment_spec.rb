# frozen_string_literal: true
# == Schema Information
#
# Table name: sitemap_fragments
#
#  id                :integer          not null, primary key
#  content           :text             not null
#  fragmentable_id   :integer          not null
#  fragmentable_type :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  sitemap_fragmentable  (fragmentable_id,fragmentable_type) UNIQUE
#

require 'rails_helper'

RSpec.describe SitemapFragment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
