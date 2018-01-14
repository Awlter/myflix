Stripe.api_key = ENV['STRIPE_SECRET_KEY']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    event_object = event.data.object
    user = User.find_by(customer_id: event_object.customer)
    Payment.create(user: user, amount: event_object.amount, reference_id: event_object.id)
  end

  events.subscribe 'charge.fail' do |event|
    event_object = event.data.object
    user = User.find_by(customer_id: event_object.customer)
    user.deactivate!
  end
end
