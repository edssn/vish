class ScormfilesController < ApplicationController
  include SocialStream::Controllers::Objects
  skip_before_filter :store_location, :if => :format_full?

  def show
    respond_to do |format|
      format.zip {
        resource.increment_download_count
        return send_file resource.getZipPath(), :type=>"application/zip"
      }
      format.scorm {
        resource.increment_download_count
        return send_file resource.getZipPath(), :type=>"application/zip"
      }
      format.json {
        render :json => resource.as_json
      }
      format.full {
        @scormfile = resource
        @title = @scormfile.title
        render :layout => 'iframe'
      }
      format.all {
        super
      }
    end
  end

  def create
    super

    # save knowledge_area in activity_objects table
    update_knowledge_area_id resource.activity_object_id, params[:document][:knowledge_area_id]
  end

  def update
    super

    # update knowledge_area in activity_objects table
    update_knowledge_area_id resource.activity_object_id, params[:scormfile][:knowledge_area_id]
  end

  def destroy
    destroy! do |format|
      format.html {
        redirect_to url_for(current_subject)
       }
    end
  end


  private

  def allowed_params
    [:lourl,  :lopath, :zipurl, :zippath, :width, :height, :language, :license_id, :knowledge_area_id, :original_author, :license_attribution, :license_custom, :age_min, :age_max, :scope, :avatar, :tag_list=>[]]
  end
  
end

