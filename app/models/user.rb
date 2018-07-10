class User < ApplicationRecord

  validates :username, :email, presence: true, uniqueness: true
  validates :session_token, :password_digest, presence: true
  validates :password, length: {minimum: 6, allow_nil: true}

  attr_reader :password

  def self.find_by_credentials(username, password)
    @user = User.find_by(username: username)
    @user && @user.is_password?(password) ? @user : nil
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end 

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def generate_session_token
    SecureRandom::urlsafe_base64
  end

  def reset_session_token!
    @user.session_token = generate_session_token
    @user.session_token
  end

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end



end
