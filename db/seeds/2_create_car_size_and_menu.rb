# frozen_string_literal: true

CarSize.delete_all

sizes = [
  ["S", "全長4,1m以下の車両全般。\n軽自動車またはコンパクトカー。\n例：軽自動車全般、アクア、ヤリス、ノート、フィアット500など"],
  ["M", "全長4,2m〜5m以下で高さ1,5m以下の車両全般。\n普通車から3ナンバーのセダンなどのお車はMクラスです。\n基本的に脚立を使わずに洗車ができる高さのお車です。\n例：プリウス、クラウン、ゴルフ、Cクラスなど。"],
  ["L", "全長4,5m~5.2m以下で高さ1,6m~2.1m以下の車両全般。\n主にSUVやミニバンはLクラスとなります。\n例：セレナ、アルファード、Gクラスなど。"]
]

sizes.map do |name, memo|
  CarSize.find_or_create_by!(name: name, memo: memo)
end

# 洗車できないお車
# 高さ2.2m以上のお車。
# 高さ2.2m以上の大型車は、持ち込む脚立の大きさの問題で基本的にお断りしております。
# ただし、現地で脚立をお借りできる場合は別途ご相談を承ります。

ops = [
  ["車内おそうじ", "S", 3980, 20, nil, nil],
  ["車内おそうじ", "M", 4980, 25, nil, nil],
  ["車内おそうじ", "L", 5980, 30, nil, nil],
  ["光触媒コーティング", "S", 10000, 30, "車内を光触媒コーティングしてウィルス対策！", "ウイルス、雑菌、花粉、バクテリア、カビ、匂いなどから車内を守ります。\nすべてのシート、フロアマット、ダッシュボード、ハンドル、シフトレバー、サイドブレーキ、ドア内張、内窓、天井、トランクなど、車内すべてに吹きつけます。\n\n光触媒イオニアミストProは消毒と違って、内装の変色や匂いが残ったりすることはありません。\n抗ウイルス・抗菌効果は半年以上発揮し続けます。\n吹きつけた箇所が抗菌仕様になるだけでなく、臭いの原因である雑菌も分解します。\nまた、空気中の有機物質も分解して空気清浄効果も発揮します。\n専用の噴霧器とエアーコンプレッサーで吹きつけて\n超微粒子の酸化チタン粒子を定着させます。\n長期間にわたって酸化反応し、\n・抗ウイルス\n・防菌\n・防臭\n・防汚\n・防カビ\nなどに対し強力に効果を発揮します。"],
  ["光触媒コーティング", "M", 12000, 35, "車内を光触媒コーティングしてウィルス対策！", "ウイルス、雑菌、花粉、バクテリア、カビ、匂いなどから車内を守ります。\nすべてのシート、フロアマット、ダッシュボード、ハンドル、シフトレバー、サイドブレーキ、ドア内張、内窓、天井、トランクなど、車内すべてに吹きつけます。\n\n光触媒イオニアミストProは消毒と違って、内装の変色や匂いが残ったりすることはありません。\n抗ウイルス・抗菌効果は半年以上発揮し続けます。\n吹きつけた箇所が抗菌仕様になるだけでなく、臭いの原因である雑菌も分解します。\nまた、空気中の有機物質も分解して空気清浄効果も発揮します。\n専用の噴霧器とエアーコンプレッサーで吹きつけて\n超微粒子の酸化チタン粒子を定着させます。\n長期間にわたって酸化反応し、\n・抗ウイルス\n・防菌\n・防臭\n・防汚\n・防カビ\nなどに対し強力に効果を発揮します。"],
  ["光触媒コーティング", "L", 15000, 40, "車内を光触媒コーティングしてウィルス対策！", "ウイルス、雑菌、花粉、バクテリア、カビ、匂いなどから車内を守ります。\nすべてのシート、フロアマット、ダッシュボード、ハンドル、シフトレバー、サイドブレーキ、ドア内張、内窓、天井、トランクなど、車内すべてに吹きつけます。\n\n光触媒イオニアミストProは消毒と違って、内装の変色や匂いが残ったりすることはありません。\n抗ウイルス・抗菌効果は半年以上発揮し続けます。\n吹きつけた箇所が抗菌仕様になるだけでなく、臭いの原因である雑菌も分解します。\nまた、空気中の有機物質も分解して空気清浄効果も発揮します。\n専用の噴霧器とエアーコンプレッサーで吹きつけて\n超微粒子の酸化チタン粒子を定着させます。\n長期間にわたって酸化反応し、\n・抗ウイルス\n・防菌\n・防臭\n・防汚\n・防カビ\nなどに対し強力に効果を発揮します。"]
]

ops.map do |name, size_name, price, required_time, memo, detail_memo|
  size = CarSize.find_by(name: size_name)
  CarWashOption.find_or_create_by!(
    name: name,
    price: price,
    required_time: required_time,
    status: true,
    car_size_id: size.id,
    memo: memo,
    detail_memo: detail_memo
  )
end
