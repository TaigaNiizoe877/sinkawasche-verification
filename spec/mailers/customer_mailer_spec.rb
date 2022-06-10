# frozen_string_literal: true

require "rails_helper"

RSpec.describe CustomerMailer, type: :mailer do
  describe "reset_password" do
    let(:customer) { create(:customer) }
    let(:mail) { CustomerMailer.reset_password(customer) }

    it "renders the headers" do
      allow_any_instance_of(Customer).to receive(:reset_token).and_return("dummy")
      expect(mail.subject).to eq("Reset password")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end
end
