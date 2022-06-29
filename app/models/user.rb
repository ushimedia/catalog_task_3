class User < ApplicationRecord
  has_many :products
  has_one :cart, dependent: :destroy
  has_many :addresses
  has_many :orders
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  enum role: { general: 0, pic: 1,  admin: 2 }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
