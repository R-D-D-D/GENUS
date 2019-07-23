class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :publish, :unpublish]

  # GET /events
  # GET /events.json
  def index
    @events = Event.most_recent.published.paginate(page: params[:page], per_page: 5)
  end

  def front
    if(params[:tag].present?)
       @events = Event.most_recent.tagged_with(params[:tag]).paginate(page: params[:page], per_page: 5)
    else
       @events = Event.most_recent.paginate(page: params[:page], per_page: 5)
    end
      @tags = Event.tag_counts_on(:tags)
  end

  def publish
    @event.update(published: true, published_at: Time.now)
    redirect_to events_front_path
  end

  def unpublish
    @event.update(published: false,published_at: nil)
    redirect_to events_front_path
  end
  
  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete_image
    @image = ActiveStorage::Attachment.find(params[:images_id])
    @image.purge
    redirect_to event_path(params[:id])
  end

  def delete_video
    @video = ActiveStorage::Attachment.find(params[:videos_id])
    @video.purge
    redirect_to event_path(params[:id])
  end


  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:title, :tag_list, :content, images: [], videos: [])
    end
end
