class CreateGuesses < ActiveRecord::Migration[7.1]
  def change
    create_table :guesses do |t|
      t.references :player, null: false, foreign_key: true
      t.references :round, null: false, foreign_key: true
      t.string :content, null: false
      t.boolean :correct, default: false
      t.boolean :close, default: false

      t.timestamps
    end
  end
end
