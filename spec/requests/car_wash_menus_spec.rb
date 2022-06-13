# frozen_string_literal: true

require "rails_helper"

RSpec.describe "CarWashMenus", type: :request, vcr: true do
  let(:staff) { create(:staff, role: 'staff', email: "tset2@gmail.com") }
  let(:admin_staff) { create(:staff, role: 'admin', email: "tset2@gmail.com") }
  let(:car_size) { create(:car_size) }
  let(:car_wash_menu) { create(:car_wash_menu, car_size: create(:car_size)) }

  describe "GET #index" do
    context "admin権限の場合" do
      it "一覧にアクセスできること" do
        sign_in admin_staff
        get car_wash_menus_path
        expect(response.body).to be_include("洗車コース一覧")
        expect(response.body).to be_include("コース名")
        expect(response.body).to be_include("価格")
        expect(response.body).to be_include("サイズ")
      end
    end

    context "staff権限の場合" do
      it "一覧にアクセスできないこと" do
        sign_in staff
        get car_wash_menus_path
        expect(response.body).not_to be_include("洗車コース一覧")
        expect(flash[:error]).to be_include("閲覧権限がありません。")
      end
    end

    context "ログインしていない場合" do
      it "一覧にアクセスできないこと" do
        get car_wash_menus_path
        expect(response.body).not_to be_include("洗車コース一覧")
        expect(flash[:alert]).to be_include("ログインもしくはアカウント登録してください。")
      end
    end
  end

  describe "GET #show" do
    context "admin権限の場合" do
      it "詳細にアクセスできること" do
        sign_in admin_staff
        get car_wash_menu_path(car_wash_menu)
        expect(response.body).to be_include("洗車コース詳細")
      end
    end

    context "staff権限の場合" do
      it "詳細にアクセスできること" do
        sign_in staff
        get car_wash_menu_path(car_wash_menu)
        expect(response.body).not_to be_include("洗車コース詳細")
        expect(flash[:error]).to be_include("閲覧権限がありません。")
      end
    end

    context "ログインしていない場合" do
      it "詳細にアクセスできること" do
        get car_wash_menu_path(car_wash_menu)
        expect(response.body).not_to be_include("洗車コース詳細")
        expect(flash[:alert]).to be_include("ログインもしくはアカウント登録してください。")
      end
    end
  end

  describe "GET #new" do
    context "admin権限の場合" do
      it "newにアクセスできること" do
        sign_in admin_staff
        get new_car_wash_menu_path
        expect(response.body).to be_include("洗車コース新規作成")
      end
    end

    context "staff権限の場合" do
      it "newにアクセスできないこと" do
        sign_in staff
        get new_car_wash_menu_path
        expect(response.body).not_to be_include("洗車コース新規作成")
        expect(flash[:error]).to be_include("閲覧権限がありません。")
      end
    end

    context "ログインしていない場合" do
      it "newにアクセスできないこと" do
        get new_car_wash_menu_path
        expect(response.body).not_to be_include("洗車コース新規作成")
        expect(flash[:alert]).to be_include("ログインもしくはアカウント登録してください。")
      end
    end
  end

  describe "GET #copy" do
    context "admin権限の場合" do
      it "copyにアクセスできること" do
        sign_in admin_staff
        get copy_car_wash_menu_path(car_wash_menu)
        expect(response.body).to be_include("洗車コース新規作成")
      end
    end

    context "staff権限の場合" do
      it "copyにアクセスできないこと" do
        sign_in staff
        get copy_car_wash_menu_path(car_wash_menu)
        expect(response.body).not_to be_include("洗車コース新規作成")
        expect(flash[:error]).to be_include("閲覧権限がありません。")
      end
    end

    context "ログインしていない場合" do
      it "copyにアクセスできないこと" do
        get copy_car_wash_menu_path(car_wash_menu)
        expect(response.body).not_to be_include("洗車コース新規作成")
        expect(flash[:alert]).to be_include("ログインもしくはアカウント登録してください。")
      end
    end
  end

  describe "GET #edit" do
    context "admin権限の場合" do
      it "編集にアクセスできること" do
        sign_in admin_staff
        get edit_car_wash_menu_path(car_wash_menu)
        expect(response.body).to be_include("洗車コース編集")
      end
    end

    context "staff権限の場合" do
      it "編集にアクセスできること" do
        sign_in staff
        get edit_car_wash_menu_path(car_wash_menu)
        expect(response.body).not_to be_include("洗車コース編集")
        expect(flash[:error]).to be_include("閲覧権限がありません。")
      end
    end

    context "ログインしていない場合" do
      it "編集にアクセスできること" do
        get edit_car_wash_menu_path(car_wash_menu)
        expect(response.body).not_to be_include("洗車コース編集")
        expect(flash[:alert]).to be_include("ログインもしくはアカウント登録してください。")
      end
    end
  end

  describe "POST #create" do
    context "admin権限の場合" do
      it "正常データが作成できること" do
        expect {
          sign_in admin_staff
          post car_wash_menus_path, params: {
                                      car_wash_menu: {
                                        name: "洗車プレミアムコース",
                                        car_size_id: car_size.id,
                                        price: 20000,
                                        required_time: 30,
                                        memo: "メモ",
                                        recommend: true,
                                        status: true,
                                        detail_memo: "メモ"
                                      }
          }
        }.to change {CarWashMenu.count}.by(1)
      end

      it "不正データが作成できないこと" do
        expect {
          sign_in admin_staff
          post car_wash_menus_path, params: {
                                      car_wash_menu: {
                                        name: "",
                                        car_size_id: car_size.id,
                                        price: 20000,
                                        required_time: 30,
                                        memo: "メモ",
                                        recommend: true,
                                        status: true,
                                        detail_memo: "メモ"
                                    }
          }
        }.to change {CarWashMenu.count}.by(0)
        expect(response.body).to be_include("コース名を入力してください")
      end
    end

    context "staff権限の場合" do
      it "データが作成できないこと" do
        expect{
          sign_in staff
          post car_wash_menus_path, params: {
                                      car_wash_menu: {
                                        name: "洗車プレミアムコース",
                                        car_size_id: car_size.id,
                                        price: 20000,
                                        required_time: 30,
                                        memo: "メモ",
                                        recommend: true,
                                        status: true,
                                        detail_memo: "メモ"
                                      }
          }
        }.to change {CarWashMenu.count}.by(0)
        expect(flash[:error]).to be_include("閲覧権限がありません。")
      end
    end

    context "ログインしていない場合" do
      it "データが作成できないこと" do
        expect{
          post car_wash_menus_path, params: {
                                      car_wash_menu: {
                                        name: "洗車プレミアムコース",
                                        car_size_id: car_size.id,
                                        price: 20000,
                                        required_time: 30,
                                        memo: "メモ",
                                        recommend: true,
                                        status: true,
                                        detail_memo: "メモ"
                                      }
                                    }
        }.to change {CarWashMenu.count}.by(0)
        expect(flash[:alert]).to be_include("ログインもしくはアカウント登録してください。")
      end
    end
  end

  describe "PUT #update" do
    context "admin権限の場合" do
      it "正常データが作成できること" do
        car_wash_menu
        expect {
          sign_in admin_staff
          put car_wash_menu_path(car_wash_menu), params: {
                                      car_wash_menu: {
                                        name: "new car_wash_menu",
                                        car_size_id: car_size.id,
                                        price: 20000,
                                        required_time: 30,
                                        memo: "メモ",
                                        recommend: true,
                                        status: true,
                                        detail_memo: "メモ"
                                      }
          }
        }.to change {car_wash_menu.reload.name}.from(car_wash_menu.name).to("new car_wash_menu")
      end

      it "不正データが作成できないこと" do
        car_wash_menu
        sign_in admin_staff
        put car_wash_menu_path(car_wash_menu), params: {
                                      car_wash_menu: {
                                        name: "",
                                        car_size_id: car_size.id,
                                        price: 20000,
                                        required_time: 30,
                                        memo: "メモ",
                                        recommend: true,
                                        status: true,
                                        detail_memo: "メモ"
                                      }}
        expect(car_wash_menu.reload.name).not_to eql("")
        expect(response.body).to be_include("コース名を入力してください")
      end
    end

    context "staff権限の場合" do
      it "データが作成できないこと" do
        car_wash_menu
        sign_in staff
        put car_wash_menu_path(car_wash_menu), params: {
                                      car_wash_menu: {
                                        name: "new car_wash_menu",
                                        car_size_id: car_size.id,
                                        price: 20000,
                                        required_time: 30,
                                        memo: "メモ",
                                        recommend: true,
                                        status: true,
                                        detail_memo: "メモ"
                                        }}
        expect(car_wash_menu.reload.name).not_to eql("new car_wash_menu")
        expect(flash[:error]).to be_include("閲覧権限がありません。")
      end
    end

    context "ログインしていない場合" do
      it "データが作成できないこと" do
        car_wash_menu
        put car_wash_menu_path(car_wash_menu), params: {
                                    car_wash_menu: {
                                      name: "洗車プレミアムコース",
                                      car_size_id: car_size.id,
                                      price: 20000,
                                      required_time: 30,
                                      memo: "メモ",
                                      recommend: true,
                                      status: true,
                                      detail_memo: "メモ"
                                    }}
        expect(car_wash_menu.reload.name).not_to eql("new car_wash_menu")
        expect(flash[:alert]).to be_include("ログインもしくはアカウント登録してください。")
      end
    end
  end

  describe "#destroy" do
    context "admin権限の場合" do
      it "予約に紐づいたいない時、削除できること" do
        sign_in admin_staff
        delete car_wash_menu_path(car_wash_menu)
        expect(flash[:notice]).to be_include("洗車コースを削除しました")
      end

      it "予約に紐づく時、削除できるないこと" do
        sign_in admin_staff
        customer = create(:customer)
        staff_1 = create(:staff, role: "staff", family_name: '田中', name: '武', email: 'staff_1@gmail.com')
        StaffShift.create(
          staff: staff_1,
          start_at: Time.parse(Time.current.to_date.to_s + " 9:00 JST"),
          end_at: Time.parse(Time.current.to_date.to_s + " 17:00 JST")
        )
        menu = create(:car_wash_menu)
        car_size = menu.car_size
        option = create(:car_wash_option, car_size: car_size)
        reservation = build(:reservation, start_at: Time.parse(Time.current.to_date.to_s + " 9:00 JST"), customer: customer, staff: staff_1)
        reservation.assign_attributes(
          reservation_infos_attributes: [
            {car_wash_menu: menu, car_model_name: "カローラ", car_size: car_size, car_wash_options: [option]}
          ]
        )
        reservation.save
        delete car_wash_menu_path(menu)
        expect(flash[:errors].first).to be_include("洗車コースを削除できませんでした")
        expect(flash[:errors].second).to be_include("予約に紐づいているため、削除できません")
      end
    end

    context "staff権限の場合" do
      it "削除できないこと" do
        sign_in staff
        delete car_wash_menu_path(car_wash_menu)
        expect(flash[:error]).to be_include("閲覧権限がありません。")
      end
    end

    context "ログインしていない場合" do
      it "削除できないこと" do
        delete car_wash_menu_path(car_wash_menu)
        expect(flash[:alert]).to be_include("ログインもしくはアカウント登録してください。")
      end
    end
  end
end
