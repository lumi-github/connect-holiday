module ApplicationHelper

  # ユーザー名を取得
  def get_event_title(event_id)
    Event.find(event_id).title
  end

  # ユーザーを取得
  def get_user(user_id)
    User.find(user_id)
  end

  # ユーザー名を取得
  def get_user_name(user_id)
    User.find(user_id).name
  end

  # idからユーザー名を取得
  def get_user_email_by_id(user_id)
    User.find(user_id).email
  end

  # idからユーザー名を取得
  def get_user_email_by_name(user_name)
    User.find_by(name: user_name).email
  end

  # 性別を取得
  def get_gendar(gendar_id)
    gendar_id == 1 ? '男性' : '女性'
  end

  # 生年月日から年齢を取得
  def get_age(user_age)
    date_format = "%Y%m%d"
    ((Date.today.strftime(date_format).to_i - user_age.strftime(date_format).to_i) / 10000).to_s + '歳'
  end

  # 英語の都道府県名を取得
  def get_prefecture_eigo_name(prefecture_id)
    return Prefecture.find(prefecture_id).eigo_name
  end

  # 英語の市町村名を取得
  def get_city_eigo_name(city_id)
    return City.find(city_id).eigo_name
  end

  # 都道府県名を取得
  def get_prefecture_name(prefecture_id)
    return Prefecture.find(prefecture_id).name
  end

  # 市町村名を取得
  def get_city_name(city_id)
    return City.find(city_id).name
  end

  def get_form_path

    path = ""

    #都道府県 市町村 カテゴリー
    if params[:pref_id].presence && params[:city_id].presence && params[:cat_id].presence

      path = pref_city_cat_events_path(params[:pref_id], params[:city_id], params[:cat_id])

    #都道府県 市町村
    elsif params[:pref_id].presence && params[:city_id].presence && params[:cat_id].blank?

      path = pref_city_events_path(params[:pref_id], params[:city_id])

    #都道府県 カテゴリー
    elsif params[:pref_id].presence && params[:city_id].blank? && params[:cat_id].presence

      path = pref_cat_events_path(params[:pref_id], params[:cat_id])

    #都道府県
    elsif params[:pref_id].presence && params[:city_id].blank? && params[:cat_id].blank?

      path = pref_events_path(params[:pref_id])

    #カテゴリー
    elsif params[:pref_id].blank? && params[:city_id].blank? && params[:cat_id].presence
      path = cat_events_path(params[:cat_id])
    end

    return path

  end

  def link_location_and_category(prefectures, cities, categories, type)

    link_locations = []
    link_categories = []

    #ロケーション リンクの作成

    if type == "location"

      # 検索で遷移してきた場合
      if params[:pref_id].blank? && params[:city_id].blank? && params[:cat_id].blank?

        prefectures.each do |prefecture|
          a = link_to prefecture.name, pref_events_path(prefecture.id)
          link_locations << a
        end

        return link_locations

      # 都道府県 市町村 カテゴリー
      elsif params[:pref_id].presence && params[:city_id].presence && params[:cat_id].presence

        cities.each do |city|
          a = link_to city.name, pref_city_cat_events_path(params[:pref_id], params[:city_id], params[:cat_id])
          link_locations << a
        end

        return link_locations

      # 都道府県 市町村
      elsif params[:pref_id].presence && params[:city_id].presence && params[:cat_id].blank?

        cities.each do |city|
          a = link_to city.name, pref_city_events_path(city.prefecture_id, city.id)
          link_locations << a
        end

        return link_locations

      # 都道府県 +市町村 カテゴリー
      elsif params[:pref_id].presence && params[:city_id].blank? && params[:cat_id].presence

        cities.each do |city|
          a = link_to city.name, pref_city_cat_events_path(params[:pref_id], city.id, params[:cat_id])
          link_locations << a
        end

        return link_locations

      # 都道府県
      elsif params[:pref_id].presence && params[:city_id].blank? && params[:cat_id].blank?

        cities.each do |city|
          a = link_to city.name, pref_city_events_path(city.prefecture_id, city.id)
          link_locations << a
        end

        return link_locations

      # +都道府県 カテゴリー
      elsif params[:pref_id].blank? && params[:city_id].blank? && params[:cat_id].presence

        prefectures.each do |prefecture|
          a = link_to prefecture.name, pref_cat_events_path(prefecture.id, params[:cat_id])
          link_locations << a
        end

        return link_locations

      end

    #カテゴリー リンクの作成
    else

      # カテゴリー
      if params[:pref_id].blank? && params[:city_id].blank? && params[:cat_id].blank?

        categories.each do |category|
          a = link_to category.name, cat_events_path(category.id)
          link_categories << a
        end

        return link_categories

      elsif params[:pref_id].blank? && params[:city_id].blank? && params[:cat_id].presence

        categories.each do |category|
          a = link_to category.name, cat_events_path(category.id)
          link_categories << a
        end

        return link_categories

      # 都道府県 +カテゴリー
      elsif params[:pref_id].presence && params[:city_id].blank? && params[:cat_id].blank?

        categories.each do |category|
          a = link_to category.name, pref_cat_events_path(params[:pref_id], category.id)
          link_categories << a
        end

        return link_categories

      # 都道府県 カテゴリー
      elsif params[:pref_id].presence && params[:city_id].blank? && params[:cat_id].presence

        categories.each do |category|
          a = link_to category.name, pref_cat_events_path(params[:pref_id], category.id)
          link_categories << a
        end

        return link_categories

      # 都道府県 市町村 +カテゴリー　
      elsif params[:pref_id].presence && params[:city_id].presence && params[:cat_id].blank?

        categories.each do |category|
          a = link_to category.name, pref_city_cat_events_path(params[:pref_id], params[:city_id], category.id)
          link_categories << a
        end

        return link_categories

      # 都道府県 市町村 カテゴリー　
      elsif params[:pref_id].presence && params[:city_id].presence && params[:cat_id].presence

        categories.each do |category|
          a = link_to category.name, pref_city_cat_events_path(params[:pref_id], params[:city_id], category.id)
          link_categories << a
        end

        return link_categories

      end

    end

  end

  def link_calendar(event_id)
    url = root_url + "events/" + event_id.to_s
    return url
  end

  def jpy_comma(value)
    value.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1,') + '円'
  end

end
