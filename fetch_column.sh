#!/bin/bash


# cut -d , -f 2 cut.txt
# -d后面接列分隔符，-f后面接第几列

cut -f N filename > newfilename
#取 第一列
cut -f 1 filename > newfilename
#，也可以提取多列
cut -f 1,2,3 filename > newfilename

# 去重 排序
# uniq -c 显示统计

cat a.txt | sort | uniq


# 查找操作
# 行尾加入一列
sed -i 's/$/newfilename/' rdel.sh


# 把A 文件的第一列剪切出来做为B文件的第一列，很简单： 其中，- 表示从标准输入读。
awk '{print $1}' A | paste - B

# 默认分隔符为tab，可以使用-d选项修改为任意分隔符（比如空格）：
awk '{print $1}' A | paste -d' ' file1 file2
