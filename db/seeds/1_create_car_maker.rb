# frozen_string_literal: true

# 存在している場合全て削除
CarModel.delete_all
CarMaker.delete_all

# トヨタ
toyota = CarMaker.new(name: "トヨタ")
toyota.car_models.build(
  [
    { name: "iQ" },
    { name: "アイシス" },
    { name: "アクア" },
    { name: "アルファード" },
    { name: "ヴァンガード" },
    { name: "ウィッシュ" },
    { name: "ヴィッツ" },
    { name: "ヴェルファイア" },
    { name: "ヴォクシー" },
    { name: "エスクァイア" },
    { name: "エスティマ" },
    { name: "FJクルーザー" },
    { name: "オーリス" },
    { name: "カローラ" },
    { name: "カローラツーリング" },
    { name: "カローラアクシオ" },
    { name: "カローラクロス" },
    { name: "カローラスポーツ" },
    { name: "カローラフィールダー" },
    { name: "カローラルミオン" },
    { name: "クラウン" },
    { name: "グランエース" },
    { name: "ハイラックスサーフ" },
    { name: "SAI" },
    { name: "サクシード" },
    { name: "C-HR" },
    { name: "シエンタ" },
    { name: "スープラ" },
    { name: "スペイド" },
    { name: "セリカ" },
    { name: "セルシオ" },
    { name: "ソアラ" },
    { name: "タウンエースバン" },
    { name: "タンク" },
    { name: "ノア" },
    { name: "ハイエース" },
    { name: "ハイラックス" },
    { name: "ハイラックスサーフ" },
    { name: "86" },
    { name: "パッソ" },
    { name: "ハリアー" },
    { name: "bB" },
    { name: "ピクシスエポック" },
    { name: "ピクシススペース" },
    { name: "ピクシスバン" },
    { name: "ピクシスメガ" },
    { name: "プリウス" },
    { name: "プリウスα" },
    { name: "プレミオ" },
    { name: "プロボックス" },
    { name: "ヴェルファイア" },
    { name: "ヴォクシー" },
    { name: "マークX" },
    { name: "マークXジオ" },
    { name: "MIRAI" },
    { name: "ヤリス" },
    { name: "ヤリスクロス" },
    { name: "ライズ" },
    { name: "ラクティス" },
    { name: "ラッシュ" },
    { name: "RAV4" },
    { name: "ランドクルーザー" },
    { name: "ランドクルーザープラド" },
    { name: "ルーミー" },
  ]
)
toyota.save!

# ホンダ
honda = CarMaker.new(name: "ホンダ")
honda.car_models.build(
  [
    { name: "アクティバン" },
    { name: "アコード" },
    { name: "インサイト" },
    { name: "インテグラ" },
    { name: "ヴェゼル" },
    { name: "S660" },
    { name: "S2000" },
    { name: "NSX" },
    { name: "N-BOX" },
    { name: "N-WGN" },
    { name: "N-ONE" },
    { name: "エリシオン" },
    { name: "オデッセイ" },
    { name: "グレイス" },
    { name: "クロスロード" },
    { name: "CR-Z" },
    { name: "CR-V" },
    { name: "ジェイド" },
    { name: "シビック" },
    { name: "シャトル" },
    { name: "ステップワゴン" },
    { name: "ストリーム" },
    { name: "ゼスト" },
    { name: "ゼストスパーク" },
    { name: "バモス" },
    { name: "フィット" },
    { name: "フィットシャトル" },
    { name: "フリード" },
    { name: "フリードスパイク" },
    { name: "ライフ" },
  ]
)
honda.save!

# 日産
nissan = CarMaker.new(name: "日産")
nissan.car_models.build(
  [
    { name: "AD" },
    { name: "NV150AD" },
    { name: "NV100クリッパーバン" },
    { name: "NV100クリッパーリオ" },
    { name: "NV200バネットバン" },
    { name: "エクストレイル" },
    { name: "エルグランド" },
    { name: "オーラ" },
    { name: "オッティ" },
    { name: "キックス" },
    { name: "キャラバン" },
    { name: "キューブ" },
    { name: "クリッパーバン" },
    { name: "クリッパーリオ" },
    { name: "グロリア" },
    { name: "GT-R" },
    { name: "シーマ" },
    { name: "ジューク" },
    { name: "シルビア" },
    { name: "シルフィ" },
    { name: "スカイライン" },
    { name: "ステージア" },
    { name: "セドリック" },
    { name: "セレナ" },
    { name: "ティアナ" },
    { name: "ティーダ" },
    { name: "デイズ" },
    { name: "デイズルークス" },
    { name: "デュアリス" },
    { name: "ノート" },
    { name: "ピノ" },
    { name: "フーガ" },
    { name: "フェアレディZ" },
    { name: "マーチ" },
    { name: "ムラーノ" },
    { name: "モコ" },
    { name: "ラフェスタ" },
    { name: "リーフ" },
    { name: "ルークス" },
  ]
)
nissan.save!

