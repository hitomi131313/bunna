class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name,            presence: true, uniqueness: true
  validates :last_name,       presence: true
  validates :first_name,      presence: true
  validates :last_name_kana,  presence: true
  validates :first_name_kana, presence: true
  
  has_one_attached :profile_image

  has_many :posts,     dependent: :destroy
  has_many :comments,  dependent: :destroy
  has_many :favorites, dependent: :destroy

  scope :latest, -> {order(created_at: :desc)}
  scope :old,    -> {order(created_at: :asc)}

  def self.user_search_for(user_keyword, user_method)
    if user_method == "perfect"
      where(name: user_keyword)
    elsif user_method == "forward"
      where("name LIKE ?","#{user_keyword}%")
    elsif user_method == "backward"
      where("name LIKE ?","%#{user_keyword}")
    elsif user_method == "partial"
      where("name LIKE ?","%#{user_keyword}%")
    else
      none
    end
  end

  def get_profile_image(width,height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpg')
    end
    profile_image.variant(resize_to_limit: [width, height])
  end
  
  def get_profile_sq_image
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpg')
    end
    profile_image.variant(gravity: :center, resize:"300x300^", crop:"300x300+0+0")
  end
end
