# frozen_string_literal: true

require "rails_helper"

RSpec.describe FormsController, type: :request do
  describe "GET #select_menus" do
    it "一覧にアクセスできること" do
      get forms_select_menu_url
      expect(response.status).to eq 200
      expect(response.body).to be_include("車情報・メニュー選択")
    end
  end
end
