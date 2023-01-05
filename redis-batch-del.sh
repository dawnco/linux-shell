# 批量删除过期key

# reject_order_redis_key
# user_product_verify


redis-cli -c -a r147258 del reject_order_redis_key:369806861949603841

cut -d : -f 1  no_ttl.log|sort|uniq -c


#  26997 reject_order_redis_key
#  1120 user_product_verify



cat no_ttl.log |grep reject_order_redis_key >> rdel.sh
cat no_ttl.log |grep user_product_verify >> rdel.sh


sed -i 's/reject_order_redis_key/redis-cli -c -a r147258 del reject_order_redis_key/' rdel.sh
sed -i 's/user_product_verify/redis-cli -c -a r147258 del user_product_verify/'  rdel.sh


cut -d : -f 1  rdel.sh|sort|uniq -c
