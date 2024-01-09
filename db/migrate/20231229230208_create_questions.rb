class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.string :title
      t.text :body
      t.integer :views, default: 0
      t.integer :answers_count, default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
