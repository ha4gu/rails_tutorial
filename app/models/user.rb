class User < ApplicationRecord

  # トークンを保持するための remember_token 属性を定義
  attr_accessor :remember_token

  # force email strings to be saved as lower-case
  before_save { self.email = email.downcase }

  # validation
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX},
                    uniqueness: { case_sensitive: false }

  # password
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # 渡された文字列のパスワードハッシュ値を返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # トークンとして用いる、22桁のランダム文字列を返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 新たなトークンを用意し、そのハッシュ値をDBに格納する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  # トークンのハッシュ値を消去する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # 渡されたトークンが有効なトークンかどうかを判断する
  def authenticated?(remember_token)
    return false if remember_digest.nil? # ログアウト済みの特殊ケース
    BCrypt::Password.new(self.remember_digest).is_password?(remember_token)
  end

end
