class NoticePlannerMailer < ApplicationMailer
  add_template_helper(ActionView::Helpers::UrlHelper)
  #default from: 'post.connect-holiday@gmail.com'
  default from: 'connect-holiday.herokuapp.com'

  def notice_planner_email(recipient_user_email, booked_user_name, event_title, url)

    title = "#{booked_user_name}さんからイベントの参加申請を受けました！"
#    @recipient_user_email = recipient_user_email
    @booked_user_name = booked_user_name
    @url = url

    mail to: recipient_user_email, subject: title
  end
end
