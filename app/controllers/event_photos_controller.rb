class EventPhotosController < ApplicationController

  def create
    @event_photos = EventPhoto.new(photo_params)
    @event_photos.event_id = params['event_id']

    if @event_photos.save
      redirect_to :controller => "events", :action => "photos", :id => @event_photos.event_id
      #render json: { message: "success", photoId: @user_photos.id }, status: 200
    else
      render json: { error: @event_photos.errors.full_messages.join(", ") }, status: 400
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    if @photo.destroy
      render json: { message: "file deleted from server" }
    else
      render json: { message: @photo.errors.full_messages.join(", ") }
    end
  end

  def list

    binding.pry

    user = User.find(params[:user_id])

    photos = []
    EventPhoto.where(event_id: params[:event_id]).each do |photo|
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
    params.require(:event_photo).permit(:image,:event_id)
  end
end
