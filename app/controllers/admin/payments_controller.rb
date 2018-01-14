class Admin::PaymentsController < AdminsController
  before_action :require_user

  def index
    @payments = Payment.all
  end
end