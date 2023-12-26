class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.string :title
      t.text :body
      t.string :author
      t.integer :votes
      t.integer :answers
      t.integer :accepted
      t.integer :views
      t.string :tags

      t.timestamps
    end
  end

end
