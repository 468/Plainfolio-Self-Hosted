module ApplicationHelper
  def get_title
  	portfolio_exists? ? get_portfolio.title : 'Plainfolio'
  end
end
