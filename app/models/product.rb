class Product < ApplicationRecord
    has_many :cart_items, dependent: :destroy
    has_many :order_products, dependent: :destroy
    has_many :orders, through: :order_products
    enum status: { 出品中: true, 取り下げ中: false }
    mount_uploader :image, ImageUploader

    def self.import(file, current)
        CSV.foreach(file.path, headers: true) do |row|
               row_hash = row.to_hash.slice(*CSV_HEADER.keys)
            product = find_or_initialize_by(name: row[0], user_id: current)
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
