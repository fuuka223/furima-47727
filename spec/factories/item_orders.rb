FactoryBot.define do
  factory :item_order do
    post_code      { Faker::Number.decimal_part(digits: 3) + '-' + Faker::Number.decimal_part(digits: 4) }
    prefecture_id  { Faker::Number.between(from: 2, to: 48) }
    city           { Faker::Address.city }
    addresses      { Faker::Address.street_address }
    building       { Faker::Address.secondary_address }
    phone_number   { '0' + Faker::Number.between(from: 100_000_000, to: 9_999_999_999).to_s }
    token          { 'tok_' + Faker::Alphanumeric.alphanumeric(number: 28) }
  end
end
