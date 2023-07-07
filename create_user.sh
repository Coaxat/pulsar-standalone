#!/bin/sh
    
USER_ID=930
USER=pulsar-standalone
HOME=/var/lib/pulsar-standalone
    
ret=false
getent passwd $USER >/dev/null 2>&1 && ret=true
    
if $ret; then
    echo "yes the user exists"
    exit 0
else
    echo "No, the user does not exist"
fi
    
ret=false
getent passwd $USER_ID >/dev/null 2>&1 || getent group $USER_ID >/dev/null 2>&1 && ret=true
    
if $ret; then
    echo "The UID or the GID already exist. Use next available UID/GID"
    useradd -r $USER -s /sbin/nologin -d $HOME
else
    echo "Nor the UID nor the GID does not exist, enforce it"
    groupadd -g $USER_ID $USER
    useradd -r $USER -u $USER_ID -g $USER_ID -s /sbin/nologin -d $HOME
fi
    
mkdir -p $HOME
chmod 755 $HOME
chown $USER.$USER $HOME