<%@page pageEncoding="UTF-8"  contentType="text/html; charset=UTF-8"
isELIgnored="false"%>
<%@taglib uri="/struts-tags" prefix="s" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>NetCTOSS</title>
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global.css" />
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global_color.css" />
    	<script type="text/javascript">
    		function load(){
    			document.getElementById("account").className="account_on";
    		}
    	</script>
    </head>
    <body onload="load();">
        <!--Logo区域开始-->
        <div id="header">
            <img src="../images/logo.png" alt="logo" class="left" />
            <a href="#">[退出]</a>            
        </div>
        <!--Logo区域结束-->
        <!--导航区域开始-->
         <%@include file="../navigator/navigator.jsp" %>
        <!--导航区域结束-->
        <!--主要区域开始-->
        <div id="main">            
            <form action="" method="" class="main_form">
                <!--必填项-->
                <div class="text_info clearfix"><span>账务账号ID：</span></div>
                <div class="input_info"><input type="text" value="${a.id}" readonly="readonly" class="readonly" /></div>
                <div class="text_info clearfix"><span>姓名：</span></div>
                <div class="input_info"><input type="text" value="${a.realName}" readonly="readonly" class="readonly" /></div>
                <div class="text_info clearfix"><span>身份证：</span></div>
                <div class="input_info">
                    <input type="text" value="${a.idcardNo}" readonly="readonly" class="readonly" />
                </div>
                <div class="text_info clearfix"><span>登录账号：</span></div>
                <div class="input_info">
                    <input type="text" value="${a.loginName}" readonly="readonly" class="readonly" />
                </div>                   
                <div class="text_info clearfix"><span>电话：</span></div>
                <div class="input_info">
                    <input type="text" class="width200 readonly" readonly="readonly" value="${a.telephone}" />
                </div>
                <div class="text_info clearfix"><span>推荐人账务账号ID：</span></div>
                <div class="input_info"><input type="text" readonly="readonly" class="readonly" value="${a.recommenderId}" /></div>
                <div class="text_info clearfix"><span>推荐人身份证号码：</span></div>
                <div class="input_info"><input type="text" readonly="readonly" class="readonly" value="${recomenderIdNO}" /></div>
                <div class="text_info clearfix"><span>状态：</span></div>
                <div class="input_info">
                	<s:select name="a.status"  disabled="disabled" list="#{'0':'开通','1':'暂停','2':'删除'}"></s:select>
                </div>                    
                <div class="text_info clearfix"><span>开通/暂停/删除时间：</span></div>
                <div class="input_info"><input type="text" readonly="readonly" class="readonly" value="${a.pauseDate}" /></div>

                <div class="text_info clearfix"><span>上次登录时间：</span></div>
                <div class="input_info"><input type="text" readonly="readonly" class="readonly" value="${a.lastLoginTime}" /></div>
                <div class="text_info clearfix"><span>上次登录IP：</span></div>
                <div class="input_info"><input type="text" readonly="readonly" class="readonly" value="${a.lastLoginIp}" /></div>
                <!--可选项数据-->
                <div class="text_info clearfix"><span>生日：</span></div>
                <div class="input_info">
                    <input type="text" readonly="readonly" class="readonly" value="${a.birthDate}" />
                </div>
                <div class="text_info clearfix"><span>Email：</span></div>
                <div class="input_info">
                    <input type="text" class="width350 readonly" readonly="readonly" value="${a.email}" />
                </div> 
                <div class="text_info clearfix"><span>职业：</span></div>
                <div class="input_info">
                <s:select name="a.occupation" disabled="disabled" list="#{'0':'干部','1':'学生','2':'技术人员','3':'其他'}"></s:select>
                </div>
                <div class="text_info clearfix"><span>性别：</span></div>
                <div class="input_info fee_type">
                	<s:radio name="a.gendar" disabled="disabled" list="#{'1':'男','0':'女'}"></s:radio>
                </div> 
                <div class="text_info clearfix"><span>通信地址：</span></div>
                <div class="input_info"><input type="text" class="width350 readonly" readonly="readonly" value="${a.mailaddress}" /></div> 
                <div class="text_info clearfix"><span>邮编：</span></div>
                <div class="input_info"><input type="text" class="readonly" readonly="readonly" value="${a.zipcode}" /></div> 
                <div class="text_info clearfix"><span>QQ：</span></div>
                <div class="input_info"><input type="text" class="readonly" readonly="readonly" value="${a.qq}" /></div>                
                <!--操作按钮-->
                <div class="button_info clearfix">
                    <input type="button" value="返回" class="btn_save" onclick="location.href='findAccount';" />
                </div>
            </form>  
        </div>
        <!--主要区域结束-->
        <div id="footer">
        </div>
    </body>
</html>
