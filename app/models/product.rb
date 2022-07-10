class Product < ApplicationRecord
  include Discard::Model
  
  validates :price, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :stock, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0, in: 1..999 }

    has_many :cart_items, dependent: :destroy
    has_many :order_products, dependent: :destroy
    has_many :orders, through: :order_products
    belongs_to :user
    has_many :regular_products, dependent: :destroy
    enum status: { 出品中: true, 取り下げ中: false }
    mount_uploader :image, ImageUploader

  

    def self.import(file, current)
        CSV.foreach(file.path, headers: true) do |row|
               row_hash = row.to_hash.slice(*CSV_HEADER.keys)
            product = find_or_initialize_by(name: row[0], user_id: current, discarded_at: nil)
            if product.new_record? 
                product.attributes = row_hash.transform_keys(&CSV_HEADER.method(:[]))
                product.save
              end
         
            product.attributes = row_hash.transform_keys(&CSV_HEADER.method(:[]))
            product.save
        end
      end
      
      def self.updatable_attributes
        ["name", "description", "price", "stock"]
      end

      CSV_HEADER = {
        '商品名' => 'name',   
        '商品説明' => 'description', 
        '税込価格' => 'price',  
        '在庫数' => 'stock'
      }.freeze

end
