require 'spec_helper'

describe "deactivate user on failed payment", :vcr do
  let(:event_data) do
    {
      "id" => "evt_1BjmwTFbDoFsZOtGlEv3OhTK",
      "object" => "event",
      "api_version" => "2017-08-15",
      "created" => 1515841973,
      "data" => {
        "object" => {
          "id" => "ch_1BjmwTFbDoFsZOtGBkONdiNJ",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application" => nil,
          "application_fee" => nil,
          "balance_transaction" => nil,
          "captured" => false,
          "created" => 1515841973,
          "currency" => "usd",
          "customer" => "cus_C7uorJYm6Jm7VI",
          "description" => "",
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => "card_declined",
          "failure_message" => "Your card was declined.",
          "fraud_details" => {
          },
          "invoice" => nil,
          "livemode" => false,
          "metadata" => {
          },
          "on_behalf_of" => nil,
          "order" => nil,
          "outcome" => {
            "network_status" => "declined_by_network",
            "reason" => "generic_decline",
            "risk_level" => "normal",
            "seller_message" => "The bank did not return any further details with this decline.",
            "type" => "issuer_declined"
          },
          "paid" => false,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [
            ],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_1BjmwTFbDoFsZOtGBkONdiNJ/refunds"
          },
          "review" => nil,
          "shipping" => nil,
          "source" => {
            "id" => "card_1BjmWJFbDoFsZOtGsw40sXp7",
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
            "customer" => "cus_C7uorJYm6Jm7VI",
            "cvc_check" => nil,
            "dynamic_last4" => nil,
            "exp_month" => 11,
            "exp_year" => 2055,
            "fingerprint" => "b50oaaDDqq8f3Ffw",
            "funding" => "credit",
            "last4" => "0341",
            "metadata" => {
            },
            "name" => nil,
            "tokenization_method" => nil
          },
          "source_transfer" => nil,
          "statement_descriptor" => nil,
          "status" => "failed",
          "transfer_group" => nil
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => {
        "id" => "req_wEb1dHsaPoC6Xf",
        "idempotency_key" => nil
      },
      "type" => "charge.failed"
    }
  end

  it "set the active status of a user to false" do
    user = Fabricate(:user, customer_id: "cus_C7uorJYm6Jm7VI")
    post '/stripe_events', event_data
    expect(user.reload.active).to be_false
  end
end