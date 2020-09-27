<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@taglib uri="/struts-tags" prefix="s" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>NetCTOSS</title>
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global.css" />
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global_color.css" />
        <script language="javascript" type="text/javascript">
            //保存成功的提示信息
            function showResult() {
                showResultDiv(true);
                window.setTimeout("showResultDiv(false);", 3000);
            }
            function showResultDiv(flag) {
                var divResult = document.getElementById("save_result_info");
                if (flag)
                    divResult.style.display = "block";
                else
                    divResult.style.display = "none";
            }
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
            <!--保存操作的提示信息-->
            <div id="save_result_info" class="save_fail">资费修改失败！数据并发错误。</div>
            <form action="updateService" method="post" class="main_form">
                <!--必填项-->
                <div class="text_info clearfix"><span>业务账号ID：</span></div>
                <div class="input_info">
                	<input type="text" name="sud.serviceId" readonly="readonly" class="readonly" value="${s.id}"/>
                </div>
                <div class="text_info clearfix"><span>OS 账号：</span></div>
                <div class="input_info">
                	<input type="text" readonly="readonly" class="readonly" value="${s.osUsername}"/>
                </div>
                <div class="text_info clearfix"><span>服务器 IP：</span></div>
                <div class="input_info">
                	<input  type="text" readonly="readonly" class="readonly" value="${s.unixHost}"/>
                </div>
                <div class="text_info clearfix"><span>资费类型：</span></div>
                <div class="input_info">
                	<s:select name="sud.costId" list="costs" listKey="id" listValue="name" cssClass="width150"></s:select>
                    <div class="validate_msg_long">请修改资费类型，或者取消修改操作。</div>                      
                </div>
                <!--操作按钮-->
                <div class="button_info clearfix">
                    <input type="submit" value="保存" class="btn_save" />
                    <input type="button" value="取消" class="btn_save" onclick="location='findService'"/>
                </div>

                
                <p>业务说明：<br />
                1、修改资费后，点击保存，并未真正修改数据库中的数据；<br />
                2、提交操作到消息队列；<br />
                3、每月月底由程序自动完成业务所关联的资费；</p>
                
            </form>  
        </div>
        <!--主要区域结束-->
        <div id="footer">
        </div>
    </body>
</html>
