FactoryGirl.define do
  factory :hbx_profile do
    organization            { FactoryGirl.build(:organization) }
    cms_id   "DC0"

  end
end
