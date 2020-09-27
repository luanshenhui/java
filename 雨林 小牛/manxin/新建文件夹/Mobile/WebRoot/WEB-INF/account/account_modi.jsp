<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@taglib uri="/struts-tags" prefix="s" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>NetCTOSS</title>
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global.css" />
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global_color.css" />
        <script type="text/javascript" src="../js/jquery-1.4.3.js"></script>
        <script language="javascript" type="text/javascript">
        var nameFlag = false;
            $(function(){
            	$("#recommender_no").blur(function(){
            		var recommender = $(this).val();
            		
            		if(recommender==null||recommender==""){
            			nameFlag = false;
            			$("#recommenderMsg").text("推荐人ID不能为空");
            			$("#recommenderMsg").addClass("error_msg");
            			return;
            		}

            		//查询是否存在
            		$.post(
            			"checkRecommender",{"recommender":recommender},function(data){
            				var repeat = data;
            				if(!repeat){
            					//不存在
            					$("#recommenderMsg").text("输入的推荐人身份证号不存在");
            					$("#recommenderMsg").addClass("error_msg");
            					nameFlag = false;
            				}else{
            					$("#recommenderMsg").text("正确的身份证号码格式");
            					$("#recommenderMsg").removeClass("error_msg");
            					nameFlag = true;
            				}
            			}
            		);
            	});
            });
            
            //保存成功的提示信息
            function showResult() {
	            if(!nameFlag){
	            		return;
	            }
            	document.forms[0].submit();
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
            
            //显示生日
            function showBrithday(){
            	var idnum = document.getElementById("idcard_no").value;
            	var birthdayYear = idnum.substring(6, 10);
				var birthdayMon = idnum.substring(10, 12);
				var birthdayDay = idnum.substring(12, 14);
				var birth = birthdayYear + "-" + birthdayMon + "-" + birthdayDay;
				document.getElementById("birth").value = birth;
            }

            //显示修改密码的信息项
            function showPwd(chkObj) {
                if (chkObj.checked)
                    document.getElementById("divPwds").style.display = "block";
                else
                    document.getElementById("divPwds").style.display = "none";
            }
        </script>
    </head>
    <body>
        <!--Logo区域开始-->
        <div id="header">
            <img src="../images/logo.png" alt="logo" class="left"/>
            <a href="#">[退出]</a>            
        </div>
        <!--Logo区域结束-->
        <!--导航区域开始-->
        <div id="navi">
            <ul id="menu">
                <li><a href="../index.html" class="index_off"></a></li>
                <li><a href="../role/role_list.html" class="role_off"></a></li>
                <li><a href="../admin/admin_list.html" class="admin_off"></a></li>
                <li><a href="../fee/fee_list.html" class="fee_off"></a></li>
                <li><a href="../account/account_list.html" class="account_on"></a></li>
                <li><a href="../service/service_list.html" class="service_off"></a></li>
                <li><a href="../bill/bill_list.html" class="bill_off"></a></li>
                <li><a href="../report/report_list.html" class="report_off"></a></li>
                <li><a href="../user/user_info.html" class="information_off"></a></li>
                <li><a href="../user/user_modi_pwd.html" class="password_off"></a></li>
            </ul>
        </div>
        <!--导航区域结束-->
        <!--主要区域开始-->
        <div id="main">  
            <!--保存成功或者失败的提示消息-->          
            <div id="save_result_info" class="save_fail">保存失败，旧密码错误！</div>
            <form action="Up?id=<s:property value="account.id"/>" method="post" class="main_form">
                    <!--必填项-->
                    <div class="text_info clearfix"><span>账务账号ID：</span></div>
                    <div class="input_info">
                        <input type="text" name="id" disabled="disabled" value="<s:property value="account.id"/>" 
                        readonly class="readonly" />
                    </div>
                    <div class="text_info clearfix"><span>姓名：</span></div>
                    <div class="input_info">
                        <input type="text" value="<s:property value="account.real_name"/>" name="real_name"/>
                        <span class="required">*</span>
                        <div class="validate_msg_long error_msg">20长度以内的汉字、字母和数字的组合</div>
                    </div>
                    <div class="text_info clearfix"><span>身份证：</span></div>
                    <div class="input_info">
                        <input type="text" value="<s:property value="account.idcard_no"/>" name="idcard_no" 
                        	readonly class="readonly" id="idcard_no" onblur="showBrithday();"/>
                    </div>
                    <div class="text_info clearfix"><span>登录账号：</span></div>
                    <div class="input_info">
                        <input type="text" name="login_name" value="<s:property value="account.login_name"/>" readonly class="readonly"  />                        
                        <div class="change_pwd">
                            <input id="chkModiPwd" type="checkbox" onclick="showPwd(this);" />
                            <label for="chkModiPwd">修改密码</label>
                        </div>
                    </div>
                    <!--修改密码部分-->
                    <div id="divPwds">
                        <div class="text_info clearfix"><span>旧密码：</span></div>
                        <div class="input_info">
                            <input type="password" name="login_passwd" value="<s:property value="account.login_passwd"/>"/>
                            <span class="required">*</span>
                            <div class="validate_msg_long">30长度以内的字母、数字和下划线的组合</div>
                        </div>
                        <div class="text_info clearfix"><span>新密码：</span></div>
                        <div class="input_info">
                            <input type="password" name="login_newpwd" />
                            <span class="required">*</span>
                            <div class="validate_msg_long">30长度以内的字母、数字和下划线的组合</div>
                        </div>
                        <div class="text_info clearfix"><span>重复新密码：</span></div>
                        <div class="input_info">
                            <input type="password" name="pwd" />
                            <span class="required">*</span>
                            <div class="validate_msg_long">两次密码必须相同</div>
                        </div>  
                    </div>                   
                    <div class="text_info clearfix"><span>电话：</span></div>
                    <div class="input_info">
                        <input type="text" class="width200" name="telephone" value="<s:property value="account.telephone"/>"/>
                        <span class="required">*</span>
                        <div class="validate_msg_medium error_msg">正确的电话号码格式：手机或固话</div>
                    </div>
                    <div class="text_info clearfix"><span>推荐人身份证号码：</span></div>
                    <div class="input_info">
                        <input type="text" name="recommender_no" id="recommender_no" value="<s:property value="recommender_no"/>" />
                        <div class="validate_msg_long error_msgs" id="recommenderMsg">正确的身份证号码格式</div>
                        <input type="hidden" name="account.recommender_id" id="recommender_id"/>
                    </div>
                    <div class="text_info clearfix"><span>生日：</span></div>
                    <div class="input_info">
                        <input type="text" value="<s:property value="account.birthdate"/>"
                         id="birth" name="birthday" readonly class="readonly" />
                    </div>
                    <div class="text_info clearfix"><span>Email：</span></div>
                    <div class="input_info">
                        <input type="text" class="width200" name="email" value="<s:property value="account.email"/>"/>
                        <div class="validate_msg_medium">50长度以内，合法的 Email 格式</div>
                    </div> 
                    <div class="text_info clearfix"><span>职业：</span></div>
                    <div class="input_info">
                    <s:select name="occupation" list="{'干部','学生','技术人员','其他'}">
                       
                    </s:select>                      
                    </div>
                    <div class="text_info clearfix"><span>性别：</span></div>
                    <div class="input_info fee_type">
                        <input type="radio" name="gender" value="0" checked="checked" id="female" />
                        <label for="female">女</label>
                        <input type="radio" name="gender" id="male" value="1" />
                        <label for="male">男</label>
                    </div> 
                    <div class="text_info clearfix"><span>通信地址：</span></div>
                    <div class="input_info">
                        <input type="text" class="width350" value="<s:property value="account.mailaddress"/>" name="mailaddress"/>
                        <div class="validate_msg_tiny">50长度以内</div>
                    </div> 
                    <div class="text_info clearfix"><span>邮编：</span></div>
                    <div class="input_info">
                        <input type="text" name="zipcode" value="<s:property value="account.zipcode"/>"/>
                        <div class="validate_msg_long">6位数字</div>
                    </div> 
                    <div class="text_info clearfix"><span>QQ：</span></div>
                    <div class="input_info">
                        <input type="text" name="qq" value="<s:property value="account.qq"/>"/>
                        <div class="validate_msg_long">5到13位数字</div>
                    </div>                
                    <!--操作按钮-->
                    <div class="button_info clearfix">
                        <input type="button" value="保存" class="btn_save" onclick="showResult();" />
                        <input type="button" value="取消" class="btn_save" />
                    </div>
                </form>  
        </div>
        <!--主要区域结束-->
        <div id="footer">
            
        </div>
    </body>
</html>
