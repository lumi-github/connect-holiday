class MessageMailer < ApplicationMailer
  add_template_helper(ActionView::Helpers::UrlHelper)
  #default from: 'post.connect-holiday@gmail.com'
  default from: 'connect-holiday.herokuapp.com'

  def message_email(recipient_user_email, sender_user_name, url)

    title = "新着メッセージが届いています!"
#    @recipient_user = recipient_user
    @content = "#{sender_user_name}さんから新着メッセージが届いています。"
    # urlは「root_path + 'users/sign_in'」のURL
    @url = url

    mail to: recipient_user_email, subject: title
  end
end
