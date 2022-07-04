class User < ApplicationRecord
  include Discard::Model

  has_many :products, dependent: :destroy
  has_many :regulars, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :addresses
  has_many :orders, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  enum role: { general: 0, pic: 1,  admin: 2 }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


         def soft_delete  
          update_attribute(:discarded_at , Time.current)  
        end
      
        # ユーザーのアカウントが有効であることを確認 
        def active_for_authentication?  
          super && !discarded_at 
        end  
      
        # 削除したユーザーにカスタムメッセージを追加します  
        def inactive_message   
          !discarded_at ? super : :deleted_account  
        end 
end
