# laravel-queue-sample

Laravel のキューを使った並列処理のサンプル

## stack

PHP コンテナ

- OS: CentOS7
- PHP: 7.2.x
- Composer: 1.10.x
- Laravel: 6.x
- supervisor: 3.x

DB コンテナ

- RDB: Mysql5.7.x

## コンテナ:セットアップ

```
docker-compose up -d
```

## コンテナ:削除

```
docker-compose down
docker volume rm mysql-job-db
```

## DB の用意

```
php artisan queue:table

# バージョンによっては既に作成済み
php artisan queue:failed-table

# jobs、failed_jobsテーブルを作成
php artisan migrate
```

## 動作確認

```
docker exec -it laravel-queue /bin/bash

php artisan serve &

curl localhost:8000
```

### laravel.log

```
[2020-10-10 20:32:34] local.INFO: JobC:8
[2020-10-10 20:32:34] local.INFO: JobB:8
[2020-10-10 20:32:34] local.INFO: JobA:8
[2020-10-10 20:32:35] local.INFO: JobC:9
[2020-10-10 20:32:35] local.INFO: JobB:9
[2020-10-10 20:32:35] local.INFO: JobA:9
[2020-10-10 20:32:36] local.INFO: jobCend
[2020-10-10 20:32:36] local.INFO: jobAend
[2020-10-10 20:32:36] local.INFO: jobBend
```
