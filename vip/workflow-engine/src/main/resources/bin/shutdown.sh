#!/usr/bin/env bash
echo ================engine shutdown======================
ps -ef |grep engine-exec.jar|grep -v grep |awk '{print $2}' |xargs kill -9


