
docker build -t vnc-test:latest -f Dockerfile.debian-xfce-vnc .

docker build --build-arg ONEC_VERSION=8.3.22.1923 --no-cache -t harbor.svc.vkusvill.ru/onec/all:latest -f Dockerfile.debian-onec-all .
