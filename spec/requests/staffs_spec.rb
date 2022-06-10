# require "rails_helper"

# RSpec.describe "Staffs", type: :request do
#   describe "GET /show" do
#     it "returns http success" do
#       get "/staffs/show"
#       expect(response).to have_http_status(:success)
#     end
#   end
# end

# frozen_string_literal: true

require "rails_helper"

RSpec.describe "CarWashMenus", type: :request do
  let(:staff) { create(:staff, email: "test2@gmail.com") }
  let!(:car_size) { create(:car_size) }
  let(:car_wash_menu) { create(:car_wash_menu, car_size: create(:car_size)) }
  let(:reservation) { create(:reservation) }

  before do
    sign_in staff
  end

  describe "GET #index" do
    it "一覧にアクセスできること" do
      get staffs_path
      expect(response.body).to be_include("スタッフ一覧")
      expect(response.body).to be_include("名前")
      expect(response.body).to be_include("電話番号")
      expect(response.body).to be_include("役割")
    end
  end

  describe "GET #show" do
    it "詳細にアクセスできること" do
      get staff_path(staff)
      expect(response.body).to be_include("スタッフ詳細")
    end
  end

  describe "GET #new" do
    it "一覧にアクセスできること" do
      get new_staff_path
      expect(response.body).to be_include("スタッフ新規作成")
    end
  end

  describe "GET #edit" do
    context "正常系" do
      example "編集にアクセスできること" do
        get edit_staff_path(staff)
        expect(response.body).to be_include("スタッフ編集")
      end
    end
  end

  describe "POST #create" do
    context "正常系" do
      example "スタッフの新規作成が成功すること" do
        post create_account_staffs_path, params: {
                                    staff: {
                                      family_name: "テスト",
                                      name: "ハナコ",
                                      email: "test1@gmail.com",
                                      password: "test1@gmail.com",
                                      password_confirmation: "test1@gmail.com",
                                      role: "admin"
                                  }
          }
        expect(Staff.all.last.name).to(eq("ハナコ"))
      end
    end

    context "異常系：コース名の入力なし" do
      example "バリデーションに引っかかりエラーになること" do
        post create_account_staffs_path, params: {
                                              staff: {
                                                family_name: "",
                                                name: "ハナコ",
                                                email: "test1@gmail.com",
                                                password: "test1@gmail.com",
                                                password_confirmation: "test1@gmail.com",
                                                role: "admin"
                                            }
                                    }
        expect(response.body).to be_include("苗字を入力してください")
      end
    end
  end

  describe "PUT #update" do
    context "正常系" do
      example "スタッフの更新が成功すること" do
        put staff_path(staff), params: {
                                    staff: {
                                      family_name: "test",
                                      name: "ハナコ",
                                      email: "test1@gmail.com",
                                      password: "test1@gmail.com",
                                      password_confirmation: "test1@gmail.com",
                                      role: "admin",
                                      phone: "08011112222",
                                      gender: "male",
                                      postal_code: "0801111"
                                  }
                                }
        expect(Staff.find(staff.id).family_name).to(eq("test"))
      end

      example "パスワード入力がなくても、スタッフの更新が成功すること" do
        put staff_path(staff), params: {
                                    staff: {
                                      family_name: "test",
                                      name: "ハナコ",
                                      email: "test1@gmail.com",
                                      password: "",
                                      password_confirmation: "",
                                      role: "admin",
                                      phone: "08011112222",
                                      gender: "male",
                                      postal_code: "0801111"
                                  }
                                }
        expect(Staff.find(staff.id).family_name).to(eq("test"))
      end
    end

    context "異常系" do
      example "バリデーションに引っかかりエラーになること" do
        put staff_path(staff), params: {
                                    staff: {
                                      family_name: "",
                                      name: "ハナコ",
                                      email: "test1@gmail.com",
                                      password: "test1@gmail.com",
                                      password_confirmation: "test1@gmail.com",
                                      role: "admin"
                                  }
                                }
        expect(response.body).to be_include("苗字を入力してください")
      end
    end
  end

  describe "#destroy" do
    context "正常系" do
      example "削除ができること" do
        delete staff_path(staff)
        expect(flash[:notice]).to be_include("スタッフを削除しました")
      end
    end

    context "異常系" do
      example "バリデーションに引っかかりエラーになること" do
        delete staff_path(reservation.staff)
        expect(flash[:error]).to be_include("予約に紐づいているためスタッフを削除できません")
      end
    end
  end
end
