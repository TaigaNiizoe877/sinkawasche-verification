# frozen_string_literal: true

class CustomerMailer < ApplicationMailer
  layout "email_layout"
  def reset_password(customer) # メソッドに対して引数を設定
    @customer = customer
    @path = new_password_url(@customer.reset_token, email: @customer.email)
    mail to: customer.email, subject: "【Sinkawasche】パスワード再設定メール"
  end

  def welcome(customer)
    @customer = customer
    @path = new_password_url(@customer.reset_token, email: @customer.email)
    mail to: customer.email, subject: "【Sinkawasche】会員登録のご確認"
  end
end
