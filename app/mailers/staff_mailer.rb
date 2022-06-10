# frozen_string_literal: true

class StaffMailer < ApplicationMailer
  def welcome(staff) # メソッドに対して引数を設定
    @staff = staff
    mail to: @staff.email, subject: "【Sinkawasche】新規作成されました"
  end
end
