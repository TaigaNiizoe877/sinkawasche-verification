# README

## お客様、管理者それぞれのtopページのURL
  お客様
    http://localhost:3020/forms/top
    
  管理者
    http://localhost:3020/staffs/sign_in

## sinkawascheメールアドレス・パスワード　
  ```
  お客様
    tarou@gmail.com
    
  管理者
    hanako@gmail.com
    （お客様、管理者共にパスワードはメールアドレスと同じです）
  ```

### セットアップ

```
docker compose build
docker compose up
docker compose exec app bin/setup
```

### データベース変更時 
```
docker compose exec app rails db:create
docker compose exec app rails db:apply
docker compose exec app rails db:seed
```

### 開発中にGemを追加した時
```
docker compose exec app bundle install
```

# テスト
  ## 全体テスト
    docker compose exec app bin/rspec

  ## 単体テスト
    docker compose exec app bin/rspec spec/~ (ファイルパス)

  ## 外部webサービスをテストする場合は、vcr=trueを利用する
  -  参照 https://morizyun.github.io/blog/webmock-vcr-gem-rails/

  ## カバレッジ
    docker compose exec app bin/rspec
    open coverage/index.html

# Rubocop
  ## 実行
    docker compose exec app rubocop // チェックのみ
    docker compose exec app rubocop -A // 強制修正

# 日本語化
  ## 実行
    docker compose exec app bundle exec rails g i18n ja

# erb to slim
  ## 実行
    docker compose exec app erb2slim app/views app/views -d
