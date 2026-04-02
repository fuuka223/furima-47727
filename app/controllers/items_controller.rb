class ItemsController < ApplicationController
  def index
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.require(:Item).peremit(:image, :name, :info, :category_id, :sales_status, :shipping_fee_status, :prefecture,
                                  :scheduled_delivery, :price).merge(user_id: current_user.id)
  end
end
