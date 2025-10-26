class MessagesController < ApplicationController
  def create
    @conversation = Conversation.find(params[:conversation_id])

    if @conversation.participant?(current_user)
      @message = @conversation.messages.create(message_params.merge(user: current_user))

      if @message.persisted?
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to conversation_path(@conversation.other_user(current_user)) }
        end
      else
        render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Not authorized' }, status: :unauthorized
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end