# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(name: '桐生一馬', email: 'test1@yahoo.co.jp', password: 'test111', password_confirmation: 'test111', role: 2)
User.create(name: '堂島大吾', email: 'test2@yahoo.co.jp', password: 'test222', password_confirmation: 'test222', role: 1)
User.create(name: '秋山駿', email: 'test3@yahoo.co.jp', password: 'test333', password_confirmation: 'test333', role: 0)
User.create(name: '冴島大河', email: 'test4@yahoo.co.jp', password: 'test444', password_confirmation: 'test444', role: 0)
User.create(name: '真島吾朗', email: 'test5@yahoo.co.jp', password: 'test555', password_confirmation: 'test555', role: 0)

20.times do |n|
    Product.create!(
      name:"商品#{n + 1}",
      description: "お徳用",
      price: 9800,
      stock: 500,
      status: true
    )
end