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