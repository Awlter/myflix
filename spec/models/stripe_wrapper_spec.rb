require "spec_helper"

describe StripeWrapper do
  let(:token) do
    Stripe::Token.create(
      :card => {
      :number => card_number,
      :exp_month => 12,
      :exp_year => 2018,
      :cvc => "314"
    }).id
  end

  describe StripeWrapper::Charge do
    describe ".create" do
      let(:charge) { StripeWrapper::Charge.create(amount: 999, card: token) }

      context "with valid input", :vcr do
        let(:card_number) { "4242424242424242" }

        it "creates a new charge successfully" do
          expect(charge.response.amount).to eq 999
          expect(charge.response.currency).to eq 'usd'
        end

        it "charges card successfully" do
          expect(charge).to be_successful
        end
      end

      context "with invalid input", :vcr do
        let(:card_number) { "4000000000000002" }

        it "charges card unsuccessfully" do
          expect(charge).to_not be_successful
        end
        it "sets the error message" do
          expect(charge.error_message).to eq('Your card was declined.')
        end
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create" do
      let(:email) { Faker::Internet.email }
      let(:customer) {StripeWrapper::Customer.create(card: token, email: email)}

      context "with valid card", :vcr do
        let(:card_number) { "4242424242424242" }
        it "creates a new costumer successfully" do
          expect(customer).to be_successful
        end

        it "returns customer id" do
          expect(customer.token).to be_present
        end
      end

      context "with invalid card", :vcr do
        let(:card_number) { "4000000000000002" }
        it "fails to create a new customer" do
          expect(customer).to_not be_successful
        end
        it "sets the error message" do
          expect(customer.error_message).to eq('Your card was declined.')
        end
      end
    end
  end
end
