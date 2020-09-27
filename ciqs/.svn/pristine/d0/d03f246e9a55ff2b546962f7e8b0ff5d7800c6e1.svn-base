<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>行政执法全过程监管平台</title>
<link href="static/login/style.css" rel="stylesheet" type="text/css" />
<style type="text/css">
body,td,th{
	font-family: "Microsoft YaHei", "helvetica neue", tahoma, arial, "hiragino sans gb", Simsun, sans-serif;
}
body {
	background-image: url(static/login/images/NAV-bg1112.png);
	background-repeat: repeat-x;
	background-color: #fff;
	background-position: center top;
}

.nav-link{
	color:#393939;
	font-size:18px;
	font-weight: bold;
}
.nav-link:hover{
	color:#393939;
	font-size:18px;
	font-weight: bold;
}
.visit_a{
	font-family: "Microsoft YaHei", "helvetica neue", tahoma, arial, "hiragino sans gb", Simsun, sans-serif;
}
</style>
</head>


<body>
<div style="width:100%; height:80px; padding-top:25px;"><div class="loge" style="width:600px; float:left; padding-left:30px;">
            <img src="static/login/images/logo.png" />
        <img src="static/login/images/name.png" />
</div>
<div style="width:120px; float:right; padding-right:40px;"><table border="0" cellpadding="0" cellspacing="0" style="font-size:12px; color:#FFF;">
          <tr>
            <td width="60" height="70" align="center" valign="middle"><a href="index.jsp"><img src="static/index/img/home.png" width="33" height="33" border="0" title="返回首页"/></a></td>
            <td width="60" height="70" align="center" valign="middle"><a href="login/logout"><img src="static/index/img/ICON3.png" width="33" height="33" border="0" title="退出登录"/></a></td>
          </tr>
</table></div>
</div>
<div style="background-color:#FFF; text-align: center; margin-top:20px;">
  <div style="height:400px; width:900px; margin:auto">
	
	<c:set value="0" var="sum" />
  	<table width="900px;" border="0" align="center" cellpadding="0" cellspacing="0">
    	<tr align="left">
        	<td width="450" height="50px;">&nbsp;</td>
            <td width="450" height="50px;">&nbsp;</td>
        </tr>
        <tr align="left">
        	<td height="50px;" colspan="2" style="border-bottom:2px; border-bottom-color: #107ACB; border-bottom-style: solid; padding-left:10px;">欢迎${user.name }访问本系统，点击下方快捷访问</td>
        </tr>
	<c:forEach items="${login_visits }" var ="row"  varStatus="status">
		<c:if test="${sum%2==0}">
			<tr align="left">
		</c:if>
		<c:choose>
			<c:when test="${fn:contains(row.visitPath,'index.jsp')}">
			</c:when>
			<c:otherwise>
			 <td height="50px;" style="padding-left:50px;">
			 	<a onclick="window.location.href = '${ctx }${row.visitPath }';"style="cursor:pointer" ><img src="static/login/images/list_point.png"/>${row.visitName}</a>
				<c:set value="${sum+1 }" var="sum" />
				</td>	
			</c:otherwise>
		</c:choose>
		<c:if test="${sum%2==0 && sum != 0}">
			</tr>
		</c:if>
		<c:if test="${fn:length(login_visits) == sum && sum%2 != 0 }">
			</tr> 
		</c:if>
	</c:forEach>
    </table>
  </div>
</div>
</body>
</html>