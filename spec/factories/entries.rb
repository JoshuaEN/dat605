FactoryGirl.define do
  factory :entry do
    created_at {Time.zone.now}
	title ""
	content ""
	content_type 0
	category_id nil
	parent_entry_id nil

	association :user, factory: :user
  end

end
