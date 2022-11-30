#!/bin/bash

# Redis 通过 scan 找出不过期的 key
# SCAN 命令是一个基于游标的迭代器（cursor based iterator）：SCAN 命令每次被调用之后，都会向用户返回一个新的游标，用户在下次迭代时需要使用这个新游标作为 SCAN 命令的游标参数，以此来延续之前的迭代过程。
# 注意:当 SCAN 命令的游标参数被设置为 0 时，服务器将开始一次新的迭代，而当服务器向用户返回值为 0 的游标时，表示迭代已结束!

db_ip=127.0.0.1       # redis 连接IP
db_port=6379          # redis 端口
password='r123456'    # redis 密码
dbname=1              # 数据库
cursor=0              # 第一次游标
cnt=100               # 每次迭代的数量
new_cursor=0          # 下一次游标

redis-cli -c -h $db_ip -p $db_port -a $password -n $dbname scan $cursor count $cnt > scan_tmp_result
new_cursor=`sed -n '1p' scan_tmp_result`     # 获取下一次游标
sed -n '2,$p' scan_tmp_result > scan_result  # 获取 key
cat scan_result |while read line             # 循环遍历所有 key
do
    ttl_result=`redis-cli -c -h $db_ip -p $db_port -a $password -n $dbname ttl $line`  # 获取key过期时间
    if [[ $ttl_result == -1 ]];then
    #if [ $ttl_result -eq -1 ];then          # 判断过期时间，-1 是不过期
        echo $line >> no_ttl.log             # 追加到指定日志
    fi
done

while [ $cursor -ne $new_cursor ]            # 若游标不为0，则证明没有迭代完所有的key，继续执行，直至游标为0
do
    redis-cli -c -h $db_ip -p $db_port -a $password -n $dbname scan $new_cursor count $cnt > scan_tmp_result
    new_cursor=`sed -n '1p' scan_tmp_result`
    sed -n '2,$p' scan_tmp_result > scan_result
    cat scan_result |while read line
    do
        ttl_result=`redis-cli -c -h $db_ip -p $db_port -a $password -n $dbname ttl $line`
        if [[ $ttl_result == -1 ]];then
        #if [ $ttl_result -eq -1 ];then
            echo $line >> no_ttl.log
        fi
    done
done
#rm -rf scan_tmp_result
#rm -rf scan_result
