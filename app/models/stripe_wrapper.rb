module StripeWrapper
  class Charge
    attr_reader :response, :status
    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options={})
      response = Stripe::Charge.create(
        amount: options[:amount],
        currency: 'usd',
        source: options[:card]
      )
      new(response, :success)
    rescue Stripe::CardError => e
      new(e, :error)
    end

    def successful?
      status == :success
    end

    def error_message
      response.message
    end
  end

  class Customer
    attr_reader :response, :status
    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options={})
      response = Stripe::Customer.create(
        plan: 'base',
        email: options[:email],
        card: options[:card]
      )
      new(response, :success)
    rescue Stripe::CardError => e
      new(e, :error)
    end

    def token
      response.id
    end

    def error_message
      response.message
    end

    def successful?
      status == :success
    end
  end 
end
