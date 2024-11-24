class UpdatePlayerAvatarColumn < ActiveRecord::Migration[7.1]
  def change
    remove_column :players, :avatar
    add_column :players, :avatar, :string
  end
end
