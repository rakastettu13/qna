class CreateAchievements < ActiveRecord::Migration[6.1]
  def change
    create_table :achievements do |t|
      t.string :name, null: false
      t.references :question, null: false, foreign_key: true
      t.references :winner, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
