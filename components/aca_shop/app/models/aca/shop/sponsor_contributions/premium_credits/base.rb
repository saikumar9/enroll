module Aca
  module Shop
    module SponsorContributions
      class Base
        include Mongoid::Document
        include Mongoid::Timestamps

        embeds_one  :premium_credit_formula
        embeds_many :credit_relationship_categories, class_name: "Aca::Shop::SponsorContributions::CreditRelationshipCategory"
      end
    end
  end
end