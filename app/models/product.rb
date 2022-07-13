class Product < ApplicationRecord
  include Discard::Model
  validates :name, uniqueness: { scope: [:discarded_at, :user] }
  validates :price, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  validates :stock, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0, in: 1..999 }

    has_many :cart_items, dependent: :destroy
    has_many :order_products, dependent: :destroy
    has_many :orders, through: :order_products
    belongs_to :user
    has_many :regular_products, dependent: :destroy
    enum status: { 出品中: true, 取り下げ中: false }
    mount_uploader :image, ImageUploader

  #エラーチェック処理
    def self.csv_format_check(file)
      errors = []
    CSV.foreach(file.path, headers: true).with_index(2) do |row, index|
      product = new(name: row[0], stock: row["在庫数"], price: row["税込価格"], description: row["商品説明"])
      if row[0].present?
        errors << "#{index}行目 商品名が空白です" if product.name.blank?
        errors << "#{index}行目 税込価格が空白です" if product.price.blank?
      else
        errors << "#{index}行目 商品名が空白です" if product.name.blank?
      end
      if row["在庫数"].present?
        errors << "#{index}行目 在庫数が無効です" if product.stock > 999
      else
        errors << "#{index}行目 在庫数が空白です" if product.stock.blank?
      end
      

    end
    errors
  end
      

  #登録処理
      def self.import_save(file, current)
        new_count = 0
        update_count = 0
        nochange_count = 0
        failure = 0
        failures = []
        CSV.foreach(file.path, headers: true).with_index(2) do |row, index|
          if product = find_by(name: row[0], user_id: current, discarded_at: nil)
            product.assign_attributes(name: row[0], stock: row["在庫数"], price: row["税込価格"], description: row["商品説明"])
            if product.changed?
              if product.save
                update_count += 1
              else
                failure += 1
                failures << "#{index}行目"
              end
            else
              nochange_count += 1
            end
          else
            product = new(name: row[0], stock: row["在庫数"], price: row["税込価格"], description: row["商品説明"], user_id: current)
              if product.save
              new_count += 1
              else
              failure += 1
              failures << "#{index}行目"
              end
          end
        end
        "新規登録：#{new_count}件、更新：#{update_count}件、変更なし：#{nochange_count}件、更新失敗：#{failure}件#{failures}"
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
