<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<style type="text/css">
 #index_a{color:#ccc}
 #index_a:hover{  
 	color:white;
 }
 
 #login_a{color:#ccc}
 #login_a:hover{
 	color:white;
 }
 
</style>
<div class="user-info">你好：${user.name}，欢迎登录系统      | 
<c:if test="${login_visits == null || fn:length(login_visits) == 0}"><a id="index_a" href="/ciqs/index.jsp">返回首页</a></c:if>
<c:if test="${login_visits != null || fn:length(login_visits) > 0}"><a id="index_a" href="/ciqs/index_visit.jsp">切换系统</a></c:if>
| <a id="index_a" href="/ciqs/index_qlc.jsp">全过程监控平台</a> | <a id="login_a" href="/ciqs/login/toResetPwd">修改密码</a> | <a id="login_a" href="/ciqs/login/logout">退出</a></div>