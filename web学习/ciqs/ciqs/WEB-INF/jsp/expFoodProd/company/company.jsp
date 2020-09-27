<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>生产企业名录</title>
<%@ include file="/common/resource_show.jsp"%>
<link type="text/css" rel="stylesheet" href="${ctx}/static/dec/styles/dpn.css" />
		
<style type="text/css">
	input.datepick{background:#FFF url(/ciqs/static/dec/images/dpn.date.pick.gif) no-repeat right}
</style>
<link rel="stylesheet" href="${ctx}/static/viewer/assets/css/bootstrap.min.css"/>
<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css"/>
<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css"/>
<style>
a:link, a:visited {
    color:white;
    text-decoration: none;
}
td {
    border: solid 1px #dcdcdc;
}
</style>

</head>
<body>
<div class="freeze_div_list" style="height: 0px">
<div class="title-bg" >
<div class=" title-position margin-auto white">
<div class="title"><a href="#" class="white"><span  class="font-20px">生产企业名录</span></a></div>
<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
</div>
</div>
</div>
<!-- *************************************************************************************** -->
	<div class="dpn-content" style="margin-top:60px">
	<div><h3>生产企业名录</h3></div>
		<div class="search">
		 <table width="100%" border="0" cellpadding="0" class="table-xqlb">
		 <tr style="font-size: 18px;color: black;"><td>备案号</td><td>企业名称</td><td>产品种类</td></tr>
		<c:forEach items="${list}" var="v" varStatus="status">
				    <tr>
					    <td align="center">
					    ${v.ipc_no}
					    </td>
					      <td align="center">
					    ${v.company_name}
					    </td>
					      <td align="center">
					    ${v.ipc_product}
					    </td>
					</tr>
			</c:forEach>
			</table>
		</div>
	</div>
	<div style="text-align: center;margin: auto;margin-top: 10px;width:200px;padding-bottom: 10px;">
			<input type="button" class="search-btn" value="返回"  onclick="JavaScript:history.go(-1);"/>
		</div>
</body>
</html>