# マツダ
mazda = CarMaker.new(name: "マツダ")
mazda.car_models.build(
  [
    { name: "RX-7" },
    { name: "RX-8" },
    { name: "アクセラ" },
    { name: "アクセラスポーツ" },
    { name: "アテンザスポーツ" },
    { name: "アテンザセダン" },
    { name: "アテンザワゴン" },
    { name: "AZワゴン" },
    { name: "MPV" },
    { name: "キャロル" },
    { name: "CX-3" },
    { name: "CX-5" },
    { name: "CX-7" },
    { name: "CX-8" },
    { name: "スクラム" },
    { name: "スクラムトラック" },
    { name: "スクラムワゴン" },
    { name: "デミオ" },
    { name: "ビアンテ" },
    { name: "フレア" },
    { name: "フレアクロスオーバー" },
    { name: "プレマシー" },
    { name: "ベリーサ" },
    { name: "ボンゴバン" },
    { name: "ロードスター" },
  ]
)
mazda.save!

# スズキ
suzuki = CarMaker.new(name: "スズキ")
suzuki.car_models.build(
  [
    { name: "アルト" },
    { name: "アルトラパン" },
    { name: "アルトワークス" },
    { name: "イグニス" },
    { name: "SX4 Sクロス" },
    { name: "エスクード" },
    { name: "エブリィ" },
    { name: "MRワゴン" },
    { name: "クロスビー" },
    { name: "Kei" },
    { name: "ジムニー" },
    { name: "ジムニーシエラ" },
    { name: "スイフト" },
    { name: "スイフトスポーツ" },
    { name: "スペーシア" },
    { name: "スペーシアギア" },
    { name: "セルボ" },
    { name: "ソリオ" },
    { name: "ソリオバンディット" },
    { name: "ハスラー" },
    { name: "ワゴンR" },
  ]
)
suzuki.save!

# スバル
subaru = CarMaker.new(name: "スバル")
subaru.car_models.build(
  [
    { name: "R2" },
    { name: "R1" },
    { name: "インプレッサ" },
    { name: "インプレッサG4" },
    { name: "インプレッサスポーツ" },
    { name: "XV" },
    { name: "エクシーガ" },
    { name: "サンバーディアス" },
    { name: "サンバーバン" },
    { name: "シフォン" },
    { name: "ジャスティ" },
    { name: "ステラ" },
    { name: "WRX STI" },
    { name: "WRX S4" },
    { name: "ディアスワゴン" },
    { name: "BRZ" },
    { name: "ヴィヴィオ" },
    { name: "フォレスター" },
    { name: "プレオ" },
    { name: "プレオプラス" },
    { name: "レヴォーグ" },
    { name: "レガシィB4" },
    { name: "レガシィアウトバック" },
    { name: "レガシィツーリングワゴン" },
  ]
)
subaru.save!

# ダイハツ
daihatsu = CarMaker.new(name: "ダイハツ")
daihatsu.car_models.build(
  [
    { name: "アトレーワゴン" },
    { name: "ミライース" },
    { name: "ウェイク" },
    { name: "エッセ" },
    { name: "キャスト" },
    { name: "ミラココア" },
    { name: "コペン" },
    { name: "ムーヴコンテ" },
    { name: "ミラジーノ" },
    { name: "タント" },
    { name: "タントエグゼ" },
    { name: "タフト" },
    { name: "トール" },
    { name: "ネイキッド" },
    { name: "ハイゼットカーゴ" },
    { name: "ハイゼットキャディー" },
    { name: "ハイゼットトラック" },
    { name: "ブーン" },
    { name: "ミラ" },
    { name: "ミライース" },
    { name: "ミラカスタム" },
    { name: "ミラココア" },
    { name: "ミラジーノ" },
    { name: "ミラトコット" },
    { name: "ムーヴ" },
    { name: "ムーヴキャンパス" },
    { name: "ムーヴコンテ" },
    { name: "ロッキー" },
  ]
)
daihatsu.save!

