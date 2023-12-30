class CreateAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :answers do |t|
      t.text :body
      t.string :author
      t.integer :votes
      t.integer :accepted
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
