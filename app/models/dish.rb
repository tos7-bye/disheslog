class Dish < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validate  :picture_size
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 140 }
  validates :tips, length: { maximum: 50 }
  validates :popularity,
            :numericality => {
              :only_interger => true,
              :greater_than_or_equal_to => 1,
              :less_than_or_equal_to => 5
            },
            # 任意
            allow_nil: true

  private

  # アップロードされた画像のサイズを制限する
  def picture_size
    if picture.size > 5.megabytes
    errors.add(:picture, "：5MBより大きい画像はアップロードできません。")
    end
  end
end
