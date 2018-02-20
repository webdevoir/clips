class User < ApplicationRecord

  after_create :create_account

  #other modules: :lockable, :timeoutable
  has_many :videos, dependent: :destroy
  has_one :account, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  devise :omniauthable, :omniauth_providers => [:facebook] #todo: remove?

  def create_account
    account = Account.new(user_id: id, image: Rails.configuration.default_profile_image)
    if account.save
      print "Account created!!"
    else
      print account.errors.full_messages
    end
  end

  def uploader?
    videos.any?
  end

  def viewer?
    !uploader?
  end

  def self.from_omniauth(auth, origin)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.full_name = auth.info.name
      user.link = auth.extra.raw_info.link
      user.referrer = origin #for adwords tracking
      # user.image = auth.info.image # assuming the user model has an image
      user.skip_confirmation!
    end
  end

  def create_movie!(imdb_id, s3_id=nil)
    video = self.videos.create!(imdb_id: imdb_id, s3_id: s3_id, featured: true)
    video.update_from_omdb
  end
end
