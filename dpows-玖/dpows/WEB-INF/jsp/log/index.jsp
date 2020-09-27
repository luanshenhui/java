<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<%@ include file="/common/resource.jsp"%>

<script type="text/javascript">

function btnSearch(){
	var url = '${ctx}/log/search/sub';
	$("#delete").attr("action",url);
	$("#delete").submit();
}


	
</script>
</head>

<body>


<div id="content">
  <div class="crumb">当前位置：业务日志 &gt; 业务日志验证</div>
  <%@ include file="/common/message.jsp"%>
 <!--  <div class="menu"> -->
  <form action="${ctx}/log/search/sub" id="delete">
  	<label>查询日志用户名</label><input type='text' name="logUser" id="logUser"/>
  	<input onclick="btnSearch" type="submit" class="btn" value="提交" />
</form>
</div>

</body>
</html>


