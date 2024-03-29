class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

         validates :email, :type, presence: true
         belongs_to :postal_code
         
  has_many :orders
  has_many :notifications
  def jwt_payload
    { user_type: type }
  end

  def admin?
    type == 'Admin'
  end

  def customer?
    type == 'Customer'
  end
end
