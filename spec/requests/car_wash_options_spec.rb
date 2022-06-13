# frozen_string_literal: true

require "rails_helper"

RSpec.describe "CarWashOptions", type: :request do
  let(:staff) { create(:staff, email: "test2@gmail.com") }
  let!(:car_size) { create(:car_size) }
  let(:car_wash_option) { create(:car_wash_option, car_size: create(:car_size)) }
  let(:reservation_car_wash_option) { create(:reservation_car_wash_option) }

  before do
    sign_in staff
  end

  describe "GET #index" do
    it "一覧にアクセスできること" do
      get car_wash_options_path
      expect(response.body).to be_include("洗車オプション一覧")
      expect(response.body).to be_include("オプション名")
      expect(response.body).to be_include("価格")
      expect(response.body).to be_include("サイズ")
    end
  end

  describe "GET #show" do
    it "詳細にアクセスできること" do
      get car_wash_option_path(car_wash_option)
      expect(response.body).to be_include("洗車オプション詳細")
    end
  end

  describe "GET #new" do
    it "新規作成にアクセスできること" do
      get new_car_wash_option_path
      expect(response.body).to be_include("洗車オプション新規作成")
    end
  end

  describe "GET #edit" do
    context "正常系" do
      example "編集にアクセスできること" do
        get edit_car_wash_option_path(car_wash_option)
        expect(response.body).to be_include("洗車オプション編集")
      end
    end

    context "異常系" do
      example "予約に紐づいているため変更できません" do
        get edit_car_wash_option_path(reservation_car_wash_option.car_wash_option)
        expect(flash[:error]).to be_include("予約に紐づいているため変更できません")
      end
    end
  end

  describe "POST #create" do
    context "正常系" do
      example "洗車オプションの新規作成が成功すること" do
        post car_wash_options_path, params: {
                                    car_wash_option: {
                                      name: "ホイール洗車",
                                      car_size_id: CarSize.all.last.id,
                                      price: 20000,
                                      required_time: 30,
                                      memo: "メモ",
                                      status: true,
                                      detail_memo: "メモ"
                                  }
          }
        expect(CarWashOption.all.last.name).to(eq("ホイール洗車"))
      end
    end

    context "異常系：コース名の入力なし" do
      example "バリデーションに引っかかりエラーになること" do
        post car_wash_options_path, params: {
                                    car_wash_option: {
                                      name: "",
                                      car_size_id: CarSize.all.last.id,
                                      price: 20000,
                                      required_time: 30,
                                      memo: "メモ",
                                      detail_memo: "メモ"
                                  }
          }
        expect(response.body).to be_include("オプション名を入力してください")
      end
    end
  end

  describe "PUT #update" do
    context "正常系" do
      example "洗車コースの更新が成功すること" do
        put car_wash_option_path(car_wash_option), params: {
                                                  car_wash_option: {
                                                    name: "test",
                                                    car_size_id: CarSize.all.last.id,
                                                    price: 20000,
                                                    required_time: 30,
                                                    memo: "メモ",
                                                    detail_memo: "メモ"
                                                }
            }
        expect(CarWashOption.find(car_wash_option.id).name).to(eq("test"))
      end
    end

    context "異常系" do
      example "バリデーションに引っかかりエラーになること" do
        put car_wash_option_path(car_wash_option), params: {
                                                  car_wash_option: {
                                                    name: "",
                                                    car_size_id: CarSize.all.last.id,
                                                    price: 20000,
                                                    required_time: 30,
                                                    memo: "メモ",
                                                    detail_memo: "メモ"
                                                }
            }
        expect(response.body).to be_include("オプション名を入力してください")
      end
    end
  end

  describe "#destroy" do
    context "正常系" do
      example "削除ができること" do
        delete car_wash_option_path(car_wash_option)
        expect(flash[:notice]).to be_include("洗車オプションを削除しました")
      end
    end

    context "異常系" do
      example "予約に紐づいているため削除できません" do
        delete car_wash_option_path(reservation_car_wash_option.car_wash_option)
        expect(flash[:error]).to be_include("予約に紐づいているため削除できません")
      end
    end
  end
end