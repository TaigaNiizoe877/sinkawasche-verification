# frozen_string_literal: true

#
class ApplicationController < ActionController::Base
  include SessionsHelper
  include FormsHelper

  before_action :authenticate_staff!, if: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  def authenticate_role_admin!
    return if current_staff&.admin?
    redirect_to reservations_path, flash: { error: "閲覧権限がありません。" }
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [
        :name,
        :gendar,
        :birthdate,
        :postal_code,
        :prefecture,
        :address,
        :hobby,
        :memo,
        :role
        ])
    end

  private
    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        redirect_to login_url
      end
    end
end
