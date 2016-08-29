#proagarm to install packages
#make sure while running the file use sudo ./install.sh and before executing 
# chmod 777 permission or more restrictive as required
echo "installing jdk";
apt-get update
#installing opjdk
#apt-get -y install openjdk-7-jdk
#export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/bin
echo "testing jdk";



echo "echo installing tomcat"
mkdir /opt/server

#wget for downlading a file syntax
#wget <url or location where to get the file > -P <path where to keep the file>

wget http://mirror.fibergrid.in/apache/tomcat/tomcat-7/v7.0.70/bin/apache-tomcat-7.0.70.tar.gz -P /opt/server/
#extracting the file to /opt/server
#tar -xzvf <path of file> <path that to be extracted>

tar -xzvf /opt/server/apache-tomcat-7.0.70.tar.gz -C /opt/server/
chmod 755 /opt/server/apache-tomcat-7.0.70/bin/*.sh

