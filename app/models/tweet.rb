class Tweet < ApplicationRecord
  # associations
  belongs_to :user
  has_many :users, through: :likes
  has_many :likes, dependent: :destroy

  belongs_to :parent, class_name: "Tweet", optional: true
  has_many :replied_to, class_name: "Tweet",
                        foreign_key: "parent_id",
                        dependent: :destroy,
                        inverse_of: "parent"

  # validations
  validates :body, presence: true, length: { maximum: 140 }
end
