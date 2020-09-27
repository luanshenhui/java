<%@ page language="java" import="java.util.*" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>

<html>
  <head>
  </head>
  
  <body style="font-size: 30px;font-style: italic;">
  	<form action="fileupload" method="post" enctype="multipart/form-data">
  		username:<input name="username" /><br/>
  		photo:<input type="file" name="file1" /><br/>
  		<input type="submit" value="Confirm"/>
  	</form>
  </body>
</html>
