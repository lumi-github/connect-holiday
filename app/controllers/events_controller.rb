class EventsController < ApplicationController

  require "date"
  include ApplicationHelper

  before_action :require_user_logged_in, only: [:new, :create, :book, :update, :basics, :comment, :address, :price, :photos, :option, :bankaccount, :publish]
  before_action :set_event, only: [:basics, :comment, :address, :price, :photos, :option, :bankaccount, :publish, :update]
  before_action :access_deny, only: [:book, :update, :basics, :comment, :address, :price, :photos, :option, :bankaccount, :publish]

  def index

    #都道府県の取得
    @prefectures = Prefecture.all

    @cities = City.where(prefecture_id: params[:pref_id])

    #カテゴリ取得
    @categories = Category.all

    #ヘッダー
    @header_prefecture
    @header_city
    @header_category

    #params
    @pref_id = params[:pref_id]
    @city_id = params[:city_id]
    @cat_id = params[:cat_id]
    holiday_events = nil

    ### セキュリティ対策
    #フォーム検索
    @keyword = ERB::Util.html_escape(params[:keyword])

    #TODO 修正する flashメッセージ　ここを表示する
    if @keyword.length > 100
      redirect_to root_url
    end

    #フォーム日付
    #@event_date = params[:event_date]

    #イベント 開始日が本日以降のイベント取得
    @events = Event.where("start_datetime >= ?", DateTime.now.in_time_zone('Tokyo'))

    #############################Holiday.whereで合ってる？
    holidays = Holiday.where("start_datetime >= ?", DateTime.now.in_time_zone('Tokyo'))

    #イベント絞込開始
    if params[:pref_id]
      #binding.pry
      @header_prefecture = Prefecture.find(params[:pref_id]).name
      @events = @events.where(prefecture_id: params[:pref_id])
    end

    if params[:city_id]
      @header_city = City.find_by(id: params[:city_id]).name
      @events = @events.where(city_id: params[:city_id])
    end

    if params[:cat_id]
      @header_category = Category.find(params[:cat_id]).name
      @events = @events.where(category_id: params[:cat_id])
    end

    #キーワード絞込
    if (params[:keyword] != nil)
      @events = @events.search(:title_or_content_cont => @keyword).result
    end

    #日付絞込
    if (params[:event_date] != nil && params[:event_date] != "")
      @event_date = params[:event_date]
      start_datetime = DateTime.parse(params[:event_date])
      end_datetime = DateTime.parse(params[:event_date]) + 1
      @events = @events.where(['start_datetime >= ?', start_datetime]).where(['end_datetime <= ?', end_datetime])
    end

    ##############################holidaysが無いときはエラー処理、ログインしていないときもエラー処理
    @only_holiday
    holiday_events = []
    holiday_event_ids = []
    if params['only_holiday']
      @only_holiday = 'checked'

      @events.each do |event|
        holidays.each do |holiday|
          if event.start_datetime >= holiday.start_datetime && event.end_datetime <= holiday.end_datetime
            holiday_event_ids << event.id

