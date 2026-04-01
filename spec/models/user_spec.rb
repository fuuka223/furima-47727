require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context '新規登録できるとき' do
      it '全ての項目が正しく入力されていれば登録できる' do
        expect(@user).to be_valid
      end
    end

    context '新規登録できないとき' do
      # 全項目共通のテスト
      it '必須項目が空では登録できない' do
        required_attributes = {
          nickname: "Nickname can't be blank",
          email: "Email can't be blank",
          password: "Password can't be blank",
          last_name: "Last name can't be blank",
          first_name: "First name can't be blank",
          last_name_kana: "Last name kana can't be blank",
          first_name_kana: "First name kana can't be blank",
          birth_date: "Birth date can't be blank"
        }

        required_attributes.each do |attribute, message|
          @user.send("#{attribute}=", '')
          @user.valid?
          expect(@user.errors.full_messages).to include(message)
          @user = FactoryBot.build(:user)
        end
      end

      # emailのテスト
      it 'emailの形式やDBとの重複があると登録できない' do
        @user.save
        another_user = FactoryBot.build(:user, email: @user.email)
        another_user.valid?
        expect(another_user.errors.full_messages).to include('Email has already been taken')
        # @抜け
        @user.email = 'testmail.com'
        @user.valid?
        expect(@user.errors.full_messages).to include('Email is invalid')
      end

      # passwordのテスト
      it 'passwordが不適切だと登録できない' do
        invalid_passwords = [
          { val: '00000', msg: 'Password is too short (minimum is 6 characters)' },
          { val: Faker::Internet.password(min_length: 129, max_length: 150),
            msg: 'Password is too long (maximum is 128 characters)' },
          { val: 'aaaaaa', msg: 'Password は半角英数字の両方を含めて設定してください' },
          { val: '111111', msg: 'Password は半角英数字の両方を含めて設定してください' },
          { val: 'ａａａ１１１', msg: 'Password は半角英数字の両方を含めて設定してください' },
          { val: 'aaa11!', msg: 'Password は半角英数字の両方を含めて設定してください' }
        ]

        invalid_passwords.each do |pw|
          @user.password = pw[:val]
          @user.password_confirmation = pw[:val]
          @user.valid?
          expect(@user.errors.full_messages).to include(pw[:msg])
        end

        @user.password = '111aaa'
        @user.password_confirmation = '222bbb'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end

      # 本人情報（名前）の全角テスト
      it '名字・名前が全角（漢字・ひらがな・カタカナ）でないと登録できない' do
        invalid_names = ['yamada', '123', '山田!']

        [:last_name, :first_name].each do |attr|
          invalid_names.each do |name|
            @user[attr] = name
            @user.valid?
            expect(@user.errors.full_messages).to include("#{attr.to_s.humanize} is invalid")
          end
        end
      end

      # 本人情報（フリガナ）のカタカナテスト
      it 'フリガナが全角カタカナでないと登録できない' do
        invalid_kanas = ['やまだ', '山田', 'yamada', '123', 'ヤマダ!']

        [:last_name_kana, :first_name_kana].each do |attr|
          invalid_kanas.each do |kana|
            @user[attr] = kana
            @user.valid?
            expect(@user.errors.full_messages).to include("#{attr.to_s.humanize} is invalid")
          end
        end
      end
    end
  end
end
