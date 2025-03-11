class AddDeletedFlagsToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :deleted_for_all, :boolean, default: false
    add_column :messages, :deleted_for_sender, :boolean, default: false
  end
end