# レクサス
lexus = CarMaker.new(name: "レクサス")
lexus.car_models.build(
  [
    { name: "RX" },
    { name: "RC" },
    { name: "RC F" },
    { name: "IS" },
    { name: "IS F" },
    { name: "HS" },
    { name: "NX" },
    { name: "LS" },
    { name: "LX" },
    { name: "GS" },
    { name: "GS F" },
    { name: "CT" },
  ]
)
lexus.save!

# 三菱
mitsubishi = CarMaker.new(name: "三菱")
mitsubishi.car_models.build(
  [
    { name: "RVR" },
    { name: "アイ" },
    { name: "アイミーブ" },
    { name: "アウトランダー" },
    { name: "eKカスタム" },
    { name: "eKワゴン" },
    { name: "エクリプスクロス" },
    { name: "コルト" },
    { name: "デリカスペースギア" },
    { name: "タウンボックス" },
    { name: "タウンボックスワイド" },
    { name: "デリカD:5" },
    { name: "トッポ" },
    { name: "パジェロ" },
    { name: "パジェロミニ" },
    { name: "ミニキャブ・ムーヴ" },
    { name: "ミニキャブトラック" },
    { name: "ミニキャブバン" },
    { name: "ミラージュ" },
    { name: "ランサー" },
  ]
)
mitsubishi.save!

# メルセデス・ベンツ
bentz = CarMaker.new(name: "メルセデス・ベンツ")
bentz.car_models.build(
  [
    { name: "CLSクラス シューティングブレーク" },
    { name: "Aクラス" },
    { name: "Bクラス" },
    { name: "CLAクラス" },
    { name: "CLAクラス シューティングブレーク" },
    { name: "CLSクラス シューティングブレーク" },
    { name: "Cクラスセダン" },
    { name: "Cクラスクーペ" },
    { name: "Cクラスカブリオレ" },
    { name: "Cクラスステーションワゴン" },
    { name: "EQA" },
    { name: "EQC" },
    { name: "Eクラスセダン" },
    { name: "Eクラスクーペ" },
    { name: "Eクラスカブリオレ" },
    { name: "Eクラスオールテレイン" },
    { name: "Eクラスステーションワゴン" },
    { name: "GLA" },
    { name: "GLB" },
    { name: "GLC" },
    { name: "GLE" },
    { name: "GLK" },
    { name: "GLS" },
    { name: "GLクラス" },
    { name: "Gクラス" },
    { name: "Mクラス" },
    { name: "SL" },
    { name: "SLC" },
    { name: "SLK" },
    { name: "Sクラスセダン" },
    { name: "Sクラスクーペ" },
    { name: "Sクラスカブリオレ" },
    { name: "Vクラス" },
  ]
)
bentz.save!

# BMW
bmw = CarMaker.new(name: "BMW")
bmw.car_models.build(
  [
    { name: "1シリーズ" },
    { name: "1シリーズハッチバック" },
    { name: "2シリーズ" },
    { name: "2シリーズアクティブツアラー" },
    { name: "2シリーズグランツアラー" },
    { name: "2シリーズクーペ" },
    { name: "3シリーズ" },
    { name: "3シリーズセダン" },
    { name: "3シリーズツーリング" },
    { name: "3シリーズクーペ" },
    { name: "4シリーズ" },
    { name: "4シリーズクーペ" },
    { name: "4シリーズグランクーペ" },
    { name: "5シリーズ" },
    { name: "5シリーズセダン" },
    { name: "5シリーズツーリング" },
    { name: "6シリーズ" },
    { name: "6シリーズクーペ" },
    { name: "6シリーズグランクーペ" },
    { name: "7シリーズ" },
    { name: "7シリーズセダン" },
    { name: "8シリーズ" },
    { name: "i3" },
    { name: "i8" },
    { name: "iX3" },
    { name: "M2" },
    { name: "M3クーペ" },
    { name: "M3セダン" },
    { name: "M4" },
    { name: "M6カブリオレ" },
    { name: "M6クーペ" },
    { name: "M6グランクーペ" },
    { name: "X1" },
    { name: "X2" },
    { name: "X3" },
    { name: "X4" },
    { name: "X5" },
    { name: "X6" },
    { name: "X7" },
    { name: "Z3" },
    { name: "Z4" },
  ]
)
bmw.save!

