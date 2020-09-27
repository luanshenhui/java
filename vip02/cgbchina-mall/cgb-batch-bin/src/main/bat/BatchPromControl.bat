
@set CLASS_PASS=
@for %%f in (..\lib\*.jar) do @call :ADD %%f


SET EXECUTE_CLASS=cn.com.cgbchina.batch.centralizedControl.BatchPromControl

"%JAVA_HOME%\bin\java" -Xms512m -Xmx1024m -XX:SurvivorRatio=8 -cp %CLASS_PASS% %EXECUTE_CLASS% 


:ADD
@set CLASS_PASS=%CLASS_PASS%;%1









 
