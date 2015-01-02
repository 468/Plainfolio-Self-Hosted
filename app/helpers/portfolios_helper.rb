module PortfoliosHelper

  def get_column_class
  	# determines whether or not to show all 5 columns (ie admin view)
  	admin_signed_in? && !(params[:preview]) ? columns = get_portfolio.columns.count : columns = get_portfolio.columns.where(show: true).count
    if columns == 1
  	  'full'
    elsif columns == 2
  	  'half'
    elsif columns == 3
  	  'third'
    elsif columns == 4
  	  'quarter'
    else
  	  'fifth'
    end
  end

  def hidden?(column)
    if column.show == true
      ' show'
    else
      ' hidden'
    end
  end

end
