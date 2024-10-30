

Создание базы 1с с публикацией в apache2

runner init-dev
mkdir -p /var/www/ib
chmod -R 777 "/build/ib" "/var/www/ib"
/opt/1cv8/current/webinst -publish -apache24 -wsdir "ib" -dir "/var/www/ib" -connstr "File=\"/build/ib\";"
service apache2 restart



docker build -t vnc-test:latest -f Dockerfile.debian-xfce-vnc .
docker run -it -p 31001:5901 -p 31002:6901 vnc-test:latest

crm
8.3.20.2290
docker build --build-arg ONEC_VERSION=8.3.20.2290 --no-cache -t harbor.svc.vkusvill.ru/onec/all:8.3.20.2290-r-12 -f Dockerfile.debian-onec-all .

docker build --build-arg ONEC_VERSION=8.3.23.1912 --no-cache -t harbor.svc.vkusvill.ru/onec/all:8.3.23.1912-r-1 -f Dockerfile.debian-onec-all .
