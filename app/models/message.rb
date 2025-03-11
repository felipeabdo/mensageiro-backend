class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  validates :content, presence: true
  validates :sender_id, presence: true
  validates :receiver_id, presence: true

  scope :not_deleted, ->(user_id) {
    where(deleted_for_all: false)
    .where(
      "(sender_id = :user_id AND deleted_for_sender = false) OR 
      (receiver_id = :user_id AND deleted_for_receiver = false)",
      user_id: user_id
    )
  }
end