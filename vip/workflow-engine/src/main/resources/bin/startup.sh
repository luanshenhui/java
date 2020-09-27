#!/usr/bin/env bash
echo ================engine start======================
ps -ef |grep engine-exec.jar|grep -v grep |awk '{print $2}' |xargs kill -9


nohup java -jar engine-exec.jar 2>&1 &