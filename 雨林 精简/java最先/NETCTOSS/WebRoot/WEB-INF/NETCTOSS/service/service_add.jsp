<%@page pageEncoding="UTF-8"%>
<%@taglib uri="/struts-tags" prefix="s" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>NetCTOSS</title>
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global.css" />
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global_color.css" />
        <script type="text/javascript" src="../js/jquery-1.4.3.js"></script>
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

            //自动查询账务账号
            function searchAccounts() {
            	var idcardNo=$("#idcardNo").val();
            	if(idcardNo==null||idcardNo==""){
            		$('#idcard_msg').addClass('error_msg').html('请输入身份证号');
            		return;
            	}
            	var reg=/^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{4}$/;
            	if(!reg.test(idcardNo)){
            			$('#idcard_msg').addClass('error_msg').html('身份证号码格式不对，请重新输入');
            			return;
            	}
            	$.post(
            		'../account/searchRec',
            		{'idcardNo':idcardNo},
            		function(data){
            			if(data!=null){
            				$('#accountId').val(data.id);
            				$('#loginName').val(data.loginName);
            				$('#idcard_msg').removeClass('error_msg').html('');
            			}else{
            				$('#accountId').val('');
            				$('#loginName').val('');
            				$('#idcard_msg').addClass('error_msg').html('没有此身份证号对应的账户');
            			}
            		}
            	);
            }
            $(function(){
            	document.getElementById("service").className="service_on";
            });
        </script>
    </head>
    <body>
        <!--Logo区域开始-->
        <div id="header">
            <img src="../images/logo.png" alt="logo" class="left"/>
            <a href="../welcome/toLogin">[退出]</a>            
        </div>
        <!--Logo区域结束-->
        <!--导航区域开始-->
        <%@include file="../navigator/navigator.jsp" %>
        <!--导航区域结束-->
        <!--主要区域开始-->
        <div id="main">
            <!--保存操作的提示信息-->
            <div id="save_result_info" class="save_fail">保存失败！192.168.0.23服务器上已经开通过 OS 账号 “mary”。</div>
            <form action="saveService" method="post" class="main_form">
                <!--内容项-->
                <div class="text_info clearfix"><span>身份证：</span></div>
                <div class="input_info">
                    <input type="text"  class="width180" id="idcardNo"/>
                    <input type="hidden" name="s.accountId" id="accountId"/>
                    <input type="button" value="查询账务账号" class="btn_search_large" onclick="searchAccounts();"/>
                    <span class="required">*</span>
                    <div class="validate_msg_short" id="idcard_msg" ></div>
                </div>
                <div class="text_info clearfix"><span>账务账号：</span></div>
                <div class="input_info">
                    <input type="text" readonly="readonly" class="readonly" id="loginName"/>
                    <span class="required">*</span>
                    <div class="validate_msg_long"></div>
                </div>
                <div class="text_info clearfix"><span>资费类型：</span></div>
                <div class="input_info">
                	<s:select name="s.costId" list="costs" listKey="id" listValue="name"></s:select>
                </div> 
                <div class="text_info clearfix"><span>服务器 IP：</span></div>
                <div class="input_info">
                    <input type="text" name="s.unixHost" value=""  />
                    <span class="required">*</span>
                    <div class="validate_msg_long">15 长度，符合IP的地址规范</div>
                </div>                   
                <div class="text_info clearfix"><span>登录 OS 账号：</span></div>
                <div class="input_info">
                    <input type="text" name="s.osUsername" value=""  />
                    <span class="required">*</span>
                    <div class="validate_msg_long">8长度以内的字母、数字和下划线的组合</div>
                </div>
                <div class="text_info clearfix"><span>密码：</span></div>
                <div class="input_info">
                    <input type="password" name="s.loginPasswd" />
                    <span class="required">*</span>
                    <div class="validate_msg_long">30长度以内的字母、数字和下划线的组合</div>
                </div>
                <div class="text_info clearfix"><span>重复密码：</span></div>
                <div class="input_info">
                    <input type="password"  />
                    <span class="required">*</span>
                    <div class="validate_msg_long">两次密码必须相同</div>
                </div>     
                <!--操作按钮-->
                <div class="button_info clearfix">
                    <input type="submit" value="保存" class="btn_save"  />
                    <input type="button" value="取消" class="btn_save" onclick="location.href='findService';"/>
                </div>
            </form>
        </div>
        <!--主要区域结束-->
        <div id="footer">
        </div>
    </body>
</html>
