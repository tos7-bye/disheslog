class DishesController < ApplicationController

  def new
    @dish = Dish.new
  end

  def create
    @dish = current_user.dishes.build(dish_params)
    if @dish.save
      flash[:success] = "料理が登録されました！"
      redirect_to dish_path(@dish)
    else
      render "dishes/new"
    end
  end

  def show
    @dish = Dish.find(params[:id])
  end


  private
    def dish_params
      params.require(:dish).permit(:name, :description, :popularity, :reference, :required_time, :portion, :tips, :cook_memo)
    end
end
