class User < ApplicationRecord
  # association
  has_many :microposts, dependent: :destroy

  # トークンを保持するための remember_token 属性、activation_token属性を定義
  attr_accessor :remember_token, :activation_token, :reset_token

  # force email strings to be saved as lower-case
  before_save :downcase_email
  before_create :create_activation_digest

  # validation
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX},
                    uniqueness: { case_sensitive: false }

  # password
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

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
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil? # ログアウト済みの特殊ケース
    BCrypt::Password.new(digest).is_password?(token)
  end

  # アカウントを有効にする
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # アクティベーションのためのメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    # update_attribute(:reset_digest, User.digest(reset_token))
    # update_attribute(:reset_sent_at, Time.zone.now)
    update_columns(reset_digest: User.digest(reset_token),
      reset_sent_at: Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限(2時間)が切れている場合はtrue
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

  # メールアドレスを小文字にする
  def downcase_email
    self.email.downcase!
  end

  # 有効化トークンとダイジェストを作成し代入する
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end
