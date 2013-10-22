FactoryGirl.define do
  sequence(:number) {|n| n }

  sequence(:name) {|n| "api_method_#{n}"}
  sequence(:site_name) {|n| "site_#{n}"}
  sequence(:email) {|n| "test_#{n}_test@example.com"}

  factory :site do
    name { FactoryGirl.generate(:site_name) }
  end

  factory :api_method do
    site
    name
  end

  factory :user do
    email {FactoryGirl.generate(:email)}
    password { "password" }
    password_confirmation { "password" }
  end

  factory :script_version do
    user
    api_method
    message { "A message describing the change" }
    script { "true" }
  end

  factory :alarm do
    api_method
    message { "An alarm happened" }
    remote_session { RemoteSession.get(nil) }
  end

end

