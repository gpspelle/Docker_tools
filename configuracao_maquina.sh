#/bin/sh
adduser $1
usermod -aG sudo $1
su $1
cd
mkdir workstation
cd workstation
git clone https://github.com/gpspelle/Fall_detection
git clone https://github.com/gpspelle/Docker_tools

#Optional
#git clone https://github.com/gpspelle/personal
#mv personal/.vimrc ~/

cp Docker_tools/* .

sudo apt-get remove docker-ce
sudo apt-get update

sudo apt-get install \
        apt-transport-https \
            ca-certificates \
                curl \
                    gnupg-agent \
                        software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
          $(lsb_release -cs) \
             stable"

sudo apt-get update

docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
sudo apt-get purge -y nvidia-docker
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
      sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
      sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt-get update
sudo apt-get install nvidia-418
sudo reboot


