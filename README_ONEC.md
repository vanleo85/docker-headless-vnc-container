
docker build -t vnc-test:latest -f Dockerfile.debian-xfce-vnc .

docker build --build-arg ONEC_VERSION=8.3.22.2239 --no-cache -t harbor.svc.vkusvill.ru/onec/all:8.3.22.2239-r-1 -f Dockerfile.debian-onec-all .
