# frozen_string_literal: true
FactoryGirl.define do
  factory :game do
    sequence(:title) { |n| "Game title #{n}" }
    sequence(:slug) { |n| "game-title-#{n}" }
    sequence(:description) { |n| "Game description #{n}" }
    release_type 'complete'
    author 'my_author'

    before(:create) do |instance|
      instance.download_links << build(:download_url, game: instance)
      instance.game_languages.new(language: build(:language))
    end

    trait :with_resources do
      after(:create) do |instance, _evaluator|
        create_list(:screen, 3, game: instance)
        create_list(:artwork, 3, game: instance)
      end
    end

    trait :with_play_online do
      after(:create) do |instance, _evaluator|
        create(:download_url, game: instance, play_online: true)
      end
    end

    trait :with_downloads do
      after(:create) do |instance, _evaluator|
        create_list(:download_url, 2, game: instance)
      end
    end

    trait :with_scores do
      after(:create) do |instance, _evaluator|
        create_list(:score, 2, game: instance)
      end
    end

    trait :with_news do
      after(:create) do |instance, _evaluator|
        create_list(:news, 2, game: instance)
      end
    end

    trait :with_comments do
      after(:create) do |instance, _evaluator|
        create_list(:news, 2, game: instance)
      end
    end

    association :user
    association :tool
    association :genre
  end
  # factory :card do
  #   sequence(:description) { |n| "Card description #{n}" }

  #   sequence(:file_url) { |n| "http://example.com/card_#{n}.file" }

  #   association :topic, factory: :topic
  #   association :user, factory: :member

  #   trait :with_votes do
  #     transient { number_of_votes 1 }
  #     transient { voted_by(-1) }
  #     transient { positive true }

  #     after(:create) do |instance, evaluator|
  #       options = {}
  #       options[:card] = instance
  #       options[:user] = evaluator.voted_by if evaluator.voted_by != -1
  #       options[:positive] = evaluator.positive
  #       n = evaluator.number_of_votes
  #       build_list(:vote, n, options)
  #     end

  #     after(:create) do |instance, evaluator|
  #       options = {}
  #       options[:card] = instance
  #       options[:user] = evaluator.voted_by if evaluator.voted_by != -1
  #       options[:positive] = evaluator.positive
  #       n = evaluator.number_of_votes
  #       create_list(:vote, n, options)
  #     end
  #   end

  #   trait :with_tags do
  #     transient { number_of_tags 5 }
  #     transient { basename 'tags' }

  #     after(:build) do |instance, evaluator|
  #       instance.tag_list = Array.new(evaluator.number_of_tags) do |i|
  #         "#{evaluator.basename}#{i + 1}"
  #       end
  #     end

  #     after(:create) do |instance, evaluator|
  #       instance.tag_list = Array.new(evaluator.number_of_tags) do |i|
  #         "#{evaluator.basename}#{i + 1}"
  #       end
  #       instance.save && instance.reload
  #     end
  #   end

  #   trait :with_comments do
  #     transient { number_of_comments 2 }

  #     after(:create) do |instance, evaluator|
  #       create_list(:comment, evaluator.number_of_comments, card: instance)
  #     end
  #   end

  #   factory :image, class: :image do
  #     is_cover false
  #     file_url 'http://www.vetprofessionals.com/catprofessional/images/home-cat.jpg'
  #   end

  #   factory :document, class: :document do
  #     file_url 'http://www.education.gov.yk.ca/pdf/pdf-test.pdf'
  #     embed_html '<iframe src="https://drive.google.com/viewerng/viewer?url=http%3A//www.education.gov.yk.ca/pdf/pdf-test.pdf&embedded=true" width="500" height="650" style="border: none;"></iframe>'
  #   end

  #   factory :plain_text, class: :plain_text do
  #     sequence(:title) { |n| "Plain Text Card Title #{n}" }
  #     description 'Plain Text Contribution Description'
  #   end

  #   factory :article, class: :article do
  #     file_url 'https://medium.com/@mackenziechild/how-i-finally-learned-rails-95e9b832675b'
  #     title 'How I finally learned Rails'
  #     description 'Example article description'
  #     embed_html "Hint: I built 12 different web apps in 12 weeks Several months ago I set out to learn Rails once and for all. I had dabbled with rails several times in the prior years, but I would always simply give up or find something 'more interesting' when I got stuck or things became difficult."
  #     additions('thumbnail_url' => 'https://d262ilb51hltx0.cloudfront.net/max/800/1*CApooC3bDhy04muZYZ3dCw.png',
  #               'author_name' => 'Mackenzie Child',
  #               'author_url' => 'https://medium.com/@mackenziechild',
  #               'provider_name' => 'Medium')
  #   end

  #   factory :video, class: :video do
  #     file_url 'https://www.youtube.com/watch?v=9bZkp7q19f0'
  #     title 'PSY - GANGNAM STYLE(강남스타일) M/V'
  #     embed_html '<iframe class="embedly-embed" src="//cdn.embedly.com/widgets/media.html?src=http%3A%2F%2Fwww.youtube.com%2Fembed%2F9bZkp7q19f0%3Ffeature%3Doembed&amp;url=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3D9bZkp7q19f0&amp;image=http%3A%2F%2Fi.ytimg.com%2Fvi%2F9bZkp7q19f0%2Fhqdefault.jpg&amp;key=7c4c130437b3403ab254d76c5015b5a5&amp;type=text%2Fhtml&amp;schema=youtube" width="854" height="480" scrolling="no" frameborder="0" allowfullscreen="" data-connected="1"></iframe>'
  #     additions('thumb' => 'http://i.ytimg.com/vi/9bZkp7q19f0/hqdefault.jpg')
  #   end

  #   factory :draft, class: :image do
  #     is_cover false
  #   end
  # end
end
