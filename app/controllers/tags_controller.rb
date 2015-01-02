class TagsController < ApplicationController
  before_action :get_portfolio
  before_action :authorize

  def index
  	get_tags
  	@tag = @portfolio.tags.build
  end

  def create
  	@tag = @portfolio.tags.build(tag_params)
  	if @tag.save
  	  redirect_to tags_path
      flash[:notice] = "Tag created."
  	else
      redirect_to tags_path
      flash[:error] = @tag.errors.empty? ? "Error creating tag" : @tag.errors.full_messages.to_sentence
  	end
  end

  def update
  	get_tag
  	if @tag && @tag.update(tag_params)
  	  redirect_to tags_path
      flash[:notice] = "Tag updated."
  	else
      redirect_to tags_path
      if @tag
        flash[:error] = @tag.errors.empty? ? "Error updating tag" : @tag.errors.full_messages.to_sentence
      else
        flash[:error] = "Tag not found."
      end
  	end
  end

  def destroy
    get_tag
    if @tag && @tag.delete
      redirect_to tags_path
      flash[:notice] = "Tag deleted."
    else
      redirect_to tags_path
      if @tag
        flash[:error] = @tag.errors.empty? ? "Error updating tag" : @tag.errors.full_messages.to_sentence
      else
        flash[:error] =  "Tag could not be deleted"
      end
    end
  end

  private

    def tag_params
    	params.require(:tag).permit(:name, :text_color, :background_color)
    end

    def get_tags
      @tags = Tag.all
    end

    def get_tag
      begin
        @tag = @portfolio.tags.find(params[:id])
      rescue
        return
      end
    end
end
