class User < ApplicationRecord
  has_many :surveys
  has_many :visits
  has_many :restaurants, through: :visits

  validates :email, uniqueness: true, presence: true
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :google_id
  validates_presence_of :token
  validates_presence_of :refresh_token

  enum role: [:user, :admin]

  def self.update_or_create(oauth_data)
    user = User.find_by(google_id: oauth_data[:uid]) || User.new
    user.attributes = {google_id: oauth_data[:uid],
                      first_name: oauth_data[:info][:first_name],
                      last_name: oauth_data[:info][:last_name],
                      email: oauth_data[:info][:email],
                      token: oauth_data[:credentials][:token],
                      refresh_token: oauth_data[:credentials][:refresh_token]
                      }
    if user.save!
      return user
    else
      nil
    end
  end
end