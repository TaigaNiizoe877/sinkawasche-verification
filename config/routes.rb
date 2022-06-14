# frozen_string_literal: true

Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  post "/login", to: "sessions#login"
  # 打鍵して不要であれば削除
  # post "/request_change_login", to: "sessions#request_change_login"

  get "/forgot_password", to: "sessions#forgot_password"
  post "/send_reset_password_email", to: "sessions#send_reset_password_email"
  get "/:token/new_password", to: "sessions#new_password", as: "new_password"
  post "/reset_password", to: "sessions#reset_password"

  # キャンセル依頼トップ
  get "/forms/request_change_top", to: "forms#request_change_top"
  # キャンセル依頼ログイン
  post "/forms/request_change_login", to: "forms#request_change_login"
  # キャンセル依頼コンタクト送信フォーム
  get "/forms/request_change_contact", to: "forms#request_change_contact"
  # キャンセル依頼POST
  post "/forms/creation_request_change", to: "forms#creation_request_change"


  get "/forms/top", to: "forms#top"
  get "/forms/select_working_location", to: "forms#select_working_location"
  post "/forms/register_working_location", to: "forms#register_working_location"
  post "/forms/destroy_working_location", to: "forms#destroy_working_location"
  get "/forms/select_menu", to: "forms#select_menu"
  get "/forms/select_day", to: "forms#select_day"
  get "/forms/select_time", to: "forms#select_time"
  get "/forms/input_info", to: "forms#input_info"
  get "/forms/confirm", to: "forms#confirm"
  get "/forms/success", to: "forms#success"
  get "/forms/help", to: "forms#help"
  post "/forms/apply_reservation", to: "forms#apply_reservation"
  get "/", to: "reservations#index"
  devise_for :staffs, controllers: {
    sessions: "staffs/sessions",
    registrations: "staffs/registrations",
    passwords: "staffs/passwords"
  }
  devise_scope :staff do
    get "/staffs/sign_out" => "devise/sessions#destroy"
  end

  resources :staffs do
    post "create_account", on: :collection
  end
  resources :travel_fees
  resources :car_wash_menus do
    get "copy", on: :member
  end
  resources :car_wash_options do
    get "copy", on: :member
    get :search, on: :collection
  end
  resources :reservations do
    post "/send_email", to: "reservations#send_email", on: :member
    get "/request_read", to: "reservations#request_read", on: :member
  end
  resources :customers
  resources :working_locations
  resources :staff_shifts do
    get "/", to: "staff_shifts#calendar", on: :collection
    get "/staff_calendar", to: "staff_shifts#staff_calendar", on: :collection
    get "/bulk_input", to: "staff_shifts#bulk_input", on: :collection
    get "/bulk_chenge_input", to: "staff_shifts#bulk_chenge_input", on: :collection
    post "/bulk_register", to: "staff_shifts#bulk_register", on: :collection
  end

  namespace :api do
    get "staff_shift_model_list", to: "staff_shifts#staff_shift_model_list"
    get "car_size_list", to: "select_menus#car_size_list"
    get "car_maker_list", to: "select_menus#car_maker_list"
    get "car_model_list", to: "select_menus#car_model_list"
    get "menu_and_option_list", to: "select_menus#menu_and_option_list"
    get "working_location", to: "select_menus#working_location"
    get "assignable_staff_list", to: "select_menus#assignable_staff_list"
  end
end
