class NoticePlannerMailer < ApplicationMailer
  add_template_helper(ActionView::Helpers::UrlHelper)
  #default from: 'post.connect-holiday@gmail.com'
  default from: 'connect-holiday.herokuapp.com'

  def notice_planner_email(recipient_user_email, booked_user_name, event_title, url)

    title = "#{booked_user_name}さんからイベントの参加申請を受けました！"
#    @recipient_user_email = recipient_user_email
    @content = booked_user_name + "さんからイベント名「#{event_title}」の参加申請が届きました。"
    @url = url

    mail to: recipient_user_email, subject: title
  end
end
