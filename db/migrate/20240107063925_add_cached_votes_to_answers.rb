class AddCachedVotesToAnswers < ActiveRecord::Migration[7.1]
  def change
    change_table :answers do |t|
      # t.integer :cached_votes_total, default: 0
      t.integer :cached_votes_score, default: 0
    end
  end
end
