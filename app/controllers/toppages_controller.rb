class ToppagesController < ApplicationController

  def index

    #EventWorker.perform_in(1)
    #EventWorker.perform_in 1.minute, 10
    EventWorker.perform_async('------------------------------処理開始------------------------------')
    #EventWorker.perform_async @event.id

    #ユーザープロフィールデータが未入力なら、プロフィールページで入力する
    #TODO あとでコメントアウト解除する
=begin
    if user_signed_in?
      if current_user.gender.blank?
        redirect_to profile_user_path(current_user)
      end
    end
=end

    #都道府県の取得
    @prefectures = Prefecture.all

    #カテゴリの取得
    @categories = Category.all

  end
end
