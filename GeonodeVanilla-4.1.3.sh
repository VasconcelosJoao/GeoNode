git clone https://github.com/GeoNode/geonode.git
cd geonode

# Checkout para a tag ou branch desejada
git checkout tags/4.1.3

# Foi necessário passar o proxy como argumento, pois sem ele o build não funcionava corretamente.
sudo docker compose build --build-arg http_proxy=http://proxy.exemplo:1234 --build-arg https_proxy=http://proxy.exemplo:1234
# Pode ser que seja necessario alterar o arquivo requirequirements.txt caso tenha conflito com a versão do dropbox

sudo docker compose up -d