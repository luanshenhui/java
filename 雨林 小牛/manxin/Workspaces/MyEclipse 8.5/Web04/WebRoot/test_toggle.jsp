<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="js/jquery-1.4.min.js"></script>
		<!--  
		<script type="text/javascript">
			$(document).ready(function() {
				$(".btn1").click(function() {
					$("#dd").toggle(1000);
				});
			});
		</script>
		-->
		<!--  <script type="text/javascript">
			function clickk(m){
				var mm="#"+m;
				$(mm).toggle(1000);
			}
		</script>
		-->
		<script type="text/javascript">
			function clickk(m){
				$("div[name="+m+"]").toggle(1000);
			}
		</script>
	</head>
	<body>
		<div id="tog" onclick="clickk('yaya');">
			Toggle
		</div>
		<div id="dd" name="yaya">
			This is a paragraph.
		</div>
		<div id="ddd" name="yaya">ddddd</div>
		
	</body>
</html>
