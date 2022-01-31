FactoryBot.define do
  factory :user_connection do

    trait :pending do
      status { 0 }
    end

    trait :accepted do
      status { 1 }
    end

    initiator_id { }
    recipient_id { }

  end
end
