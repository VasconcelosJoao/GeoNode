## Instalação do GeoNode Vanilla usando Docker

Este documento tem como objetivo orientar o usuário ou desenvolvedor sobre a maneira mais adequada de instanciar um GeoNode Vanilla utilizando a ferramenta Docker.

Caso você esteja em uma rede da PF, certifique-se de que o proxy e o certificado estejam configurados corretamente em sua máquina ou VM.

### Configuração do Proxy

```bash
# Adiciona as configurações de proxy no ~/.bashrc
echo "" >> ~/.bashrc
echo "export http_proxy=http://proxy.ditec.pf.gov.br:3128" >> ~/.bashrc
echo "export https_proxy=http://proxy.ditec.pf.gov.br:3128" >> ~/.bashrc
echo "export HTTP_PROXY=http://proxy.ditec.pf.gov.br:3128" >> ~/.bashrc
echo "export HTTPS_PROXY=http://proxy.ditec.pf.gov.br:3128" >> ~/.bashrc
echo "" >> ~/.bashrc
echo 'export no_proxy="localhost, 127.0.0.1, dpf.gov.br, pf.gov.br, 10.0.0.0/8, 10.61.85.52, *googleapis.com, 172.217.0.0/16, "' >> ~/.bashrc
echo "export NO_PROXY=\$no_proxy" >> ~/.bashrc

# Aplica as alterações
source ~/.bashrc
```

### Instalação do Certificado

```bash
curl http://www.ditec.pf.gov.br/download/sistemas/ditec.crt | openssl x509 | sudo tee -a /etc/ssl/certs/ca-certificates.crt
```

Observações:
- Nos testes realizados em um Ubuntu 24.04 Server minimizado, foi necessário adicionar a configuração do proxy em "/etc/environment".

```bash
# Adiciona as configurações de proxy no /etc/environment
echo "" | sudo tee -a /etc/environment > /dev/null
echo "http_proxy=\"http://proxy.ditec.pf.gov.br:3128\"" | sudo tee -a /etc/environment > /dev/null
echo "https_proxy=\"http://proxy.ditec.pf.gov.br:3128\"" | sudo tee -a /etc/environment > /dev/null
echo "HTTP_PROXY=\"http://proxy.ditec.pf.gov.br:3128\"" | sudo tee -a /etc/environment > /dev/null
echo "HTTPS_PROXY=\"http://proxy.ditec.pf.gov.br:3128\"" | sudo tee -a /etc/environment > /dev/null
echo "" | sudo tee -a /etc/environment > /dev/null
echo "no_proxy=\"localhost, 127.0.0.1, dpf.gov.br, pf.gov.br, 10.0.0.0/8, 192.168.0.0/16, *googleapis.com, 172.217.0.0/16\"" | sudo tee -a /etc/environment > /dev/null
echo "NO_PROXY=\"localhost, 127.0.0.1, dpf.gov.br, pf.gov.br, 10.0.0.0/8, 192.168.0.0/16, *googleapis.com, 172.217.0.0/16\"" | sudo tee -a /etc/environment > /dev/null

# Após alterar o environment é necessario reiniciar a VM
```

- Os processos de `clone` e `build` podem demorar um pouco, dependendo da sua conexão com a internet e da especificação do seu hardware.
- Este passo a passo foi criado para as versões 4.1.x e 4.3.x. Para outras versões, algumas adaptações são necessárias. Para mais informações, acesse [Link](https://docs.geonode.org/en/4.3.0/install/advanced/core/index.html#docker) e altere a versão da documentação para a versão desejada do GeoNode.
- A instalação do pacote `git` é necessária para execução desse passo a passo.

### Instalação do GeoNode Vanilla

#### Instalação do Docker

1. Primeiro, adicione a chave GPG do Docker.

```bash
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

2. Após isso, instale o Docker.

```bash
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

3. Após instalar o Docker, também é necessário configurar o proxy no arquivo de configuração do próprio Docker em "/etc/systemd/system/docker.service.d/http-proxy.conf".

```bash
sudo mkdir -p /etc/systemd/system/docker.service.d/ && echo -e "[Service]\nEnvironment=\"HTTP_PROXY=http://proxy.ditec.pf.gov.br:3128\" \"HTTPS_PROXY=http://proxy.ditec.pf.gov.br:3128\"" | sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf > /dev/null
```

4. Então, reinicie o serviço do docker

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

#### Instalação do GeoNode 4.1.x

1. Clone uma versão do GeoNode.

```bash
sudo apt install git
git clone https://github.com/GeoNode/geonode.git
cd geonode

# Checkout para a tag ou branch desejada
git checkout tags/4.1.3
# A versão 4.1.3 é apenas um exemplo, este passo a passo funciona para qualquer tag da versão 4.1
```

2. Use o `Docker Compose` para construir e instanciar seu GeoNode Vanilla.

```bash
# Pode ser necessário passar o proxy como argumento, para o correto funcionamento do comando.
sudo docker compose build --build-arg http_proxy=http://proxy.ditec.pf.gov.br:3128 --build-arg https_proxy=http://proxy.ditec.pf.gov.br:3128
# Pode ser necessário alterar o arquivo requirements.txt caso haja conflito com a versão do dropbox (erro constatado na data 15/07/2024)
# A solução utilizada foi alterar a versão do dropbox==11.36.0 para dropbox==11.36.2

sudo docker compose up -d
```

Após executar o `compose`, aguarde alguns minutos para que a instância do GeoNode Vanilla esteja pronta para uso.

#### Instalação do GeoNode 4.3.x

1. Clone uma versão do GeoNode.

```bash
sudo apt install git
git clone https://github.com/GeoNode/geonode.git
cd geonode

# Checkout para a tag ou branch desejada
git checkout tags/4.3.0
# A versão 4.3.0 é apenas um exemplo, este passo a passo funciona para qualquer tag da versão 4.3
```

2. Execute o programa de criação do arquivo de variáveis de ambiente.

```bash
IPVAR=$(ip addr show dev enp1s0 | awk '/inet / {print $2}' | cut -d/ -f1)
echo "y" | python3 create-envfile.py --hostname $IPVAR
```

3. Use o `Docker Compose` para construir e instanciar seu GeoNode Vanilla.

```bash
# É necessário descomentar as linhas referentes ao build no arquivo docker-compose.yml
sed -i '/^  #build:/s/^  #/  /' docker-compose.yml
sed -i '/^  #    context: .\//s/^  #/  /' docker-compose.yml
sed -i '/^  #    dockerfile: Dockerfile/s/^  #/  /' docker-compose.yml
# Pode ser necessário passar o proxy como argumento, para o correto funcionamento do comando.
sudo docker compose build --build-arg http_proxy=http://proxy.ditec.pf.gov.br:3128 --build-arg https_proxy=http://proxy.ditec.pf.gov.br:3128

sudo docker compose up 
```

Após executar o `compose`, aguarde alguns minutos para que a instância do GeoNode Vanilla esteja pronta para uso.