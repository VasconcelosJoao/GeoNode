sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo mkdir -p /etc/systemd/system/docker.service.d/ && echo -e "[Service]\nEnvironment=\"HTTP_PROXY=http://proxy.exemplo:1234\" \"HTTPS_PROXY=http://proxy.exemplo:1234\"" | sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf > /dev/null

sudo systemctl daemon-reload
sudo systemctl restart docker