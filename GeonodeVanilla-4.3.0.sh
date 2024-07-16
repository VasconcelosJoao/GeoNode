git clone https://github.com/GeoNode/geonode.git
cd geonode

# Checkout para a tag ou branch desejada
git checkout tags/4.3.0

# Cria o arquivo .env passando o ip da maquina como argumento
IPVAR=$(ip addr show dev enp1s0 | awk '/inet / {print $2}' | cut -d/ -f1)
echo "y" | python3 create-envfile.py --hostname $IPVAR

# É necessario descomentar a linhas referentes ao build no arquivo docker-compose.yml
sed -i '/^  #build:/s/^  #/  /' docker-compose.yml
sed -i '/^  #    context: .\//s/^  #/  /' docker-compose.yml
sed -i '/^  #    dockerfile: Dockerfile/s/^  #/  /' docker-compose.yml
# Foi necessário passar o proxy como argumento, pois sem ele o build não funcionava corretamente.
sudo docker compose build --build-arg http_proxy=http://proxy.ditec.pf.gov.br:3128 --build-arg https_proxy=http://proxy.ditec.pf.gov.br:3128

sudo docker compose up -d