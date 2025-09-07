class Post < ApplicationRecord
  has_one_attached :image

  belongs_to :user
  has_many   :favorites, dependent: :destroy

  validates :image,           presence: true
  validates :title,           presence: true
  validates :body,            presence: true
  #validates :genre,          presence: true
  #validates :kind,           presence: true
  #validates :origin_country, presence: true
  #validates :place,          presence: true
  
  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/asserts/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpg')
    end
    image
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

end
