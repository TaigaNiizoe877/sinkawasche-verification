# frozen_string_literal: true

module SessionsHelper
  def log_in(customer)
    session[:customer_id] = customer.id
  end

  def current_customer
    if session[:customer_id]
      @current_customer ||= Customer.find_by(id: session[:customer_id])
    end
  end

  def current_customer?(customer)
    customer == current_customer
  end

  def logged_in?
    !current_customer.nil?
  end
end
