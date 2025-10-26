class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :sent_conversations, class_name: 'Conversation', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_conversations, class_name: 'Conversation', foreign_key: 'receiver_id', dependent: :destroy
  has_many :messages, dependent: :destroy

  scope :all_except, -> (user) { where.not(id: user.id) }

  def name
    email.split('@').first.capitalize
  end

  def conversations
    Conversation.where("sender_id = ? OR receiver_id = ?", id, id)
                .includes(:sender, :receiver, messages: :user)
                .order(updated_at: :desc)
  end

  def conversation_with(other_user)
    Conversation.between_users(self, other_user)
  end

  def other_participant(conversation)
    conversation.sender == self ? conversation.receiver : conversation.sender
  end
end