class PortfoliosController < ApplicationController
  require 'prawn'
  before_action :get_portfolio, except: [:new, :create]
  before_action :authorize, only: [:new, :create, :edit, :update, :destroy]
  before_action :protected?, only: :show

  rescue_from ActiveRecord::RecordNotFound, with: :portfolio_not_found

  def index
    impressionist(@portfolio) # 2nd argument is optional
    get_columns #put ordered columns in @columns, first column in @first_column
    @entries = {}
    @columns.each do |column|
      if params[:tag] && column != @first_column
        @entries[column] = column.get_entries(params[:tag]).paginate(:page => params[column.name.to_s], :per_page => column.entries_per_page)
      else
        @entries[column] = column.get_entries.paginate(:page => params[column.name.to_s], :per_page => column.entries_per_page)
      end
    end
    @tags = @portfolio.tags
    respond_to do |format|
      format.html
      format.pdf do
        if @portfolio.pdf_enabled
          send_data GeneratePDF.new(@portfolio).generate_pdf.render, filename: "#{@portfolio.title}.pdf", type: "application/pdf", disposition: "inline"
        else
          redirect_to @portfolio
        end
      end
      format.csv do
        if current_admin == @portfolio.admin
          send_data @portfolio.as_csv, filename: "#{@portfolio.title}.csv"
        else
          redirect_to @portfolio
        end
      end
      format.rss do
        if @portfolio.rss_enabled
          render :layout => false
        else
          redirect_to @portfolio
        end
      end
      format.json do
      end
    end
  end

  def portfolio_not_found
    redirect_to root_path, :flash => { :error => "No portfolio found at this URL!" }
  end

  def show
  end

  def protected?
    if !(admin_signed_in?)
      if @portfolio.passworded? && session[:portfolio_id] != @portfolio.id
        redirect_to portfolio_protected_path(@portfolio)
      end
    end
  end

  def password_submit
    if @portfolio.authenticate(params[:portfolio_password]['portfolio_password'])
      session[:portfolio_id] = @portfolio.id
      redirect_to @portfolio
    else
      flash[:error] = "Incorrect password."
      redirect_to portfolio_protected_path(@portfolio)
    end
  end

  def new
    if current_admin
      if portfolio_exists?
        redirect_to root_path
        flash[:error] = "Portfolio already exists!"
      else
        @portfolio = current_admin.build_portfolio
      end
    else
      flash[:error] = "Please sign in as an admin to create your portfolio"
      redirect_to login_path
    end
  end

  def create
    @portfolio = current_admin.build_portfolio(portfolio_params)
    if @portfolio.save
      redirect_to @portfolio
    else
      flash.now[:error] = @portfolio.errors.empty? ? "Error creating portfolio" : @portfolio.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    respond_to do |format|
      if @portfolio.update(portfolio_params)
        format.html { redirect_to(@portfolio, notice: 'Portfolio was successfully updated.') }
        format.json { respond_with_bip(@portfolio) }
      else
        format.html do
          redirect_to @portfolio
          flash[:error] = @portfolio.errors.empty? ? "Error updating portfolio" : @portfolio.errors.full_messages.to_sentence
        end
        format.json { respond_with_bip(@portfolio) }
      end
    end
  end

  private

    def get_columns
      @first_column = @portfolio.columns.first
      if @portfolio.admin == current_admin && !(params[:preview])
        @columns = @portfolio.columns
      else
        @columns = @portfolio.columns.where(show: true)
      end
    end

    def portfolio_params
      params.require(:portfolio).permit(:title, :font, :font_size, :passworded, :password, :url, :pdf_enabled, :rss_enabled)
    end

  
end
