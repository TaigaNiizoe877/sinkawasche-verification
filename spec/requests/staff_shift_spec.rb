# frozen_string_literal: true

require "rails_helper"

RSpec.describe "StaffShifts", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/staff_shift/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/staff_shift/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/staff_shift/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/staff_shift/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/staff_shift/update"
      expect(response).to have_http_status(:success)
    end
  end
end
