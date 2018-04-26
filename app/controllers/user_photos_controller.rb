class UserPhotosController < ApplicationController
  def create
    @user_photos = UserPhoto.new(photo_params)
    @user_photos.user_id = current_user.id

    if @user_photos.save
      redirect_to :controller => "users", :action => "photos", :id => current_user.id
      #render json: { message: "success", photoId: @user_photos.id }, status: 200
    else
      render json: { error: @user_photos.errors.full_messages.join(", ") }, status: 400
    end
  end

  def destroy
    @photo = UserPhoto.find(params[:id])
    if @photo.destroy
      #画像削除成功のメッセージを表示する　画像削除成功のメッセージを表示する　画像削除成功のメッセージを表示する　画像削除成功のメッセージを表示する
      redirect_to :controller => "users", :action => "photos", :id => @photo.user_id
    else
      render json: { message: @photo.errors.full_messages.join(", ") }
    end
  end

  def priority
    current_user.user_photos.update(priority: false)
    current_user.user_photos.find(params[:id]).update(priority: true)

    redirect_to :controller => "users", :action => "photos", :id => current_user.id
  end

  def list

    binding.pry

    user = User.find(params[:user_id])

    photos = []
    UserPhoto.where(user_id: params[:user_id]).each do |photo|
      new_photo = {
        id: photo.id,
        name: photo.image_file_name,
        size: photo.image_file_size,
        src: photo.image(:thumb)
      }
      photos.push(new_photo)
    end
    render json: { images: photos }
  end

  private
  def photo_params
    params.require(:user_photo).permit(:image,:user_id)
  end
end
