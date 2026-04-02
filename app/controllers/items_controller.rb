class ItemsController < ApplicationController
  def index
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.save(item_params)
  end

  private

  def item_params
    params.require(:Item).peremit(:image, :name, :info, :category_id, :sales_status, :shipping_fee_status, :prefecture,
                                  :scheduled_delivery, :price).merge(user_id: current_user.id)
  end
end
