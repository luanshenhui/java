<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"
	contentType="text/html; charset=UTF-8"%>
<html>
<head>
	<script type="text/javascript">
		function focusValue(){
			var a=event.target.id;
			alert(a);
			var b=document.getElementsByName(a);
			alert(b);
			b[0].focus();
		}
	</script>
</head>
	<body>
		
		<input type="text" id="super" name="man">
		<input type="button" id="man" value="隐藏" onclick="focusValue(event);">
	</body>
</html>