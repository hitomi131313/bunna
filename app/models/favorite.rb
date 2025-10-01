class Favorite < ApplicationRecord

  belongs_to :user
  belongs_to :post

  validates :user_id, uniqueness: {scope: :post_id}

  scope :recent, -> {order("favorites.created_at DESC")}
end
