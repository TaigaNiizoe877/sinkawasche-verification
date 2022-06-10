# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV["FROM_MAIL"]
  default bcc: ENV["BCC_MAIL"]

  layout "mailer"
end
