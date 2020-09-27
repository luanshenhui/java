<%@page pageEncoding="utf-8" 
contentType="text/html;charset=utf-8" %>
<html>
	<head></head>
	<body style="font-size:30px;font-style:italic;">
		<span style="color:red;">${apply_error}</span>
		<form action="apply.do" method="post">
			<fieldset>
				<legend>申请贷款</legend>
				帐号:<input name="accountNo"/><br/>
				金额:<input name="amount"/><br/>
				<input type="submit" value="提交"/>
			</fieldset>
		</form>
	</body>
</html>