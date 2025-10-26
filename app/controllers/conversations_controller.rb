class ConversationsController < ApplicationController
  def index
    @conversations = current_user.conversations
  end

  def show
    @other_user = User.find(params[:id])
    @conversation = current_user.conversation_with(@other_user)
    @messages = @conversation.messages_with_user_scope
    @message = Message.new
  end
end