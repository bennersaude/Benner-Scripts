#!/bin/bash

my_dir="$(dirname "$0")"
source "$my_dir/configs.sh"
source "$my_dir/utils.sh"

DOCKER_IP="mga-hugo"

while getopts 'n:p:d:' flag; do
  case "${flag}" in
    n) NAME="${OPTARG}" ;;
    d) PUBLISH_PATH="${OPTARG}" ;;
    p) PORT="${OPTARG}" ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

if [[ -z "$PUBLISH_PATH" ]]; then
    echo 'Caminho do publish não encontrado, utilize a opção -d "Caminho"'
    exit 1
fi

if [[ -z "$PORT" ]]; then
    echo 'Porta não informada utiliza a opção -p "Porta"'
    exit 1
fi

if [[ -z "$NAME" ]]; then
    echo 'Não informado um nome para o Container, utilize a opção -n "Name"'
    exit 1
fi

cd "$PUBLISH_PATH"
sed -Ei "s/Data Source=\(local\);Initial Catalog=([^;]+);.*?\"/Server=$DOCKER_IP;Database=\1;User Id=benner;Password=benner;\"/g" Web.config
cd -

vPath=$(convertPathToWindows "$PUBLISH_PATH")

docker rm -f "$NAME" 2>/dev/null
docker run -d -p "$PORT":8000 --name "$NAME" -v "$vPath":C:\\site iis
