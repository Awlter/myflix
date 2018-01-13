require 'spec_helper'

describe "create payment on successful charge", :vcr do
	let(:event_data) do
		{
		  "id" => "evt_1Bj0i2FbDoFsZOtGxyOP9h6r",
		  "object" => "event",
		  "api_version" => "2017-08-15",
		  "created" => 1515656566,
		  "data" => {
		    "object" => {
		      "id" => "ch_1Bj0i1FbDoFsZOtGVU7QuhH6",
		      "object" => "charge",
		      "amount" => 999,
		      "amount_refunded" => 0,
		      "application" => nil,
		      "application_fee" => nil,
		      "balance_transaction" => "txn_1Bj0i1FbDoFsZOtGNST2KbjQ",
		      "captured" => true,
		      "created" => 1515656565,
		      "currency" => "usd",
		      "customer" => "cus_C7FCBSobKgDJmV",
		      "description" => nil,
		      "destination" => nil,
		      "dispute" => nil,
		      "failure_code" => nil,
		      "failure_message" => nil,
		      "fraud_details" => {
		      },
		      "invoice" => "in_1Bj0i1FbDoFsZOtGgz7y2LXz",
		      "livemode" => false,
		      "metadata" => {
		      },
		      "on_behalf_of" => nil,
		      "order" => nil,
		      "outcome" => {
		        "network_status" => "approved_by_network",
		        "reason" => nil,
		        "risk_level" => "normal",
		        "seller_message" => "Payment complete.",
		        "type" => "authorized"
		      },
		      "paid" => true,
		      "receipt_email" => nil,
		      "receipt_number" => nil,
		      "refunded" => false,
		      "refunds" => {
		        "object" => "list",
		        "data" => [

		        ],
		        "has_more" => false,
		        "total_count" => 0,
		        "url" => "/v1/charges/ch_1Bj0i1FbDoFsZOtGVU7QuhH6/refunds"
		      },
		      "review" => nil,
		      "shipping" => nil,
		      "source" => {
		        "id" => "card_1Bj0hyFbDoFsZOtGdblsm0Mx",
		        "object" => "card",
		        "address_city" => nil,
		        "address_country" => nil,
		        "address_line1" => nil,
		        "address_line1_check" => nil,
		        "address_line2" => nil,
		        "address_state" => nil,
		        "address_zip" => nil,
		        "address_zip_check" => nil,
		        "brand" => "Visa",
		        "country" => "US",
		        "customer" => "cus_C7FCBSobKgDJmV",
		        "cvc_check" => "pass",
		        "dynamic_last4" => nil,
		        "exp_month" => 1,
		        "exp_year" => 2019,
		        "fingerprint" => "uY88PVF5bjhLynks",
		        "funding" => "credit",
		        "last4" => "4242",
		        "metadata" => {
		        },
		        "name" => nil,
		        "tokenization_method" => nil
		      },
		      "source_transfer" => nil,
		      "statement_descriptor" => nil,
		      "status" => "succeeded",
		      "transfer_group" => nil
		    }
		  },
		  "livemode" => false,
		  "pending_webhooks" => 1,
		  "request" => {
		    "id" => "req_CHf8saT4k7wQQl",
		    "idempotency_key" => nil
		  },
		  "type" => "charge.succeeded"
		}
	end

	before do
		Fabricate(:user, customer_id: "cus_C7FCBSobKgDJmV")
		post '/stripe_events', event_data
	end

	it "creates a payment with webhook from stripe for charge succeeded" do
		expect(Payment.count).to eq(1)
	end

	it "associate the payment to user" do
		expect(Payment.first.user.customer_id).to eq("cus_C7FCBSobKgDJmV")
	end

	it "creates payments with correct key value pairs" do
		expect(Payment.first.amount).to eq(999)
		expect(Payment.first.reference_id).to eq("ch_1Bj0i1FbDoFsZOtGVU7QuhH6")
	end
end