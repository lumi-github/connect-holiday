class UsersController < ApplicationController

  require "date"
  include ApplicationHelper

  before_action :require_user_logged_in, only: [:profile, :photos]

  def profile

    @user = User.find(params[:user_id])
    @param_user_id = params[:user_id].to_i

    # 初期登録が済んでいない場合はinit_profileにジャンプ
    if @user.name == nil || @user.gender == nil || @user.birthday == nil || @user.prefecture_id == nil || @user.city_id == nil
      redirect_to init_profile_user_path(current_user.id)
      return
    end

    if current_user == @user

      @current_user_photos = @user.user_photos

      #ユーザー画像をビルド
      user_photos_count = @user.user_photos.count

      if user_photos_count < 3
        @user.user_photos.build
      end

      @my_events = current_user.events
      @my_events = @my_events.order('created_at desc')

#      @holiday = current_user.holidays.build

      #休みのカレンダー表示内容取得
      event_datas = current_user.holidays

      #表示用データ成形
      @datas = [];
      event_datas.each do |data|

#      title = 'お休み' + data['start_datetime'].hour.to_s + '時' + data['start_datetime'].min.to_s + '分' + 'fROM' + data['end_datetime'].hour.to_s + '時' + data['end_datetime'].min.to_s + '分'
        title = 'お休み'
        @datas += [
          'title' => title,
          'start' => data['start_datetime'],
          'end'   => data['end_datetime'],
          'color' => 'orange'
        ]
      end
    end
  end

  # プロファイルアップデート
  #def image_upload
  #  @user = User.find(current_user.id)
  #  1.times { @user.user_photos.build }

#    params[:user][:user_id] = current_user.id
#    params[:user][:image] = params[:image]

#    if @user.save(user_photos_params)
      #flash[:info] = '写真を登録しました。'
#      redirect_to profile_path(user_id: current_user.id)
      #redirect_to controller: 'users', action: 'profile', user_id: current_user.id
#    else
      #flash[:info] = '写真を登録できませんでした。'
#      render action: "user"
#    end
#  end

  # 会員登録後のプロフィール情報必須項目登録ページ
  def init_profile
    @user = User.find(current_user.id)

    # 都道府県を取得
    @prefectures = Prefecture.all
  end

  def init_profile_update
    @user = User.find(current_user.id)

    #タグをエスケープ
    params[:user][:comment] = ActionController::Base.helpers.strip_tags(params[:user][:comment])

    if @user.update(user_params)
      flash[:success] = '正常に更新されました'
      redirect_to profile_path(@user)
    else
      flash.now[:danger] = '更新されませんでした'
      render :init_profile
    end

  end

  def photos
    @user = current_user
    @user_photos = UserPhoto.new
  end

  private

  # Userレコード更新
  def user_params
    params.require(:user).permit(:user_id, :name, :name, :gender, :birthday, :message, :comment, :prefecture_id, :city_id)
  end

  def user_photos_params
    params.require(:user).permit(:user_id, user_photos_attributes: [:image])
  end

end
