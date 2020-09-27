#!/bin/bash


BATCH_HOME=`pwd`

cd $BATCH_HOME
CLASS_PATH=$CLASS_PATH:$BATCH_HOME
JAR_HOME="."

for f in $JAR_HOME/lib/*.jar
do 
 CLASS_PATH=$CLASS_PATH:$f
done

EXECUTE_CLASS="cn.com.cgbchina.batch.tools.DataReset"
# 1:更新商品名称乱码  2:更新商品属性乱码 3:4:5:6 ITEM属性   7:创建分类关联表数据  8:构建JF GF商城一级类目
java  -Xms512m -Xmx1024m -cp "${CLASS_PATH}" "${EXECUTE_CLASS}" $1  