# フォルクスワーゲン
wargen = CarMaker.new(name: "フォルクスワーゲン")
wargen.car_models.build(
  [
    { name: "アップ!" },
    { name: "アルテオン" },
    { name: "アルテオン シューティングブレーク" },
    { name: "ゴルフ" },
    { name: "ゴルフヴァリアント" },
    { name: "ゴルフGTI" },
    { name: "ゴルフR" },
    { name: "ゴルフRヴァリアント" },
    { name: "ゴルフトゥーラン" },
    { name: "ザ・ビートル" },
    { name: "シャラン" },
    { name: "ティグアン" },
    { name: "T-ロック" },
    { name: "T-クロス" },
    { name: "ニュービートル" },
    { name: "パサート" },
    { name: "パサートヴァリアント" },
    { name: "ポロ" },
    { name: "ポロGTI" },
  ]
)
wargen.save!

# アウディ
audi = CarMaker.new(name: "アウディ")
audi.car_models.build(
  [
    { name: "A1" },
    { name: "A1スポートバック" },
    { name: "A3" },
    { name: "A3スポーツバック" },
    { name: "A3セダン" },
    { name: "A4" },
    { name: "A4アバント" },
    { name: "A5スポーツバック" },
    { name: "A6" },
    { name: "A6アバント" },
    { name: "A7スポートバック" },
    { name: "A8" },
    { name: "e-トロンスポーツバック" },
    { name: "Q2" },
    { name: "Q3" },
    { name: "Q3スポーツバック" },
    { name: "Q5" },
    { name: "Q5スポーツバック" },
    { name: "Q7" },
    { name: "Q8" },
    { name: "R8" },
    { name: "RS Q3" },
    { name: "RS Q8" },
    { name: "RS3" },
    { name: "RS4" },
    { name: "RS5" },
    { name: "RS6" },
    { name: "RS7" },
    { name: "S1" },
    { name: "S3" },
    { name: "S4" },
    { name: "S5" },
    { name: "S6" },
    { name: "S7" },
    { name: "S8" },
    { name: "SQ2" },
    { name: "SQ5" },
    { name: "TTクーペ" },
  ]
)
audi.save!

# MINI
mini = CarMaker.new(name: "MINI")
mini.car_models.build(
  [
    { name: "MINI 3ドア" },
    { name: "MINI 5ドア" },
    { name: "MINI クロスオーバー" },
    { name: "MINI クラブマン" },
    { name: "MINI コンバーチブル" },
    { name: "MINI ジョンクーパーワークス" },
  ]
)
mini.save!

# ボルボ
volvo = CarMaker.new(name: "ボルボ")
volvo.car_models.build(
  [
    { name: "S40" },
    { name: "S60" },
    { name: "S70" },
    { name: "S80" },
    { name: "S90" },
    { name: "V40" },
    { name: "V50" },
    { name: "V60" },
    { name: "V70" },
    { name: "V90" },
    { name: "XC40" },
    { name: "XC60" },
    { name: "XC70" },
    { name: "XC90" },
  ]
)
volvo.save!

# プジョー
peugeot = CarMaker.new(name: "プジョー")
peugeot.car_models.build(
  [
    { name: "208" },
    { name: "308" },
    { name: "508" },
    { name: "2008" },
    { name: "3008" },
    { name: "5008" },
    { name: "e-208" },
    { name: "e-2008" },
  ]
)
peugeot.save!

# ポルシェ
porsche = CarMaker.new(name: "ポルシェ")
porsche.car_models.build(
  [
    { name: "911" },
    { name: "カイエン" },
    { name: "タイカン" },
    { name: "パナメーラ" },
    { name: "ボクスター" },
    { name: "マカン" },
  ]
)
porsche.save!

# ランドローバー
land_rover = CarMaker.new(name: "ランドローバー")
land_rover.car_models.build(
  [
    { name: "ディスカバリー" },
    { name: "ディフェンダー" },
    { name: "レンジローバーイヴォーク" },
    { name: "レンジローバーイヴェラール" },
    { name: "レンジローバースポーツ" },
  ]
)
land_rover.save!

# Jeep
jeep = CarMaker.new(name: "Jeep")
jeep.car_models.build(
  [
    { name: "ジープ・コンパス" },
    { name: "ジープ・グランドチェロキー" },
    { name: "ジープ・チェロキー" },
    { name: "ジープ・ラングラー" },
    { name: "ジープ・レネゲード" },
  ]
)
jeep.save!
