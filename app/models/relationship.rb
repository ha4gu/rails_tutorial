class Relationship < ApplicationRecord
  # association
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  # validation
  validates :follower_id,  presence: true
  validates :followed_id,  presence: true

end
