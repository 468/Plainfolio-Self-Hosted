class ChangeAdminEmailToUsername < ActiveRecord::Migration
  def change
    rename_column :admins, :email, :username
  end
end
