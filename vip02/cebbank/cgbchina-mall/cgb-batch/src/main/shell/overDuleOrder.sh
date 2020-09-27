JAVA_HOME=/usr/java5/

APP_LIB=/cgbmall/interfaceService/CgbMallBatch/lib/
for i in ${APP_LIB}/*.jar
do
        APP_CLASSPATH=$APP_CLASSPATH:$i
done

export LANG=Zh_CN.GB18030
export JAVA_HOME
export APP_LIB

#echo $APP_CLASSPATH
$JAVA_HOME/bin/java -cp /cgbmall/interfaceService/CgbMallBatch/bin:./../lib:.:${JAVA_HOME}/jre/lib/rt.jar:${JAVA_HOME}/jre/lib/tools.jar:${JAVA_HOME}/lib/dt.jar:${APP_CLASSPATH} cn.com.cgbchina.batch.main.StartUp