class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  after_create_commit :broadcast_to_conversation

  validates :content, presence: true

  private

  def broadcast_to_conversation
    receiver = conversation.sender_id == user_id ? conversation.receiver : conversation.sender

    broadcast_append_later_to(
      "user_#{receiver.id}_conversation_#{conversation.id}",
      target: "messages",
      partial: "messages/message_broadcast",
      locals: { message: self, sender: user }
    )
  end
end