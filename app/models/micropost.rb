class Micropost < ApplicationRecord
  # association
  belongs_to :user

  # ordering; 作成日時の降順
  default_scope lambda { order(created_at: :desc) }

  # validation
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

end
