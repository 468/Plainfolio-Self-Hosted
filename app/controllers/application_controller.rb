class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def get_portfolio
    @portfolio = Portfolio.first
  end
  helper_method :get_portfolio

  def get_columns
    @first_column = @portfolio.columns.positioned.first
    if @portfolio.admin == current_admin && !(params[:preview])
      @columns = @portfolio.columns.positioned
    else
      @columns = @portfolio.columns.positioned.where(show: true)
    end
  end

  def current_admin
    @current_admin ||= Admin.find(session[:admin_id]) if (session[:admin_id] && admin_exists?)
  end
  helper_method :current_admin

  def authorize
    redirect_to login_url, alert: "Not authorized" if current_admin.nil?
  end
  helper_method :authorize

  def admin_signed_in?
    session[:admin_id]
  end
  helper_method :admin_signed_in?

  def portfolio_exists?
    Portfolio.first.nil? ? false : true
  end
  helper_method :portfolio_exists?

  def admin_exists?
    Admin.first.nil? ? false : true
  end


end
