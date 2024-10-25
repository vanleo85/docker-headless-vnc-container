
docker build -t vnc-test:latest -f Dockerfile.debian-xfce-vnc .

crm
8.3.20.2290
docker build --build-arg ONEC_VERSION=8.3.20.2290 --no-cache -t harbor.svc.vkusvill.ru/onec/all:8.3.20.2290-r-12 -f Dockerfile.debian-onec-all .

docker build --build-arg ONEC_VERSION=8.3.23.1912 --no-cache -t harbor.svc.vkusvill.ru/onec/all:8.3.23.1912-r-1 -f Dockerfile.debian-onec-all .
