class Like < ApplicationRecord
  # associations
  belongs_to :user
  belongs_to :tweet, counter_cache: true

  # validations
  validates :tweet_id, uniqueness: { scope: :user_id }

  # Method increment & decrement
  after_create :increment_likes
  after_destroy :decrement_likes

  def increment_likes
    tweet.increment(:likes_count)
    tweet.save
  end

  def decrement_likes
    tweet.decrement(:likes_count)
    tweet.save
  end
end
