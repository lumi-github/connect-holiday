class HolidaysController < ApplicationController

  before_action :require_user_logged_in

  def create

    tmp_start_date = params[:holiday][:start_datetime].gsub('年', '-').gsub('月', '-').gsub('日', '')

    # 終日ではないときは、start_datetimeとend_datetimeを登録する
    if params[:holiday][:allday] == nil

      #Time.zone = 'Tokyo'
      Time.zone.now.to_date
      start_date = tmp_start_date + ' ' + params[:start_date_hour][:name] + ':' + params[:start_date_minutes][:name] + ':00'
      params[:holiday][:start_datetime] = start_date

      end_date = tmp_start_date + ' ' + params[:end_date_hour][:name] + ':' + params[:end_date_minutes][:name] + ':00'
      params[:holiday][:end_datetime] = end_date

    else
      # 終日休みに設定
      params[:holiday][:start_datetime] = tmp_start_date + ' 00:00:00'
      params[:holiday][:end_datetime] = tmp_start_date + ' 23:59:59'
    end

    @holiday = current_user.holidays.build(holiday_params)

    if @holiday.save
#      Time.zone = 'UTC'
      flash[:info] = '休みを追加しました。'
#      redirect_to profile_path(current_user.id)
    else
#      Time.zone = 'UTC'
      flash[:alert] = '休みを追加出来ませんでした。'
#      redirect_to event_path(event_id)
    end
  end

  private

  # Bookレコード作成
  def holiday_params
    params.require(:holiday).permit(:start_datetime, :end_datetime, :allday, :user_id)
  end
end
