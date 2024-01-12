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

1000.times do |i|
  count = rand(0..5)
  question = user.questions.create!(
    title: "test #{i+1}",
    body: "This is the body of test #{i+1}!",
    views: rand(0..10000),
  )
  question.tag_list.add("TEST", "#{count}-Answers")
  question.save

  count.times do |j|
    answer = question.answers.create!(
      body: "This is the body of answer #{j+1} in question #{i+1}",
      accepted: 0,
      user_id: user.id,
    )
    rand(0..3).times do |k|
      answer.comments.create!(
        body: "This is the body of comment #{k+1} in answer #{j+1}",
        user_id: user.id,
      )
    end
  end

  rand(0..3).times do |j|
    question.comments.create!(
      body: "This is the body of comment #{j+1} in question #{i+1}",
      user_id: user.id,
    )
  end
end