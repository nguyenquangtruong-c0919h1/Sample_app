class Micropost < ApplicationRecord
  belongs_to :user
  belongs_to :follower, class_name: User.name
  belongs_to :followed, class_name: User.name

  has_one_attached :image
  scope :recent_posts, ->{order created_at: :desc}

  validates :content, presence: true,
    length: {maximum: Settings.content_maximum}
  validates :image, content_type: {in: Settings.image_type,
    message: I18n.t("microposts.message_format")},
    size: {less_than: Settings.number_five.megabytes,
    message: I18n.t("microposts.message_size")}

  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
