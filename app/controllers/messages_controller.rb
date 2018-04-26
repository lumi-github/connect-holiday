class MessagesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_conversation

  include ApplicationHelper

  # redirect_to this action from conversation controller create action
  def index
    # check if this current_user are involved in conversation
    if current_user == @conversation.sender || current_user == @conversation.recipient
      @other = current_user == @conversation.sender ? @conversation.recipient : @conversation.sender

      # 送信先のユーザー名を取得
      if current_user == @conversation.sender
        @recipient_user_name = @conversation.recipient.name
      else
        @recipient_user_name = @conversation.sender.name
      end

      @messages = @conversation.messages.order("created_at DESC")
    else
      redirect_to conversations_path, alert: "他人のメッセージにアクセスできません"
    end

  end

  def create

    params[:message][:user_id] = current_user.id

    @message = @conversation.messages.new(message_params)
    @messages = @conversation.messages.order("created_at DESC")
    url = root_url + 'users/sign_in'

    if @message.save

      conversation = Conversation.find(params[:conversation_id])
      conversation.touch
      conversation.save

      ##############################################################################################
      #並列処理に移動する
      recipient_user_email = get_user_email_by_name(params['recipient_user_name'])
      sender_user_name = get_user_name(current_user.id)
      MessageMailer.delay.message_email(recipient_user_email, sender_user_name, url)
      #MessageMailer.message_email(recipient_user_email, sender_user_name, url).deliver_later
      #MessageMailer.message_email(recipient_user_email, sender_user_name, @message, url).deliver
      ##############################################################################################

      #create.js.erb　が実行される
      respond_to do |format|
        format.js
      end
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:body, :user_id)
  end
end
