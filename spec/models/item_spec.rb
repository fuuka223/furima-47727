require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @item = FactoryBot.build(:item)
  end

  describe '商品出品' do
    context '商品出品できるとき' do
      it '全ての項目が正しく入力されていれば登録できる' do
        expect(@item).to be_valid
      end
    end

    context '商品出品できないとき' do
      it 'name,info,priceが空では出品できない' do
        required_attributes = %w[name info price]
        required_attributes.each do |attribute|
          @item.send("#{attribute}=", '')
          @item.valid?
          expect(@item.errors.full_messages).to include("#{attribute.capitalize} can't be blank")
          @item = FactoryBot.build(:item)
        end
      end
      it 'imageが空では出品できない' do
        @item.image = nil
        @item.valid?
        expect(@item.errors.full_messages).to include("Image can't be blank")
      end
      it 'nameが41文字以上では登録できない' do
        @item.name = Faker::Lorem.characters(number: 41)
        @item.valid?
        expect(@item.errors.full_messages).to include('Name is too long (maximum is 40 characters)')
      end
      it 'infoが1001文字以上では登録できない' do
        @item.info = Faker::Lorem.characters(number: 1001)
        @item.valid?
        expect(@item.errors.full_messages).to include('Info is too long (maximum is 1000 characters)')
      end
      it 'ActiveHashが1では出品できない' do
        attributes = [:category_id, :sales_status_id, :shipping_fee_status_id, :prefecture_id, :scheduled_delivery_id]
        attributes.each do |attribute|
          @item.send("#{attribute}=", '1')
          @item.valid?
          expect(@item.errors.full_messages).to include("#{attribute.to_s.humanize} can't be blank")
          @item = FactoryBot.build(:item)
        end
      end
      it 'priceが不適切では出品できない' do
        invalid_prices = [
          { val: '299', msg: 'Price must be greater than or equal to 300' },
          { val: '10000000', msg: 'Price must be less than or equal to 9999999' },
          { val: '1000a', msg: 'Price is not a number' }
        ]
        invalid_prices.each do |invalid|
          @item.price = invalid[:val]
          @item.valid?
          expect(@item.errors.full_messages).to include(invalid[:msg])
          @item = FactoryBot.build(:item)
        end
      end
      it 'userが紐付いていなければ出品できない' do
        @item.user = nil
        @item.valid?
        expect(@item.errors.full_messages).to include('User must exist')
      end
    end
  end
end
