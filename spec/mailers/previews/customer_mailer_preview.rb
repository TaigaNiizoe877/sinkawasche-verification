# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/customer_mailer
class CustomerMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/customer_mailer/reset_password
  def reset_password
    CustomerMailer.reset_password
  end
end
