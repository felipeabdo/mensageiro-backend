class FixMessageDeletionFlags < ActiveRecord::Migration[8.0]
  def up
    Message.where(deleted_for_sender: nil).update_all(deleted_for_sender: false)
    Message.where(deleted_for_receiver: nil).update_all(deleted_for_receiver: false)

    change_column_default :messages, :deleted_for_sender, false
    change_column_default :messages, :deleted_for_receiver, false
    change_column_null :messages, :deleted_for_sender, false
    change_column_null :messages, :deleted_for_receiver, false
  end

  def down
    change_column_null :messages, :deleted_for_sender, true
    change_column_null :messages, :deleted_for_receiver, true
    change_column_default :messages, :deleted_for_sender, nil
    change_column_default :messages, :deleted_for_receiver, nil
  end
end