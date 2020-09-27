<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    

  </head>
  
  <body>
   <h1>文件上传</h1>
   <form action="upload" method="post" enctype="multipart/form-data">
   	<input type="file" name="some" />
   	<br/>
   	<input type="submit" value="提交" />
   </form>
  </body>
</html>
