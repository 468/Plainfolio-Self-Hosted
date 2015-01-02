class EntriesController < ApplicationController
  before_action :get_portfolio
  before_action :authorize, except: [:show]

 rescue_from ActiveRecord::RecordNotFound, with: :entry_not_found

  def entry_not_found
    redirect_to portfolio_path(@portfolio), flash: { error: "Entry not found." }
  end

  def new
    get_tags
  	@column = @portfolio.columns.find(params[:column_id])
  	@entry = @column.entries.build
  end

  def create
    get_tags
  	@column =  @portfolio.columns.find(params[:column_id])
  	@entry = @column.entries.build(entry_params)
    @entry.portfolio = @portfolio
  	if @entry.portfolio == current_admin.portfolio && @entry.save
      flash[:notice] = "Entry created."
  	  redirect_to portfolio_path(@portfolio)
  	else
      flash.now[:error] = @entry.errors.empty? ? "Error creating entry" : @entry.errors.full_messages.to_sentence
      if current_admin
        render :new
      end
  	end
  end

  def show
    @entry = @portfolio.entries.find(params[:title])
    get_tags
    @column = @entry.column
    @first_column = @portfolio.columns.first
    @first_column_entries = @first_column.entries.includes(:tags).order('id DESC')
  end

  def edit
    get_tags
    get_entry
  end

  def update
    get_entry
    get_tags
    @column = @entry.column
    if @entry.update(entry_params)
      redirect_to portfolio_entry_path(@portfolio, @entry)
      flash[:notice] = "Entry successfully updated"
    else
      flash.now[:error] = @entry.errors.empty? ? "Error updating entry" : @entry.errors.full_messages.to_sentence
      render :edit 
    end
  end

  def change_column
    entry = @portfolio.entries.friendly.find(params[:entry_title])
    new_column = Column.find(params[:entry][:column])
    if (current_admin == entry.portfolio.admin && current_admin == new_column.portfolio.admin) && entry.update(column: new_column)
      respond_to do |format|
        format.js do 
          render :nothing => true
          flash[:notice] = "Entry moved - displayed chronologically in new column."
        end
      end
    end
  end

  def destroy
    get_entry
    if @entry.destroy
      flash[:notice] = "Entry deleted"
      redirect_to @portfolio
    else
      flash[:error] = "Error deleting entry"
      redirect_to @portfolio
    end
  end

  private

    def entry_params
      params.require(:entry).permit(:title, :title_link, :summary, :content, :sticky, :external_title_link, :column, :external_url, :tag_ids => [] )
    end

    def get_entry
      @entry = current_admin.portfolio.entries.friendly.find(params[:title])
    end

    def get_tags
      @tags = @portfolio.tags
    end
end
