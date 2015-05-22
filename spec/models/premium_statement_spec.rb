require 'rails_helper'

describe PremiumStatement, dbclean: :after_each do

  let(:employer_profile)  { FactoryGirl.build(:employer_profile) }
  let(:valid_params) do
    {
      effective_on: Date.current,
      employer_profile: employer_profile,
      last_premium_paid_on: Date.current - 25.days,
      last_premium_amount: 2345.07,
      next_premium_due_on: Date.current + 5.days,
      next_premium_amount: 3155.86
    }
  end

  context ".new" do
    context "with only 'effective on' parameter" do
      let(:params) {{effective_on: Date.current}}

      it "should raise" do
        expect{PremiumStatement.create!(**params)}.to raise_error(Mongoid::Errors::NoParent)
      end
    end

    context "with no employer profile" do
      let(:params) {valid_params.except(:employer_profile)}

      it "should raise" do
        expect{PremiumStatement.create(**params)}.to raise_error(Mongoid::Errors::NoParent)
      end
    end

    context "with no effective on date" do
      let(:params) {valid_params.except(:effective_on)}

      it "should not save" do
        expect(PremiumStatement.create(**params).errors[:effective_on].any?).to be_truthy
      end
    end

    context "with all parameters and open enrollment is closed" do
      let(:premium_statement) {employer_profile.premium_statements.build(valid_params)}

      before do
        employer_profile.aasm_state = "binder_pending"
      end

      it "should initialize with premium binder pending state" do
        expect(premium_statement.binder_pending?).to be_truthy
      end

      it "should enable valid state transistions" do
        expect(premium_statement.may_allocate_binder_payment?).to be_truthy
        expect(premium_statement.may_cancel_coverage?).to be_truthy
      end

      it "should not enable invalid state transistions" do
        expect(premium_statement.may_reverse_coverage_period?).to be_falsey
        expect(premium_statement.may_suspend_coverage?).to be_falsey
        expect(premium_statement.may_reinstate_coverage?).to be_falsey
      end


      it "should initialize with premium binder pending state" do
        expect(premium_statement.binder_pending?).to be_truthy
      end

      it "should save" do
        expect(premium_statement.save).to be_truthy
      end

      context "and it is saved" do
        before do
          premium_statement.save
        end

        it "should be findable" do
          # expect(BrokerRole.find(broker_role.id).id.to_s).to eq broker_role.id.to_s
        end
      end
    end
  end

  context "open enrollment has closed" do
    let(:premium_statement) {employer_profile.premium_statements.build(valid_params)}

    before do
      employer_profile.aasm_state = "binder_pending"
    end

    context "for a new employer" do
      it "should be waiting to receive binder payment" do
        expect(premium_statement.binder_pending?).to be_truthy
      end

      context "doesn't pay the premium binder" do
        before do
          premium_statement.advance_billing_period
        end

        it "coverage should be canceled" do
          expect(premium_statement.aasm_state).to eq "canceled"
        end
      end

      context "pays the binder premium" do
        before do
          premium_statement.allocate_binder_payment
        end

        it "it should transition to binder paid status" do
          expect(premium_statement.binder_paid?).to be_truthy
        end

        context "and binder premium payment is reversed" do
          before do
            premium_statement.reverse_coverage_period
          end

          it "coverage should be canceled" do
            expect(premium_statement.aasm_state).to eq "canceled"
            expect(employer_profile.aasm_state).to eq "canceled"
          end          
        end
      end
    end

    context "for an enrolled employer" do
      before do
        employer_profile.aasm_state = "enrolled"
        premium_statement.aasm_state = "current"
      end

      context "and the billing period advances without a premium payment" do
        before do
          premium_statement.advance_billing_period
        end

        it "should transition to overdue status" do
          expect(premium_statement.overdue?).to be_truthy
        end

        context "and a second billing period advances without a premium payment" do
          before do
            premium_statement.advance_billing_period
          end

          it "should transition to late status" do
            expect(premium_statement.late?).to be_truthy
          end

          context "and a third billing period advances without a premium payment" do
            before do
              premium_statement.advance_billing_period
            end

            it "should transition to suspended status and set parent employer to suspended" do
              expect(premium_statement.suspended?).to be_truthy
              expect(premium_statement.employer_profile.suspended?).to be_truthy
            end

            context "and a premium in arrears is paid-in-full" do
              before do
                premium_statement.advance_coverage_period
              end

              it "should transition to current status and set parent employer to enrolled" do
                expect(premium_statement.current?).to be_truthy
                expect(premium_statement.employer_profile.enrolled?).to be_truthy
              end

              context "but the premium payment NSFs" do
                before do
                  premium_statement.reverse_coverage_period
                end

                it "should revert to suspended status" do 
                  expect(premium_statement.aasm_state).to eq "suspended"
                end

                it "and reset employer to suspended status" do
                  expect(premium_statement.employer_profile.enrolled?).to be_truthy
                end
              end
            end

            context "and a fourth (final) billing period advances without a premium payment" do
              before do
                premium_statement.advance_billing_period
              end

              it "should transition self and employer to terminated status" do
                expect(premium_statement.terminated?).to be_truthy
                expect(premium_statement.terminated?).to be_truthy
              end
            end

          end
        end
      end
    end
  end

  context "an employer who is terminated" do
  end
end
