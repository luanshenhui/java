<%@include file="/common/sub_header.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<html>
	<head>
		<title>进销存管理系统</title>
	<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
	background-color: #016aa9;
	overflow:hidden;
}
.STYLE1 {
	color: #000000;
	font-size: 12px;
}
-->
</style></head>
	<form name="form1" action="loginuser!logon.action" method="post">
<body>
<input type="hidden" id="messageInfo"
				value="${requestScope.messageInfo}" />

<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td><table width="962" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td height="235" background="images/login_03.gif">&nbsp;</td>
      </tr>
      <tr>
        <td height="53"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="394" height="53" background="images/login_05.gif">&nbsp;</td>
            <td width="206" background="images/login_06.gif"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="16%" height="25"><div align="right"><span class="STYLE1">用户</span></div></td>
                <td width="57%" height="25"><div align="center">
                  <input type="text" name="loginuser.name" id="name" style="width:105px; height:17px; background-color:#292929; border:solid 1px #7dbad7; font-size:12px; color:#6cd0ff">
                </div></td>
                <td width="27%" height="25">&nbsp;</td>
              </tr>
              <tr>
                <td height="25"><div align="right"><span class="STYLE1">密码</span></div></td>
                <td height="25"><div align="center">
                  <input type="password" name="loginuser.password"  id="password" style="width:105px; height:17px; background-color:#292929; border:solid 1px #7dbad7; font-size:12px; color:#6cd0ff">
                </div></td>
                <td height="25"><div align="left"><a href="#" onclick="logon();"><img src="images/dl.gif" width="49" height="18" border="0"></a></div></td>
              </tr>
            </table></td>
            <td width="362" background="images/login_07.gif">&nbsp;</td>
          </tr>
        </table></td>
      </tr>
      <tr>
        <td height="213" background="images/login_08.gif">&nbsp;</td>
      </tr>
    </table></td>
  </tr>
</table>

















		</form>
	</body>

</html>

<script>

 
function logon(){
       if($("#name").val() == ""){
          $.messager.alert('警告','请输入用户名！','warning');
          return;
     }
      if($("#password").val() == ""){
          $.messager.alert('警告','请输入密码！','warning');
          return;
     }
 	 document.forms[0].action= "<%=path%>/loginuser!logon.action";
	 document.forms[0].submit();
	 
	 
}

function reset(){
    $("#name").val("");
    $("#password").val("")
}
$(document).ready(function(){
	 var $messageInfo = $("#messageInfo").val();
	 if($messageInfo != null && $messageInfo != ""){
		 $.messager.show({
			title:'提示',
			msg:$messageInfo,
			timeout:2000,
			showType:'slide'
		 });
		 $("#messageInfo").val("");
	 }
  });
  
  
</script>