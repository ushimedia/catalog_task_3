class User < ApplicationRecord
  has_one :campany, inverse_of: :user
  accepts_nested_attributes_for :campany
  has_one :cart, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  enum role: { general: 0, pic: 1,  admin: 2 }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
