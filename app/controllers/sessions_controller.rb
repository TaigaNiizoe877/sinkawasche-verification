# frozen_string_literal: true

class SessionsController < ApplicationController
  layout "customer_form"
  before_action :get_customer,   only: [:new_password, :reset_password]
  before_action :valid_customer, only: [:new_password]

  def login
    customer = Customer.find_by(email: params[:email].downcase)
    if customer && customer.authenticate(params[:password])
      log_in customer
      redirect_to forms_select_menu_path
    else
      flash[:error] = "メールアドレスかパスワードが間違っています。"
      redirect_to forms_top_url
    end
  end

  def send_reset_password_email
    @customer = Customer.find_by(email: params[:email].downcase)
    if !!@customer
      @customer.create_reset_digest
      @customer.send_password_reset_email
      flash[:notice] = "再設定メールを送信しました"
      redirect_to "/forgot_password"
    else
      flash[:error] = "入力されたEメールは登録されていません。"
      redirect_to "/forgot_password"
    end
  end

  def forgot_password
  end

  def new_password
  end

  def reset_password
    if @customer.update(customer_params)
      flash[:success] = "パスワードを変更しました。"
    else
      flash[:error] = "パスワードの変更に失敗しました。もう一度やり直してください。"
    end
    redirect_to forms_top_url
  end

  private
    def get_customer
      @customer = Customer.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する
    def valid_customer
      # 30分以内に処理しなければ、遷移不可
      unless @customer && @customer.reset_sent_at < Time.now + 30.minutes && @customer.authenticated?(params[:token])
        flash[:error] = "不正な遷移です。もう一度やり直してください"
        redirect_to forms_top_url
      end
    end

    def customer_params
      {
        password: params[:reset_password],
        reset_digest: nil,
        reset_token: nil
      }
    end
end
