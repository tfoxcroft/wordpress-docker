docker-compose stop
docker-compose rm --force

cd restore
rm -rf public_html

tar -xvf public_html.tar.gz

LINE="define('RELOCATE',true);"
FILE=public_html/wp-config.php
grep -q "$LINE" "$FILE" || sed -i "/define('WP_DEBUG', false);/a define('RELOCATE',true);" "$FILE"

cd ..

docker-compose up -d wordpress_db

for i in {50..1..10};do echo -n "$i." && sleep 5; done

mysql --host 127.0.0.1 -uroot -pwordpress -e "CREATE DATABASE wordpress;"
mysql --host 127.0.0.1 -uroot -pwordpress wordpress <  restore/cadenc0_wpsite.sql

for i in {10..1..5};do echo -n "$i." && sleep 5; done

docker-compose up -d