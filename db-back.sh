#!/bin/bash

# 备份数据库

#数据库 信息
host=127.0.0.1
user=root
pass=123456
db=dc_product

function bakDb(){

    host=$1
    user=$2
    pass=$3
    db=$4

    start=`date +%s`
    time=$(date +%Y%m%d)
    time2=$(date +%Y%m%d_%H%M%S)

    dbsavedir=/home/dawnco/web/sql/$time
    dbsavepath=$dbsavedir/${db}.sql
    mkdir -p $dbsavedir

    #back db
    mysqldump  -u${user} -p${pass} $db > $dbsavepath

    end=`date +%s`
    dif= expr $end - $start
    echo $dif
}

bakDb $host $user $pass $db