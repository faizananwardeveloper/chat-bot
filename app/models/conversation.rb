class Conversation < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  has_many :messages, dependent: :destroy

  validates :sender_id, uniqueness: { scope: :receiver_id }

  def self.between_users(user1, user2)
    where(sender_id: [user1.id, user2.id], receiver_id: [user1.id, user2.id]).first ||
      create(sender_id: user1.id, receiver_id: user2.id)
  end

  def other_user(current_user)
    sender == current_user ? receiver : sender
  end

  def last_message
    messages.order(created_at: :desc).first
  end

  def participant?(user)
    sender == user || receiver == user
  end

  def messages_with_user_scope
    messages.includes(:user).order(created_at: :asc)
  end
end