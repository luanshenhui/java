#!/usr/bin/env bash
mvn clean package  -am -pl cgb-mall-web  -Dmaven.test.skip=true -Psit