class Micropost < ApplicationRecord
  # association
  belongs_to :user

  # ordering; 作成日時の降順
  default_scope lambda { order(created_at: :desc) }

  # 画像アップローダ
  mount_uploader :picture, PictureUploader

  # validation
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size

  private

  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end

end
