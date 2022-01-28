FactoryBot.define do
  factory :user do
    username { 'default' }
    email { 'default@email.com' }
    password { 'default' }
  end
end