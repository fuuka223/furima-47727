class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtentions
  belongs_to :category
  belongs_to :sales_status
  belongs_to :shipping_fee_status
  belongs_to :prefecture
  belongs_to :scheduled_delivery

  belongs_to :user
end
