#!/bin/bash

###############
# Please modify your cloud mqtt credential here
##############
m_i2c="3c"
m_server="maqiatto.com"
m_port=1883
m_user="lbai@temple.edu"
m_pass="fast300a"
m_topic="lbai@temple.edu/raspberrypi"

################
# nothing needs to be changed below
##############
echo "Starting script sayIPbs "
private=`hostname -I | sed -E -e 's/[[:blank:]]+/_/g' `
res=`mosquitto_pub -h $m_server -p $m_port -u $m_user -P $m_pass -t $m_topic -m $private  > /dev/null 2>&1`

mapfile -t data < <(i2cdetect -y 1)

for i in $(seq 1 ${#data[@]}); do
    line=(${data[$i]})
    echo ${line[@]:1} | grep -qw "$m_i2c"
    if [ $? -eq 0 ]; then
        test=` python /home/pi/stats.py`
        exit 0
    fi
done
