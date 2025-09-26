#!/bin/bash
# Basic bootstrap to install Docker & Jenkins on an EC2 instance (for demo/testing only)
apt-get update
apt-get install -y openjdk-11-jre apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee       /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ |       tee /etc/apt/sources.list.d/jenkins.list > /dev/null
apt-get update
apt-get install -y jenkins docker.io
systemctl enable --now docker
usermod -aG docker jenkins
systemctl enable --now jenkins
