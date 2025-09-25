class Post < ApplicationRecord
  has_one_attached :image

  belongs_to :user
  has_many   :comments,  dependent: :destroy
  has_many   :favorites, dependent: :destroy

  validates :image,           presence: true
  validates :title,           presence: true
  validates :body,            presence: true
  validates :genre,           presence: true
  validates :kind,            presence: true
  validates :origin_country,  presence: true
  validates :place,           presence: true
  
  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/asserts/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpg')
    end
    image
  end

  def get_sq_image
    unless image.attached?
      file_path = Rails.root.join('app/asserts/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpg')
    end
    image.variant(gravity: :center, resize:"300x300^", crop:"300x300+0+0")
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.post_search_for(post_keyword, post_method)
    if post_method == "perfect"
      where(title: post_keyword)
    elsif post_method == "forward"
      where("title LIKE ?","#{post_keyword}%")
    elsif post_method == "backward"
      where("title LIKE ?","%#{post_keyword}")
    elsif post_method == "partial"
      where("title LIKE ?","%#{post_keyword}%")
    else
      none
    end
  end


  scope :latest, -> {order(created_at: :desc)}
  scope :old,    -> {order(created_at: :asc)}

  #scope :genre,          ->(s) { where(genre: Post.genres.keys & s) }
  #scope :kind,           ->(s) { where(kind: Post.kinds.keys & s) }
  #scope :origin_country, ->(s) { where(origin_country: Post.origin_countries.keys & s) }
  #scope :place,          ->(s) { where(place: Post.places.keys & s) }


  enum genre: {
    blank:  0,
    coffee: 1,
    cup:    2,
    goods:  3
  }, _prefix: true

  enum  kind:{
    unknown:         0,
    espresso:        1,
    doppio:          2,
    ristretto:       3,
    lungo:           4,
    americano:       5,
    latte:           6,
    cappuccino:      7,
    macchiato:       8,
    mocha:           9,
    flat_white:      10,
    cortado:         11,
    con_panna:       12,
    affogato:        13,
    irish_coffee:    14,
    vienna_coffee:   15,
    turkish_coffee:  16,
    greek_coffee:    17,
    french_press:    18,
    pour_over:       19,
    siphon:          20,
    cold_brew:       21,
    nitro_cold_brew: 22
  }, _prefix: true

  enum origin_country:{
    unknown:            0,
    brazil:             1,
    colombia:           2,
    ethiopia:           3,
    kenya:              4,
    guatemala:          5,
    costa_rica:         6,
    honduras:           7,
    el_salvador:        8,
    nicaragua:          9,
    panama:             10,
    peru:               11,
    mexico:             12,
    ecuador:            13,
    bolivia:            14,
    venezuela:          15,
    jamaica:            16,
    dominican_republic: 17,
    cuba:               18,
    puerto_rico:        19,
    indonesia:          20,
    vietnam:            21,
    thailand:           22,
    laos:               23,
    india:              24,
    yemen:              25,
    tanzania:           26,
    rwanda:             27,
    burundi:            28,
    uganda:             29,
    cameroon:           30,
    congo:              31,
    papua_new_guinea:   32
  }, _prefix: true

  enum place:{
    blank:0,
    cafe: 1,
    house:2,
    other:3
  }, _prefix: true

end
