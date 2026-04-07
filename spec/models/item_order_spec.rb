require 'rails_helper'

RSpec.describe ItemOrder, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)
    @item_order = FactoryBot.build(:item_order, user_id: @user.id, item_id: @item.id)
    sleep 0.1
  end

  describe '商品購入機能' do
    context '購入できる場合' do
      it 'すべての値が正しく入力されていれば購入できる' do
        expect(@item_order).to be_valid
      end
      it 'buildingは空でも購入できる' do
        @item_order.building = ''
        expect(@item_order).to be_valid
      end
      it 'phone_numberが10桁であれば保存できる' do
        @item_order.phone_number = '0901234567'
        expect(@item_order).to be_valid
      end
      it 'phone_numberが11桁であれば保存できる' do
        @item_order.phone_number = '09012345678'
        expect(@item_order).to be_valid
      end
    end

    context '購入できない場合' do
      it 'post_codeが空だと購入できない' do
        @item_order.post_code = ''
        @item_order.valid?
        expect(@item_order.errors.full_messages).to include("Post code can't be blank")
      end
      it 'post_codeのハイフンがないと購入できない' do
        @item_order.post_code = '1234567'
        @item_order.valid?
        expect(@item_order.errors.full_messages).to include('Post code is invalid. Include hyphen(-)')
      end
      it 'post_codeのハイフンの位置が異なると購入できない' do
        @item_order.post_code = '12-34567'
        @item_order.valid?
        expect(@item_order.errors.full_messages).to include('Post code is invalid. Include hyphen(-)')
      end
      it 'prefecture_idを選択していない（値が0）と購入できない' do
        @item_order.prefecture_id = 0
        @item_order.valid?
        expect(@item_order.errors.full_messages).to include("Prefecture can't be blank")
      end
      it 'cityが空だと購入できない' do
        @item_order.city = ''
        @item_order.valid?
        expect(@item_order.errors.full_messages).to include("City can't be blank")
      end
      it 'addressesが空だと購入できない' do
        @item_order.addresses = ''
        @item_order.valid?
        expect(@item_order.errors.full_messages).to include("Addresses can't be blank")
      end
      it 'phone_numberが空だと購入できない' do
        @item_order.phone_number = ''
        @item_order.valid?
        expect(@item_order.errors.full_messages).to include("Phone number can't be blank")
      end
      it 'phone_numberが9桁以下では購入できない' do
        @item_order.phone_number = '090123456'
        @item_order.valid?
        expect(@item_order.errors.full_messages).to include('Phone number is invalid')
      end
      it 'phone_numberが12桁以上では購入できない' do
        @item_order.phone_number = '090123456789'
        @item_order.valid?
        expect(@item_order.errors.full_messages).to include('Phone number is invalid')
      end
      it 'phone_numberに半角数字以外が含まれている場合は購入できない' do
        @item_order.phone_number = '090-1234-5678'
        @item_order.valid?
        expect(@item_order.errors.full_messages).to include('Phone number is invalid')
      end
      it 'userが紐付いていないと購入できない' do
        @item_order.user_id = nil
        @item_order.valid?
        expect(@item_order.errors.full_messages).to include("User can't be blank")
      end
      it 'itemが紐付いていないと購入できない' do
        @item_order.item_id = nil
        @item_order.valid?
        expect(@item_order.errors.full_messages).to include("Item can't be blank")
      end
      it 'tokenが空では購入できない' do
        @item_order.token = nil
        @item_order.valid?
        expect(@item_order.errors.full_messages).to include("Token can't be blank")
      end
      it 'tokenが不正な値では購入できない' do
        @item_order.token = 'invalid_token'
        @item_order.token = ''
        @item_order.valid?
        expect(@item_order.errors.full_messages).to include("Token can't be blank")
      end
      it '既に購入された商品は購入できない' do
        another_user = FactoryBot.create(:user)
        another_order = Order.create(user_id: another_user.id, item_id: @item.id)
        @item_order.valid?
        expect(@item_order.errors.full_messages).to include('Item has already been taken')
      end
    end
  end
end
