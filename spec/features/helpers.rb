module Helpers
  def sign_in(email,password)
    visit login_path
    fill_in('email', :with => email )
    fill_in('password', :with => password)
    click_button('Log in')
  end

  def sign_up(email,password,password_conf)
    visit signup_path
	  fill_in('admin_email', :with => email )
	  fill_in('admin_password', :with => password)
	  fill_in('admin_password_confirmation', :with => password_conf )
	  click_button('Sign Up')
  end

  def create_entry(admin, portfolio, title='test title',summary='test summary',submit=true, signed_in=false)
    sign_in(admin.email,admin.password) unless signed_in == true
    visit portfolio_path(portfolio)
    within first(".column") do
      click_link('Add New Entry')
    end
    fill_in('entry[title]', :with => title)
    fill_in('entry[summary]', :with => summary)
    click_button('Create Entry') unless submit == false
  end

end