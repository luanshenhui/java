<%@ page language="java" import="java.util.*" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>NetCTOSS</title>
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global.css" />
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global_color.css" /> 
        <script type="text/javascript" language="javascript">
    		function change(img){
    			img.src = "imageCode.action?date="+new Date().getTime();
    		}
    	</script>
    </head>
    <body class="index">
        <div class="login_box">
        <form action="login" method="post">
            <table>
                <tr>
                    <td class="login_info">账号：</td>
                    <td colspan="2"><input name="admin_code" type="text" class="width150" /></td>
                    <td class="login_error_info"><span class="required">30长度的字母、数字和下划线</span></td>
                </tr>
                <tr>
                    <td class="login_info">密码：</td>
                    <td colspan="2"><input name="password" type="password" class="width150" /></td>
                    <td><span class="required">30长度的字母、数字和下划线</span></td>
                </tr>
                <tr>
                    <td class="login_info">验证码：</td>
                    <td class="width70"><input name="imageCode" type="text" class="width70" /></td>
                    <td><img src="imageCode.action" onclick="change(this)" alt="验证码" title="点击更换" /></td>  
                    <td><span class="required">验证码错误</span></td>              
                </tr>            
                <tr>
                    <td></td>
                    <td class="login_button" colspan="2">
                       <a href="javascript:document.forms[0].submit();"><img src="../images/login_btn.png" /></a>
                    </td>    
                    <td><span class="required">用户名或密码错误，请重试</span></td>                
                </tr>
            </table>
            </form>
        </div>
    </body>
</html>

