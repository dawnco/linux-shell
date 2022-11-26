#!/bin/bash

# vim  /shell/disk-useage.sh
# 检测磁盘并发消息
# 预警通知
# 服务名称
# */10 * * * * sh /shell/disk-useage.sh >> /dev/null 2>&1 &

service_name="DISK_CHECK";
#主机名
hostname=`hostname`

signStr="12311111111111111111111111111"

# 磁盘使用率
disk_usage_percent=`df -hl |grep dev | awk '{print $5}' | sed 's/%//g'| sort -n -k 2 -r | head -1`

echo "${hostname} 最大磁盘使用率 ${disk_usage_percent}%"


# 本地 ip
local_ip=`ip addr|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'`
# 字符串截取
local_ip=`echo ${local_ip%%/*}`
# 公网 ip
public_ip=`curl -s ifconfig.me`

# {"trackId":"","alertId":"123","ip":"","time_ms":1660197046971,"serviceName":"","developerName":"","data":{"fi1":"v1"}}

data="{\"trackId\":\"\",\"alertId\":\"disk-usage\",\"ip\":\"\",\"time_ms\":1660197046971,\"serviceName\":\"${service_name}\",\"developerName\":\"\",\"data\":{\"hostname\":\"${hostname}\",\"local_ip\":\"${local_ip}\",\"public_ip\":\"${public_ip}\",\"disk_usage_percent\":\"${disk_usage_percent}\"}}"

# 计算 md5
md5=`echo ${signStr}${data}| md5sum | cut -d ' ' -f 1`

#echo ${data}
echo `curl -s -H "Content-Type: application/json" -H "sign: ${md5}" -X POST -d "${data}" http://www.domain.com/api/api/receive`


