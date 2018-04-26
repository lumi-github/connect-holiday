require "time"

class EventWorker < ApplicationController

  include Sidekiq::Worker
  sidekiq_options queue: :event

  def perform(hour)

    #今日の日付
    today = Time.new

    users = User.where(notice_time: hour)

    start_work = today.year.to_s + today.month.to_s + today.day.to_s + '000000'
    end_work = today.year.to_s + today.month.to_s + today.day.to_s + '235959'
    start_work = Time.zone.parse(start_work)
    end_work = Time.zone.parse(end_work)

    users.each do |user|

      book_events = Event.joins(:books).where(books:{user_id: user.id}).where("start_datetime >= ?", DateTime.now.in_time_zone('Tokyo'))

      book_events.each do |book_event|
        #本日のイベント
        if book_event.start_datetime.between?(start_work, end_work)
          NoticePlannerMailer.delay.notice_planner_email(user.email, 'testtest', 'title', url)
        end
      end

    end

    #予約しているイベントが今日あった場合メールする
=begin
    if 1 == 1
      #url = root_url + 'users/sign_in'
      url = 'https://yahoo.co.jp'
      NoticePlannerMailer.delay.notice_planner_email(user.email, 'testtest', 'title', url)
    end
=end
    p 'work: title=' + hour

  end

end
