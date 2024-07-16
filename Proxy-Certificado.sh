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

# Adiciona o certificado da DITEC no /etc/ssl/certs/ca-certificates.crt
curl http://www.ditec.pf.gov.br/download/sistemas/ditec.crt | openssl x509 | sudo tee -a /etc/ssl/certs/ca-certificates.crt

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

sudo apt update && sudo apt upgrade -y
sudo apt install git -y

sudo reboot

sudo date 071616332024