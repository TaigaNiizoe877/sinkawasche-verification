# frozen_string_literal: true

class Staffs::PasswordsController < Devise::PasswordsController
  layout "devise_form"
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      redirect_to new_staff_password_path, data: { turbo: false }
    else
      flash[:error] = resource.errors.full_messages.join(",")
      redirect_to new_staff_password_path, data: { turbo: false }
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?
    if resource.errors.empty?
      if Devise.sign_in_after_reset_password
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message!(:notice, flash_message)
        resource.after_database_authentication
        sign_in(resource_name, resource)
      else
        set_flash_message!(:notice, :updated_not_active)
      end
      redirect_to "/", data: { turbo: false }
    else
      flash[:error] = resource.errors.full_messages.join(",")
      redirect_to edit_staff_password_path(reset_password_token: params[:staff][:reset_password_token]), data: { turbo: false }
    end
  end

  # protected

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
