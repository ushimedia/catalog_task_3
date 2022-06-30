# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(name: 'SANPOU株式会社', company_address: '東京都千代田区飯田橋4-8-9', email: 'test1@yahoo.co.jp', password: 'test111', password_confirmation: 'test111', role: 2)
User.create(name: 'NOKIA（通信機器ベンダー）', company_address: '東京都世田谷区玉川一丁目14番1号', email: 'test2@yahoo.co.jp', password: 'test222', password_confirmation: 'test222', role: 1)
User.create(name: 'トーエネック東京本部', company_address: '東京都豊島区巣鴨1-3-11', email: 'test3@yahoo.co.jp', password: 'test333', password_confirmation: 'test333', role: 0)
User.create(name: '協和エクシオ', company_address: '東京都大田区平和島4丁目1番23号', email: 'test4@yahoo.co.jp', password: 'test444', password_confirmation: 'test444', role: 0)
User.create(name: 'サンワコムシス', company_address: '東京都品川区東五反田2-17-1', email: 'test5@yahoo.co.jp', password: 'test555', password_confirmation: 'test555', role: 0)

20.times do |n|
  Product.create!(
    name:"NOKIAの商品#{n + 1}",
    description: "MSA準拠SFPモジュール。光ファイバケーブルで最大で40kmの距離に対応し、安定した1GbE接続を提供します。",
    price: 1980,
    stock: 3,
    user_id: 2,
  )
end

5.times do |n|
  Order.create!(
    name:"トーエネック東京本部",
    address: "東京都豊島区巣鴨1-3-11",
    total_price: 1980,
    user_id: 3,
    created_at: "2022-06-#{n + 1} 13:58:53.271091",
    updated_at: "2022-06-#{n + 1} 13:58:53.271091",
  )
end

5.times do |n|
  OrderProduct.create!(
    product_id: 1,
    order_id: "#{n + 1}",
    order_quantity: 1,
    order_price: 1980,
    created_at: "2022-06-#{n + 1} 13:58:53.271091",
    updated_at: "2022-06-#{n + 1} 13:58:53.271091",
  )
end

