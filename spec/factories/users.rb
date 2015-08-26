FactoryGirl.define do
  factory :user do
    auth_provider 'developer'
    auth_uid 'test'
    username { Faker::Internet.user_name.gsub(/[_ \.]/, '') }
    display_name { Faker::Name.first_name }
    is_admin false
    is_banned false
    session_key nil
  end

end
