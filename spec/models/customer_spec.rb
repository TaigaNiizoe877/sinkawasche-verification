# frozen_string_literal: true

require "rails_helper"

RSpec.describe Customer, type: :model, vcr: true do
  let(:customer) { build(:customer) }
  let(:reservation) { create(:reservation) }

  it { should have_many(:working_locations) }
  it { should have_many(:reservations) }
  it { is_expected.to validate_presence_of(:family_name) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:family_name_kana) }
  it { is_expected.to validate_presence_of(:name_kana) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:prefecture) }
  it { is_expected.to validate_presence_of(:address_first) }
  it { is_expected.to validate_presence_of(:address_second) }
  it { is_expected.to validate_presence_of(:aware_route) }
  it { is_expected.to validate_presence_of(:latitude) }
  it { is_expected.to validate_presence_of(:longitude) }
  it { is_expected.to validate_presence_of(:phone) }
  it { is_expected.to validate_presence_of(:postal_code) }
  it { is_expected.to validate_presence_of(:longitude) }
  it { is_expected.to validate_presence_of(:longitude) }
  it { is_expected.to validate_presence_of(:longitude) }
  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }

  it { expect(customer.create_reset_digest).to eq(true) }
  it {
    customer.create_reset_digest
    expect(customer.send_password_reset_email.class).to eql(Mail::Message)
  }
  it {
    customer.create_reset_digest
    expect(customer.send_welcome_email.class).to eql(Mail::Message)
  }
  it {
    customer.create_reset_digest
    expect(customer.authenticated?(customer.reset_token)).to eq(true)
  }
  it { expect(customer.full_name).to eq("#{customer.family_name} #{customer.name}") }
  it { expect(customer.full_name_kana).to eq("#{customer.family_name_kana} #{customer.name_kana}") }
  it { expect(customer.full_address).to eq("#{customer.prefecture} #{customer.address_first} #{customer.address_second} #{customer.building}") }

  it { expect { customer.creation_working_location }.to change { customer.working_locations.count }.by(1) }

  describe "#validate_to_have_reservation" do
    context "予約と紐づいていない場合" do
      it "削除可否の検証がエラーが発生しないこと" do
        expect(customer.discarded_at).to eq(nil)
        customer.check_have_reservation
        customer.errors.blank? && customer.discard
        expect(customer.discarded_at).not_to eq(nil)
      end
    end

    context "予約と紐づいている場合", vcr: true do
      it "削除可否の検証がエラーが発生すること" do
        invalid_customer = reservation.customer
        expect(invalid_customer.discarded_at).to eq(nil)
        invalid_customer.check_have_reservation
        invalid_customer.errors.blank? && invalid_customer.discard
        expect(invalid_customer.discarded_at).to eq(nil)
      end
    end
  end

  describe "when: phone_number_check" do
    context "正常な電話番号の場合" do
      it "is valid" do
        expect(customer).to be_valid
      end
    end

    context "-が入った電話番号の場合" do
      it "is invalid" do
        customer.phone = "090-0000-0000"

        expect(customer).to be_invalid
        expect(customer.errors[:phone].first).to include("-(ハイフン)は入れないでください")
      end
    end

    context "12桁以上の電話番号の場合" do
      it "is invalid" do
        customer.phone = "0900000000000000000"

        expect(customer).to be_invalid
        expect(customer.errors[:phone].first).to include("10または11桁にしてください")
      end
    end
  end
end
