class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.references :lobby, null: false, foreign_key: true
      t.string :name
      t.boolean :host, default: false
      t.integer :score, default: 0

      t.timestamps
    end
  end
end
