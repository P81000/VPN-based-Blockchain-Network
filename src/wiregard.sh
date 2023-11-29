#!/bin/bash

# Nomes dos contêineres e seus respectivos IPs
declare -A containers
containers["orderer"]="172.25.0.1"
containers["peer0.org1.example.com"]="172.25.0.2"
containers["peer0.org2.example.com"]="172.25.0.3"
containers["peer0.org3.example.com"]="172.25.0.4"
containers["peer0.org4.example.com"]="172.25.0.5"

# Diretório para os Dockerfiles
dockerfiles_dir="dockerfiles_wireguard"
mkdir -p $dockerfiles_dir

# Função para gerar as chaves WireGuard e criar o arquivo de configuração
generate_and_configure() {
    # ... (função existente)
}

# Função para criar o Dockerfile
create_dockerfile() {
    container=$1
    dockerfile_path="$dockerfiles_dir/Dockerfile_$container"

    echo "Criando Dockerfile para $container..."
    echo -e "FROM alpine:latest\n\n# Instalar WireGuard\nRUN apk add --no-cache wireguard-tools\n\n# Comando de execução padrão\nCMD [\"wg\", \"quick\", \"up\", \"wg0\"]" > $dockerfile_path
}

# Função para construir a imagem Docker e executar o contêiner
build_and_run_container() {
    container=$1
    dockerfile_path="$dockerfiles_dir/Dockerfile_$container"

    echo "Construindo a imagem Docker para $container..."
    docker build -t wireguard-$container -f $dockerfile_path .

    echo "Executando o contêiner Docker para $container..."
    docker run -d --name wireguard-$container --cap-add=NET_ADMIN --net=host -v $(pwd)/$container/wg0.conf:/etc/wireguard/wg0.conf wireguard-$container
}

# Loop principal para iterar sobre os contêineres
index=1
for container in "${!containers[@]}"; do
    generate_and_configure $container $index
    create_dockerfile $container
    build_and_run_container $container
    ((index++))
done

echo "Processo concluído."
