EventsController.class_eval do

  def show
    super do |format|
      format.full {
        @title = resource.title
        render :layout => 'iframe'
      }
    end
  end

  def create
    super

    # save knowledge_area in activity_objects table
    update_knowledge_area_id resource.activity_object_id, params[:event][:knowledge_area_id]
  end

  def update
    super

    # update knowledge_area in activity_objects table
    update_knowledge_area_id resource.activity_object_id, params[:event][:knowledge_area_id]
  end
  
  def allowed_params
    [
      :start_at, :end_at, :all_day,
      :frequency,
      # Weekly
      :week_days,
      # Monthly
      :week_day_order, :week_day, :interval,
      :room_id,
      :streaming,
      :embed,
      :language, :license_id, :knowledge_area_id, :age_min, :age_max, :scope, :avatar, :tag_list=>[]
    ]
  end

end
