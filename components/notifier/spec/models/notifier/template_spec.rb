require 'rails_helper'

module Notifier
  RSpec.describe Template, type: :model do
    # pending "add some examples to (or delete) #{__FILE__}"

    describe '#attributes' do
      subject { FactoryGirl.create(:notifier_template) }
      it "   " do
        binding.pry
        expect(subject.attributes).to include subject.display_name
        expect(subject.attributes).to include subject.created_at
      end

    end


  end
end
