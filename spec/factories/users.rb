FactoryBot.define do
  factory :user do
    nickname { 'フリマ' }
    email { Faker::Internet.email }
    password { '1a2b3c4d' }
    password_confirmation { password }
    last_name { '山田' }
    first_name { '太郎' }
    last_name_kana { 'ヤマダ' }
    first_name_kana { 'タロウ' }
    birth_date { '2000-01-01' }
  end
end
