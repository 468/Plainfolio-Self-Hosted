class ColumnsController < ApplicationController
  before_action :get_portfolio
  before_action :authorize
  
  def update
    @column = @portfolio.columns.find(params[:id])
    respond_to do |format|
      if @column.update(column_params)
        format.html { redirect_to(portfolios_path, notice: 'Column was successfully updated.') }
        format.json { respond_with_bip(@column) }
      else
        format.html { redirect_to portfolios_path, flash: { error: @column.errors.empty? ? "Error" : @column.errors.full_messages.to_sentence } }
        format.json { respond_with_bip(@column) }
      end
    end
  end

  def toggle_show
    @column = @portfolio.columns.find(params[:column_id])
    if @column.toggle_show
      respond_to do |format|
        format.html
        format.js {render 'toggle_show', locals: { column: @column, showing: @column.show } }
      end
    else
      redirect_to portfolios_path
      flash[:error] = "Column show setting could not be toggled."
    end
  end

  def change_position
    column = @portfolio.columns.find(params[:column_id])
    old_position = column.position
    new_position = params[:new_position]
    column_to_replace = @portfolio.columns.find_by_position(new_position)
    if column.change_column_positions(old_position, new_position, column_to_replace)
      redirect_to portfolios_path
      flash[:notice] = "Column position changed."
    else
      redirect_to portfolios_path
      flash[:error] = "Error moving column."
    end
  end

  private

    def column_params
      params.require(:column).permit(:name, :show, :background_color, :text_color, :entries_per_page, :position)
    end
end
