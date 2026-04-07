class ItemOrder
  include ActiveModel::Model

  attr_accessor :user_id, :item_id, :post_code, :prefecture_id, :city, :addresses, :building, :phone_number, :token

  with_options presence: true do
    validates :user_id, :item_id, :city, :addresses, :token
    validates :post_code, format: { with: /\A[0-9]{3}-[0-9]{4}\z/, message: 'is invalid. Include hyphen(-)' }
    validates :phone_number, format: { with: /\A\d{10,11}\z/, message: 'is invalid' }
  end
  validates :prefecture_id, presence: true, numericality: { other_than: 0, message: "can't be blank" }
  validate :item_must_not_be_sold_out

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      order = Order.create(user_id: user_id, item_id: item_id)
      Address.create!(
        post_code: post_code,
        prefecture_id: prefecture_id,
        city: city,
        addresses: addresses,
        building: building,
        phone_number: phone_number,
        order_id: order.id
      )
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def item_must_not_be_sold_out
    return unless Order.exists?(item_id: item_id)

    errors.add(:item, 'has already been taken')
  end
end
