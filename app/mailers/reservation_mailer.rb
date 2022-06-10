# frozen_string_literal: true

class ReservationMailer < ApplicationMailer
  layout "email_layout"
  def apply(reservation)
    @reservation = reservation
    @customer = @reservation.customer
    mail to: @reservation.customer.email, subject: "【Sinkawasche】予約申込の完了通知 ※ご予約はまだ確定していません"
  end

  def approval(reservation)
    @reservation = reservation
    @customer = @reservation.customer
    mail to: @reservation.customer.email, subject: "【Sinkawasche】予約確定の通知"
  end

  def cancel(reservation)
    @reservation = reservation
    @customer = @reservation.customer
    mail to: @reservation.customer.email, subject: "【Sinkawasche】予約キャンセルの通知"
  end

  def completed(reservation)
    @reservation = reservation
    @staff = reservation.staff
    @customer = @reservation.customer
    mail to: @reservation.customer.email, subject: "【Sinkawasche】作業完了のお知らせ"
  end

  def change(request_change)
    @request_change = request_change
    @reservation = request_change.reservation
    @customer = @reservation.customer
    mail to: @reservation.customer.email, subject: "【Sinkawasche】変更依頼の通知*変更またはキャンセルできない場合がございます。"
  end
end
