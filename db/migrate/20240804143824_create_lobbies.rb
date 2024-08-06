class CreateLobbies < ActiveRecord::Migration[7.1]
  def change
    create_table :lobbies do |t|
      t.string :code
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