#            event_row = Event.new(read(event))
#            holiday_events << event_row
          end
        end
      end

      # 自分の休みのイベントが見つかった場合
      if holiday_event_ids.count > 0
        @events = Event.where("id IN (?)", holiday_event_ids)
      else
        @events = nil
        flash[:info] = 'イベントが見つかりませんでした。'
      end
    end

    if @events != nil

      #created_atで並び替え
      @events = @events.order('created_at desc')

      #ページネート
      @events = @events.page(params[:page])

      #カレンダー表示内容取得
      event_datas = @events

      #表示用データ成形
      @datas = [];
      event_datas.each do |data|

        show_page_url = link_calendar(data['id'])

        @datas += [
          'title' => data['title'],
          'start' => data['start_datetime'],
          'end'   => data['end_datetime'],
          'detail'=> data['content'],
          'url'=> show_page_url,
          'color' => 'orange'
        ]
      end

    end

  end

  def new

    @prefectures = Prefecture.all
    @cities = City.where(prefecture_id: params[:pref_id])

    #ログインしているユーザーのイベントを作成
    @event = current_user.events.build
    #1.times { @event.event_photos.build }

    @event.prefecture_id = params[:pref_id]
    @event.city_id = params[:city_id]
    @event.category_id = params[:cat_id]

  end

  def create

    @event = current_user.events.build(event_params)

    #if @event.save
    #  flash[:info] = 'イベントを作成しました。'
    #  redirect_to @event
    #else
    #  render action: "new"
    #end

    if @event.save
      redirect_to manage_event_basics_path(@event), notice: "イベントを作成・保存をしました"
    else
      @event = Event.new(event_params) #newで入力した値を代入
      render 'new', notice: "イベントを作成・保存出来ませんでした"
      #redirect_to new_event_path, notice: "イベントを作成・保存出来ませんでした"
    end

  end

  def show

    @login = false
    @booked = false

    @event_id = params[:event_id]
    @event = Event.find(params[:event_id])

    #イベント作成者
    @event_made_user = User.find(@event.user_id)

    # bookレコード用にデータを作成
    @book = Book.new

    if current_user
      @login = true
      @book.user_id = current_user.id

      # 既にこのイベントを登録しているかどうか
      if current_user.books.find_by(event_id: @event_id)
        @booked = true
      end
    end

    @book.event_id = params[:event_id]

    #イベント参加者がいる場合
    #book_users = {}
    #if @event.books.count > 0
    #  @event.books.each do |book|
    #    user = User.find(book.user_id)
    #    book_users['id'] = book.user_id
    #    book_users['name'] = user.name
    #    if user.user_photos.first != nil book_users['photo'] = user.user_photos.first.image.url(:thumb)
    #  end
    #end

  end

  def book

    event_id = params[:book][:event_id]
    @book = current_user.books.build(book_params)

    if @book.save
      flash[:info] = 'イベントを申し込みました。'
      redirect_to event_path(event_id)
    else
      flash[:alert] = '既にこのイベントを申し込みしています。'
      redirect_to event_path(event_id)
    end

  end

  def update

    action = Rails.application.routes.recognize_path(request.referer)[:action]

    #publishから遷移した場合は公開に設定
    if action == 'publish'
      #受取口座を指定していない場合はbankaccountに移動
      if current_user.stripe_user_id == nil
        flash[:info] = '公開の前に受取口座を設定して下さい。'
        redirect_to manage_event_bankaccount_path(params[:event_id]) and return
      else
        @event.state = true
      end
    end

    if @event.update(event_params)

      if action == 'basics'
        flash[:info] = '基本情報を更新しました。'
      elsif action == 'comment'
        flash[:info] = 'コメントを更新しました。'
      elsif action == 'address'
        flash[:info] = 'イベントの内容を更新しました。'
      elsif action == 'option'
        flash[:info] = 'オプションを更新しました。'
      elsif action == 'price'
        flash[:info] = '料金を更新しました。'
      elsif action == 'bankaccount'
        flash[:info] = '受取口座情報を更新しました。'
      elsif action == 'publish'
        flash[:info] = 'イベントを公開しました。'
      end

      if action != 'publish'
        redirect_to(:back)
      else
        redirect_to event_path(@event.id)
      end

    else
      flash[:info] = 'ERORRRRRRRRRR'
      render ''
    end
  end

  def basics
  end

  def comment
  end

  def address
    @cities = City.where(prefecture_id: @event.prefecture_id)
  end

  def price
  end

  def photos
    @event_photos = EventPhoto.new
  end

  def option
  end

  def bankaccount
    @user = @event.user
    session[:event_id] = @event.id
  end

  def publish
  end

  #def event_mail
  #  binding.pry
  #  NoticePlannerMailer.delay.notice_planner_email('lumi.xperia@gmail.com', 'test', 'cron-test', 'https://yahoo.co.jp')
  #end

  private

  # Eventレコード作成
  def event_params
    params.require(:event).permit(:title, :content, :start_datetime, :end_datetime, :accept_user_limit, :price, :hash_tag, :movie, :place, :latitude, :longitude, :user_id, :prefecture_id, :city_id, :category_id)
  end

  # Bookレコード作成
  def book_params
    params.require(:book).permit(:event_id, :user_id)
  end

  def set_event
    if params[:id] != nil
      @event = Event.find(params[:id])
    else
      @event = Event.find(params[:event][:id])
    end
  end

  def access_deny

    if !(current_user == @event.user)
      redirect_to root_path, notice: "他のユーザーの編集ページにはアクセスできません"
    elsif @event.state == true
      redirect_to profile_path(current_user.id), notice: "公開中のイベントは編集できません。"
    end

  end

end
