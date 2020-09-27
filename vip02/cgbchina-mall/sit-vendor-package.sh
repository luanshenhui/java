#!/usr/bin/env bash
mvn clean package  -am -pl cgb-vendor-web  -Dmaven.test.skip=true -Psit