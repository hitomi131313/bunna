# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Rails.env.development?
  Admin.create!(email: "admin@example.com", password: "admin0")
end

#ユーザー
ichigo = User.find_or_create_by!(email: "ichigo@example.com") do |user|
  user.name            = "ichigo"
  user.last_name       = "test1"
  user.first_name      = "test1"
  user.last_name_kana  = "test1"
  user.first_name_kana = "test1"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.jpeg"), filename:"sample-user1.jpeg")
end

nico = User.find_or_create_by!(email: "nico@example.com") do |user|
  user.name            = "nico"
  user.last_name       = "test2"
  user.first_name      = "test2"
  user.last_name_kana  = "test2"
  user.first_name_kana = "test2"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user2.jpeg"), filename:"sample-user2.jpeg")
end

mitsuba = User.find_or_create_by!(email: "mitsuba@example.com") do |user|
  user.name            = "mitsuba"
  user.last_name       = "test3"
  user.first_name      = "test3"
  user.last_name_kana  = "test3"
  user.first_name_kana = "test3"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user3.jpeg"), filename:"sample-user3.jpeg")
end



#投稿
Post.find_or_create_by!(title: "Ca-fe") do |post|
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post1.jpeg"), filename:"sample-post1.jpeg")
  post.body  = "気になっていたカフェラテを飲んできました。"
  post.user  = ichigo
end

Post.find_or_create_by!(title: "luxualy cup") do |post|
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post2.jpeg"), filename:"sample-post2.jpeg")
  post.body  = "友人はカプチーノ、私はモカを飲みました！美味しかった～"
  post.user  = nico
end

Post.find_or_create_by!(title: "喫茶三葉") do |post|
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post3.jpeg"), filename:"sample-post3.jpeg")
  post.body  = "名前が同じでふらっと寄ってみたらとても落ち着く空間で、マスターが素敵な方だった"
  post.user  = mitsuba
end