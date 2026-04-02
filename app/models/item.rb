class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtentions
  belongs_to :category
  belongs_to :sales_status
  belongs_to :shipping_fee_status
  belongs_to :prefecture
  belongs_to :scheduled_delivery
  belongs_to :user
  has_one_attached :image

  validates :image, :name, :info, :price, presence: true
  validates :category_id, :sales_status, :shipping_fee_status, :prefecture, :scheduled_delivery,
            numericality: { other_than: 1, message: "can't be blank" }
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 300, less_than_or_equal_to: 9_999_999 }
end
