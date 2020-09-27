#!/bin/bash


BATCH_HOME=`pwd`

cd $BATCH_HOME
CLASS_PATH=$CLASS_PATH:$BATCH_HOME
JAR_HOME="."

for f in $JAR_HOME/lib/*.jar
do 
 CLASS_PATH=$CLASS_PATH:$f
done

EXECUTE_CLASS="cn.com.cgbchina.batch.centralizedControl.DealBestRateControl"

java  -Xms512m -Xmx1024m -cp "${CLASS_PATH}" "${EXECUTE_CLASS}" $1 $2
