class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
      profile_path(current_user.id)
  end

  def change_prefecture
    @cities = City.where(prefecture_id: params[:pref_id])
    @controller_name = params[:controller_name]
    #@cities.unshift(["選択してください。", ""])
  end

  private
  
  #ログインしていなかったら、ログインページへ移動
  def require_user_logged_in
    if current_user == nil
      redirect_to new_user_session_path
    end
  end

end
