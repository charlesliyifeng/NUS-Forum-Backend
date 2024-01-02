class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.string :title
      t.text :body
      t.integer :votes
      t.integer :answers_count
      t.integer :accepted
      t.integer :views
      t.string :tags
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
