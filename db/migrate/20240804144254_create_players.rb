class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.references :lobby, null: false, foreign_key: true
      t.string :name
      t.string :avatar
      t.string :color
      t.integer :score, default: 0
      t.boolean :ready, default: false

      t.timestamps
    end
  end
end
