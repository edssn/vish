class SearchController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  RESULTS_SEARCH_PER_PAGE=24

  def index
    params[:page] = params[:page] || 1

    @search_result =
      if params[:q].blank?
        search :extended
      elsif params[:mode] == "quick"
        search :quick
      else
        search :extended
      end

    respond_to do |format|
      format.html {
        if request.xhr?
          if params[:mode] == "quick"
            render partial: "quick"
          else
            render partial: 'results'            
          end
        end
      }

      format.json {
        json_obj = (
          params[:type].present? ?
          { params[:type].pluralize => @search_result.compact } :
          @search_result.compact
        )

        # render :json => json_obj.to_json(helper: self,:include => :author)
        render :json => render_json_result(@search_result)
      }

      format.js
    end
  end

  def advanced
    respond_to do |format|
      format.html {
        render
      }
    end
  end


  private

  def search mode
    page =  ( mode == :quick ? 1 : params[:page] )
    limit = ( mode == :quick ? 7 : RESULTS_SEARCH_PER_PAGE )

    if !params[:sort_by] && (params[:catalogue] || params[:directory] || params[:archive])
      if (params[:catalogue] && VishConfig.getCatalogueModels() === ["Excursion"]) || (params[:directory] && VishConfig.getDirectoryModels() === ["Excursion"]) || (params[:archive] && VishConfig.getArchiveModels() === ["Excursion"])
        params[:sort_by] = "quality"
      else
        params[:sort_by] = "popularity"
      end
    end

    case params[:sort_by]
    when 'ranking'
      order = 'ranking DESC'
    when 'popularity'
      #Use ranking instead of popularity
      order = 'ranking DESC'
      # order = 'popularity DESC'
    when "quality"
      order = 'qscore DESC'
    when 'updated_at'
      order = 'updated_at DESC'
    when 'created_at'
      order = 'created_at DESC'
    when 'visits'
      order = 'visit_count DESC'
    when 'favorites'
      order = 'like_count DESC'
    else
      #order by relevance
      order = nil
    end

    #age ranges. range1 is from 0 to 10. range2 10 to 14 and range 3 from 14 up
    case params[:age]
    when 'range1'
      params[:age_min] = 0
      params[:age_max] = 10
    when 'range2'
      params[:age_min] = 10
      params[:age_max] = 14
    when 'range3'
      params[:age_min] = 14
      params[:age_max] = 100
    end

    unless params[:ids_to_avoid].nil?
      params[:ids_to_avoid] = params[:ids_to_avoid].split(",")
    end

    #remove empty params   
    params.delete_if { |k, v| v == "" }

    unless params[:type]
      if params[:catalogue]
        #default models for catalogue without "type" filter applied
        params[:type] = VishConfig.getCatalogueModels().join(",")
      elsif params[:directory]
        params[:type] = VishConfig.getDirectoryModels().join(",")
      elsif params[:archive]
        params[:type] = VishConfig.getArchiveModels().join(",")
      end
    end
    models = ( mode == :quick ? SocialStream::Search.models(mode, params[:type]) : processTypeParam(params[:type]) )

    keywords = params[:q]

    #Check catalogue category
    categories = nil
    if params[:category_ids].is_a? String
      if Vish::Application.config.catalogue['mode'] == "matchtag"
        #Mode matchtag
        categories = params[:category_ids]
      else
        #Mode matchany
        keywords = []
        params[:category_ids].split(",").each do |category|
          keywords.push(Vish::Application.config.catalogue["category_keywords"][category])
        end
        keywords = keywords.flatten.uniq
      end
    end

    Search.search({:category_ids => categories, :query => keywords, :n=>limit, :page => page, :order => order, :models => models, :ids_to_avoid=>params[:ids_to_avoid], :startDate => params[:startDate], :endDate => params[:endDate], :language => params[:language], :qualityThreshold => params[:qualityThreshold], :tags => params[:tags], :tag_ids => params[:tag_ids], :age_min => params[:age_min], :age_max => params[:age_max] })
  end

  def processTypeParam(type)
    models = []    
    
    unless type.blank?
      allAvailableModels = VishConfig.getAllAvailableAndFixedModels(:include_subtypes => true)
      # Available Types: all available models and the alias 'Resource' and 'learning_object'
      allAvailableTypes = allAvailableModels + ["Resource", "Learning_object"]

      types = type.split(",") & allAvailableTypes

      if types.include? "Learning_object"
        los = VishConfig.getSearchModels(:include_users => false)
        los.delete("User")
        types.concat(los)
      end

      if types.include? "Resource"
        types.concat(VishConfig.getAvailableResourceModels(:include_subtypes => true).reject{|e| e=="Excursion" || e=="Workshop" })
      end

      types = types & allAvailableModels
      types.uniq!

      types.each do |type|
        #Find model
        model = type.singularize.classify.constantize rescue nil
        unless model.nil?
          models.push(model)
        end
      end
    end

    if models.empty?
      #Default models, all
      models = VishConfig.getSearchModels({:return_instances => true, :include_subtypes => true})
    end

    models.uniq!

    return models
  end
  
  def render_json_result (records)
    result = [];
    records.each do |e|

        url = ""
        if e.avatar_file_name.nil?
          if e.activity_object.object_type == "Event"
            url = "http://#{Rails.configuration.domain}/assets/items/rec2.jpg"
          elsif e.activity_object.object_type == "Excursion"
            url = e.thumbnail_url
          elsif e.activity_object.object_type == "EdiphyDocument"
            document = JSON.parse(e.json)
            url = document["present"]["globalConfig"]["thumbnail"] 
          end
        else
          url = "http://#{Rails.configuration.domain}/activity_objects/avatar/#{e.activity_object_id}.png?style=500"
        end

        obj = {
          entity_id: e.id,
          activity_object_id: e.activity_object_id, 
          activity_object_title: e.activity_object.title,
          activity_object_type: e.activity_object.object_type,
          activity_object_visit_count: e.activity_object.visit_count,
          activity_object_like_count: e.activity_object.like_count,
          author_id: e.author.id,
          author_name: e.author.name,
          avatar_url: url,
        }

        #pp e
        #puts "\n"
        #pp e.activity_object_id
        #pp e.activity_object
        # puts "\n"
        # pp e.author_id
        # pp e.author
        #pp '=============================================================='
        #puts "\n\n\n" 
        result.push(obj)
    end
    return result
  end
end

          