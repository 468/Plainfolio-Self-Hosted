class AdminsController < ApplicationController
  before_action :authorize, :except => [:new, :create]
  before_action :check_for_admin, :only => [:new, :create]

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)
    if @admin.save
      session[:admin_id] = @admin.id
      redirect_to root_url, notice: "You have created your admin account."
    else
      render "new"
    end
  end

  def index
    @admin = current_admin
  end

  def edit
    @admin = current_admin
  end

  def update
    @admin = current_admin
    if @admin.update_attributes(admin_params)
      redirect_to admins_path
      flash[:notice] = "Admin successfully updated"
    else
      flash.now[:error] = @admin.errors.empty? ? "Error updating admin" : @admin.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

    def check_for_admin
      if admin_exists?
        redirect_to root_path
        flash[:error] = "Admin account has already been created"
      end
    end

    def admin_params
      params.require(:admin).permit(:username, :password, :password_confirmation)
    end

end
