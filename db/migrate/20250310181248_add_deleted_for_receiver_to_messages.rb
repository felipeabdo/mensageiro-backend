class AddDeletedForReceiverToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :deleted_for_receiver, :boolean
  end
end
