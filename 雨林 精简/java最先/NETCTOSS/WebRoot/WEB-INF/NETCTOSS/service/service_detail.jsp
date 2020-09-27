<%@page pageEncoding="UTF-8"%>
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
    			document.getElementById("service").className="service_on";
    		}
    	</script>
    </head>
    <body onload="load();">
        <!--Logo区域开始-->
        <div id="header">
            <img src="../images/logo.png" alt="logo" class="left"/>
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
                <div class="text_info clearfix"><span>业务账号ID：</span></div>
                <div class="input_info"><input type="text" value="${s.id}" readonly="readonly" class="readonly" /></div>
                <div class="text_info clearfix"><span>账务账号ID：</span></div>
                <div class="input_info"><input type="text" value="${s.accountId}" readonly="readonly" class="readonly" /></div>
                <div class="text_info clearfix"><span>客户姓名：</span></div>
                <div class="input_info"><input type="text" readonly="readonly" class="readonly" value="${s.realName}" /></div>
                <div class="text_info clearfix"><span>身份证号码：</span></div>
                <div class="input_info"><input type="text" readonly="readonly" class="readonly" value="${s.idcardNo}" /></div>
                <div class="text_info clearfix"><span>服务器 IP：</span></div>
                <div class="input_info"><input type="text" value="${s.unixHost}" readonly="readonly" class="readonly" /></div>
                <div class="text_info clearfix"><span>OS 账号：</span></div>
                <div class="input_info"><input type="text" value="${s.osUsername}" readonly="readonly" class="readonly" /></div>
                <div class="text_info clearfix"><span>状态：</span></div>
                <div class="input_info">
                   <s:select name="s.status" list="#{'0':'开通','1':'暂停','2':'删除'}" disabled="true"></s:select>                   
                </div>
                <div class="text_info clearfix"><span>开通时间：</span></div>
                <div class="input_info"><input type="text" readonly="readonly" value="${s.createDate}" class="readonly" /></div>
                <div class="text_info clearfix"><span>资费 ID：</span></div>
                <div class="input_info"><input type="text" class="readonly" value="${s.costId}" readonly="readonly" /></div>
                <div class="text_info clearfix"><span>资费名称：</span></div>
                <div class="input_info"><input type="text" readonly="readonly" value="${s.costName}" class="width200 readonly" /></div>
                <div class="text_info clearfix"><span>资费说明：</span></div>
                <div class="input_info_high">
                    <textarea class="width300 height70 readonly" readonly="readonly">${s.descr}</textarea>
                </div>  
                <!--操作按钮-->
                <div class="button_info clearfix">
                    <input type="button" value="返回" class="btn_save" onclick="location.href='findService';" />
                </div>
            </form>
        </div>
        <!--主要区域结束-->
        <div id="footer">
        </div>
    </body>
</html>
