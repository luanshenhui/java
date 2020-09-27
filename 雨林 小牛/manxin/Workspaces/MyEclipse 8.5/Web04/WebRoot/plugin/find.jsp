<%@page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<html>
	<head>
		<title>页面查询</title>
		<script type="text/javascript">

		var ages ={
			"1":"10~17",
			"2":"18~25",
			"3":"26~33",
			"4":"34~55"	
		};
		var sexs={
		"1":"男",
		"2":"女"
		};
    	
		function init(){
		var age=document.getElementById("age");
			for(var key in ages){
				age.options[age.options.length]=new Option(ages[key]);
		}
		var sex=document.getElementById("sex");
		for(var key in sexs){
		sex.options[sex.options.length]=new Option(sexs[key]);
		}
		/*var city=document.getElementById("tocity");
		for(var key in citys){
		city.options[city.options.length]=new Option(citys[key]);
		}*/

    	}
		window.onload=init;
	</script>

		<style>
form {
	padding:10px;
	width: 800px;
	border:0px solid #567;
}

.combo {
	width: 100px;
}
</style>
	</head>

	<body>
		<form action="findMeny.do" method="post">
				年龄：
				<select name="age" id="age" class="combo"></select>
				性别：
				<select name="sex" id="sex" class="combo"></select>
				城市：<%@include file="../select_city.jsp"%>
				<input type="submit" value="搜索">
		</form>
	</body>
</html>