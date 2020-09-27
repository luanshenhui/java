﻿<%@page pageEncoding="UTF-8"  contentType="text/html; charset=UTF-8" 
isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>NetCTOSS</title>
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global.css" />
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global_color.css" />
        <script type="text/javascript">
        	function updateImg(img){
        		img.src="../welcome/imageCode?ran="+Math.random();
        	}
        </script> 
    </head>
    
    <body class="index">
        <div class="login_box">
        	<form action="<%=request.getContextPath()%>/welcome/login.action" method="post">
            <table>
                <tr>
                    <td class="login_info">账号：</td>
                    <td colspan="2">
                    <input name="adminCode" type="text" value="${adminCode}" class="width150" /></td>
                    <td class="login_error_info"><span class="required">30长度的字母、数字和下划线</span></td>
                </tr>
                <tr>
                    <td class="login_info">密码：</td>
                    <td colspan="2">
                    <input name="password" type="password" value="${password}" class="width150" /></td>
                    <td><span class="required">30长度的字母、数字和下划线</span></td>
                </tr>
                <tr>
                    <td class="login_info">验证码：</td>
                    <td class="width70"><input name="code" type="text" class="width70" /></td>
                    <td><img src="<%=request.getContextPath()%>/welcome/imageCode.action" 
                    alt="验证码" title="点击更换" onclick="updateImg(this)"/></td>  
                    <td><span class="required"></span></td>              
                </tr>            
                <tr>
                    <td></td>	
                    <td class="login_button" colspan="2">
						<input  type="image" src="../images/login_btn.png"/>
                    </td>    
                    <td><span class="required">${msg}</span></td>                
                </tr>
            </table>
            </form>
        </div>
    </body>
</html>
