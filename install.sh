#!/bin/sh
    
PULSAR_VERSION=2.7.3
APPLICATION=pulsar-standalone
EXEC_PATH=$(pwd)

if [ "$(whoami)" != "root" ]; then
    echo "You must be root to do this"
    exit
fi

# Create the user if it does not exist
./create_user.sh

mkdir -p /etc/pulsar
mkdir -p /opt/apache/
chmod 755 /opt/apache/
    
cd /opt/apache/
#wget "https://www.apache.org/dist/pulsar/pulsar-$PULSAR_VERSION/apache-pulsar-$PULSAR_VERSION-bin.tar.gz.sha512" -O apache-pulsar-$PULSAR_VERSION-bin.tar.gz.sha512
# Download only if checksum is wrong (in case file is not present or changed)
#sha512sum -c  apache-pulsar-$PULSAR_VERSION-bin.tar.gz.sha512 --strict || wget -q "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=pulsar/pulsar-$PULSAR_VERSION/apache-pulsar-$PULSAR_VERSION-bin.tar.gz" -O apache-pulsar-$PULSAR_VERSION-bin.tar.gz
#wget "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=pulsar/pulsar-$PULSAR_VERSION/apache-pulsar-$PULSAR_VERSION-bin.tar.gz" -O apache-pulsar-$PULSAR_VERSION-bin.tar.gz
#tar -xzvf apache-pulsar-$PULSAR_VERSION-bin.tar.gz
chmod 755 /opt/apache/apache-pulsar-$PULSAR_VERSION
chown root:root -R /opt/apache/apache-pulsar-$PULSAR_VERSION
    
# For standalone, the directory /opt/apache/apache-pulsar-$PULSAR_VERSION must be available to the user running Pulsar
mkdir -p /opt/apache/apache-pulsar-$PULSAR_VERSION/data
chown pulsar-standalone:pulsar-standalone -R /opt/apache/apache-pulsar-$PULSAR_VERSION
    
rm -f /opt/apache/apache-pulsar 
ln -s /opt/apache/apache-pulsar-$PULSAR_VERSION/ /opt/apache/apache-pulsar

cp $EXEC_PATH/pulsar-standalone.service /usr/lib/systemd/system/
cp $EXEC_PATH/pulsar-standalone /etc/sysconfig/
cp $EXEC_PATH/pulsar-standalone.conf /etc/pulsar/
    
mkdir -p /var/lib/pulsar-standalone
chmod 750 /var/lib/pulsar-standalone
chown pulsar-standalone:pulsar-standalone /var/lib/pulsar-standalone
    
mkdir -p /var/log/pulsar-standalone
chmod 750 /var/log/pulsar-standalone
chown pulsar-standalone:pulsar-standalone /var/log/pulsar-standalone
    
mkdir -p /etc/pki/pulsar/certs
mkdir -p /etc/pki/pulsar/private
chmod 755 /etc/pki/pulsar/
chmod 755 /etc/pki/pulsar/certs
chmod 755 /etc/pki/pulsar/private
    
systemctl daemon-reload
systemctl restart pulsar-standalone