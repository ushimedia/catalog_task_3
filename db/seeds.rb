# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(name: 'エリクソン（通信機器ベンダー）', company_address: '東京都港区東新橋0-3-17 MOMENTO SHIODOME', email: 'test1@yahoo.co.jp', password: 'test111', password_confirmation: 'test111', role: 2)
User.create(name: '協和エクシオ', company_address: '東京都港区東新橋1-3-17 MOMENTO SHIODOME', email: 'test2@yahoo.co.jp', password: 'test222', password_confirmation: 'test222', role: 1)
User.create(name: 'トーエネック', company_address: '東京都港区東新橋2-3-17 MOMENTO SHIODOME', email: 'test3@yahoo.co.jp', password: 'test333', password_confirmation: 'test333', role: 0)
User.create(name: '四国通建', company_address: '東京都港区東新橋3-3-17 MOMENTO SHIODOME', email: 'test4@yahoo.co.jp', password: 'test444', password_confirmation: 'test444', role: 0)
User.create(name: 'サンワコムシス', company_address: '東京都港区東新橋4-3-17 MOMENTO SHIODOME', email: 'test5@yahoo.co.jp', password: 'test555', password_confirmation: 'test555', role: 0)

20.times do |n|
    Product.create!(
      name:"商品#{n + 1}",
      description: "お徳用",
      price: 1980,
      stock: 5,
    
    )
end
