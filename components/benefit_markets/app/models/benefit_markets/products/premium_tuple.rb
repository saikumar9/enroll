module BenefitMarkets
  class Products::PremiumTuple
    include Mongoid::Document
    include Mongoid::Timestamps
    include Comparable

    embedded_in :premium_table,
                class_name: "BenefitMarkets::Products::PremiumTable"

    field :age,   type: Integer
    field :cost,  type: Float

    validates_presence_of :age, :cost


    def comparable_attrs
      [:age, :cost]
    end

    # Define Comparable operator
    # If instance attributes are the same, compare PremiumTuples
    def <=>(other)
      if comparable_attrs.all? { |attr| eval(attr.to_s) == eval("other.#{attr.to_s}") }
        0
      else
        other.updated_at.blank? || (updated_at < other.updated_at) ? -1 : 1
      end
    end

  end
end