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
  
  validate :profile_image_content_type

  has_one_attached :profile_image




  has_many :posts,          dependent: :destroy
  has_many :comments,       dependent: :destroy

  has_many :favorites,      dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :post

  
  #フォローしてる側
  has_many :active_relationships,  class_name: "Relationship", 
                                   foreign_key: "follower_id", 
                                   dependent: :destroy
  has_many :followings, through: :active_relationships, 
                        source: :followed

  #フォローされてる側
  has_many :passive_relationships, class_name: "Relationship", 
                                   foreign_key: "followed_id", 
                                   dependent: :destroy
  has_many :followers,  through: :passive_relationships, 
                        source: :follower



  #フォローメソッド
  #フォローする
  def follow(user_id)
    active_relationships.create(followed_id: user_id)
  end
  #フォロー解除する
  def unfollow(user_id)
    active_relationships.find_by(followed_id: user_id)&.destroy
  end
  #フォローしてるか判定
  def following?(user)
    followings.include?(user)
  end


  scope :latest, -> {order(created_at: :desc)}
  scope :old,    -> {order(created_at: :asc)}


  def profile_image_content_type
    return unless profile_image.attached?

    unless profile_image.content_type.in?(%w(image/jpeg image/png image/webp))
      errors.add(:profile_image, 'はJPEG・PNG・WEBP形式のみアップロード可能です')
    end
  end

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
  

  def get_profile_square_image
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpg')
    end
    profile_image.variant(gravity: :center, resize:"400x400^", crop:"400x400+0+0")
  end

  GUEST_USER_EMAIL = "guest@example.com"
  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
      user.last_name = "guest"
      user.last_name_kana = "guest"
      user.first_name = "guest"
      user.first_name_kana = "guest"
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end

end
