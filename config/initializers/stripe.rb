Stripe.api_key = ENV['STRIPE_SECRET_KEY']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    event.class       #=> Stripe::Event
    event.type        #=> "charge.failed"
    event.data.object
  end
end