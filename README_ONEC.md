
docker build -t vnc-test:latest -f Dockerfile.debian-xfce-vnc .

docker build --build-arg ONEC_VERSION=8.3.20.2290 --no-cache -t harbor.svc.vkusvill.ru/onec/all:8.3.20.2290-r-3 -f Dockerfile.debian-onec-all .
