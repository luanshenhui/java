#!/usr/bin/env bash
mvn clean package  -am -pl cgb-admin  -Dmaven.test.skip=true -Pdev