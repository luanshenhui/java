
mode=fuat

assetsHome=/home/wasadmin/data/static/cgbchina-front-admin/build
assetsHome=/home/wasadmin/data/static/cgbchina-front-mall/build
assetsHome=/home/wasadmin/data/static/cgbchina-front-vendor/build

trackers=21.96.33.83:22122

zookeeper://21.96.33.65:2181?backup=21.96.33.85:2181

redis.host=21.96.33.65
redis.port=6379

mysql:
21.96.33.68:3306/cgbchina_uat_all
uat/uat

searchHost=21.96.33.65,21.96.33.85
searchPort=9300
searchClusterName=cgbelasticsearch

failover:(tcp://21.96.33.65:61616,tcp://21.96.33.85:61616)


*******************************************************

> cgb-admin
\pom.xml
\src\main\filter\fuat.properties

> cgb-batch
\pom.xml
\src\main\filter\fuat.properties

> cgb-batch-bin
\pom.xml
\src\main\filter\fuat.properties

> cgb-cms-mall
\pom.xml
\src\main\filter\fuat.properties

> cgb-config
\pom.xml
\src\main\resources\spring\web-context.xml

> cgb-item
\pom.xml
\src\main\filter\fuat.properties

> cgb-log
\pom.xml
\src\main\filter\fuat.properties

> cgb-mall-web
\pom.xml
\src\main\filter\fuat.properties

> cgb-promotion
\pom.xml
\src\main\filter\fuat.properties

> cgb-related
\pom.xml
\src\main\filter\fuat.properties

> cgb-rest
\pom.xml
\src\main\filter\fuat.properties

> cgb-trade
\pom.xml
\src\main\filter\fuat.properties

> cgb-user
\pom.xml
\src\main\filter\fuat.properties

> cgb-vendor-web
\pom.xml
\src\main\filter\fuat.properties

