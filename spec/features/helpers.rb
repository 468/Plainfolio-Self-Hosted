module Helpers
  def sign_in(username,password)
    visit login_path
    fill_in('username', :with => username )
    fill_in('password', :with => password)
    click_button('Log in')
  end

  def sign_up(username,password,password_conf)
    visit signup_path
	  fill_in('admin_username', :with => username )
	  fill_in('admin_password', :with => password)
	  fill_in('admin_password_confirmation', :with => password_conf )
	  click_button('Sign Up')
  end

  def create_entry(username, portfolio, title='test title',summary='test summary',submit=true, signed_in=false)
    sign_in(admin.username,admin.password) unless signed_in == true
    visit portfolios_path
    within first(".column") do
      click_link('Add New Entry')
    end
    fill_in('entry[title]', :with => title)
    fill_in('entry[summary]', :with => summary)
    click_button('Create Entry') unless submit == false
  end

end