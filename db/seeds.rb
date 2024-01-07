# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.create!(
  name: "Admin",
  email: "charlesliyifeng@gmail.com",
  password: "aA123456789",
)

5.times do |i|
  count = rand(1..5)
  question = user.questions.create!(
    title: "test #{i+1}",
    body: "This is the body of test #{i+1}!",
    views: i*100000,
    tags: "test #{i+1},interesting",
  )

  count.times do |j|
    question.answers.create!(
      body: "This is the body of answer #{j+1} in question #{i+1}",
      accepted: 0,
      user_id: user.id,
    )
  end
end