<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>NetCTOSS</title>
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global.css" />
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global_color.css" />
        <script type="text/javascript" src="../js/jquery-1.4.3.js"></script>
        <script language="javascript" type="text/javascript">
        	var isCheck=false;
        	var flag=false;
        	$(function(){
        		document.getElementById("account").className="account_on";
        		$("#oldPwd").blur(function(){
        			var id=$("#account_id").val();
        			var oldPwd=$(this).val();
        			if(oldPwd==null||oldPwd==""){
        				$("#oldPwd_msg").addClass("error_msg").html("旧密码不能为空");
        				if(isCheck){
        					flag=false;
        				}else{
        					flag=true;
        				}
        				return;
        			}
        			$.post(
        			'validPwd',
        			{'id':id,'oldPwd':oldPwd},
        			function(data){
        				if(data){
        					flag=true;
        				$("#oldPwd_msg").removeClass("error_msg")
        				.html("4~8长度的字母、数字和下划线的组合");
        				}else{
        					flag=false;
        					$("#oldPwd_msg").addClass("error_msg")
        					.html("旧密码错误，请重新输入");
        				}
        			}
        			);
        		});
        		$('#newPwd').blur(function(){
        			var newPwd=$(this).val();
        			if(newPwd==null||newPwd==""){
        				$('#newPwd_msg').addClass('error_msg').html('新密码不能为空');
        				if(isCheck){
        					flag=false;
        				}else{
        					flag=true;
        				}
        				return;
        			}
        			var reg=/^\w{4,8}$/;
        			if(reg.test(newPwd)){
        				flag=true;
        				$('#newPwd_msg').removeClass('error_msg')
        				.html('4~8长度的字母、数字和下划线的组合');
        			}else{
        				flag=false;
        				$('#newPwd_msg').addClass('error_msg')
        				.html('新密码格式错误，请重新输入');
        			}
        		});
        		$('#repPwd').blur(function(){
        			var repPwd=$(this).val();
        			var newPwd=$('#newPwd').val();
        			if(repPwd!=newPwd){
        				flag=false;
        				$('#repPwd_msg').addClass('error_msg')
        				.html('两次输入的密码不一致，请重新输入');
        			}else{
        				flag=true;
        				$('#repPwd_msg').removeClass('error_msg')
        				.html('两次密码必须相同');
        			}
        		});
        		$('#recIdCard').blur(function(){
        			var recIdCard=$(this).val();
        			if(recIdCard==null||recIdCard==""){
        				$('#recIdCard_msg').removeClass('error_msg')
        				.html('正确的身份证号码格式');
        				flag=true;
        				return;
        			}
        			var reg=/^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{4}$/;
        			if(!reg.test(recIdCard)){
        				//alert(1);
        				$("#recIdCard_msg").addClass("error_msg")
        				.html("请输入正确的身份证号");
        				flag=false;
        				return;
        			}
        			$.post(
        				'searchRec',
        				{'idcardNo':recIdCard},
        				function(data){
        					if(data!=null){
        						flag=true;
        						$("#recommenderId").val(data.id);
        					}else{
        						flag=false;
        						$("#recIdCard_msg").addClass("error_msg").html("该推荐人不存在,请重新输入");
        					}
        				}
        			);
        			flag=true;
        			$("#check_rec").removeClass("error_msg").html("正确的身份证号码格式");
        		});
        		$("form").submit(function(){
        			showResult();
        			//return flag;
        		});
        	});
            //保存成功的提示信息
            function showResult() {
                showResultDiv(flag);
                window.setTimeout(function(){
                	$("#save_result_info").hide();
                }, 3000);
            }
            function showResultDiv(check) {
                var divResult = document.getElementById("save_result_info");
                if (check){
                	divResult.style.display = "block";
                }
                else{
                    divResult.style.display = "none";
                    }
            }

            //显示修改密码的信息项
            function showPwd(chkObj) {
                if (chkObj.checked){
                	  document.getElementById("divPwds").style.display = "block";
                	  isCheck=true;
                }
                  
                else{
                	 document.getElementById("divPwds").style.display = "none";
                	 isCheck=false;
                }
                   
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
         <%@include file="../navigator/navigator.jsp" %>
        <!--导航区域结束-->
        <!--主要区域开始-->
        <div id="main">  
            <!--保存成功或者失败的提示消息-->          
            <div id="save_result_info" class="save_fail">保存失败，表单验证不通过！</div>
            <form action="modifyAccount" method="post" class="main_form">
                    <!--必填项-->
                    <div class="text_info clearfix"><span>账务账号ID：</span></div>
                    <div class="input_info">
                    	<s:textfield name="a.id" id="account_id" readonly="true" cssClass="readonly"></s:textfield>
                    </div>
                    <div class="text_info clearfix"><span>姓名：</span></div>
                    <div class="input_info">
                    	<s:textfield name="a.realName"></s:textfield>
                        <span class="required">*</span>
                        <div class="validate_msg_long error_msg">20长度以内的汉字、字母和数字的组合</div>
                    </div>
                    <div class="text_info clearfix"><span>身份证：</span></div>
                    <div class="input_info">
                    	<s:textfield name="a.idcardNo" readonly="true" cssClass="readonly"></s:textfield>
                    </div>
                    <div class="text_info clearfix"><span>登录账号：</span></div>
                    <div class="input_info">
                    	<s:textfield name="a.loginName" readonly="true" cssClass="readonly"></s:textfield>
                        <div class="change_pwd">
                            <input id="chkModiPwd" type="checkbox" onclick="showPwd(this);" />
                            <label for="chkModiPwd">修改密码</label>
                        </div>
                    </div>
                    <!--修改密码部分-->
                    <div id="divPwds">
                        <div class="text_info clearfix"><span>旧密码：</span></div>
                        <div class="input_info">
                            <input type="password"  id="oldPwd"/>
                            <span class="required">*</span>
                            <div class="validate_msg_long" id="oldPwd_msg">4~8长度的字母、数字和下划线的组合</div>
                        </div>
                        <div class="text_info clearfix"><span>新密码：</span></div>
                        <div class="input_info">
                        	<s:password  name="a.loginPassword" id="newPwd" />
                            <span class="required">*</span>
                            <div class="validate_msg_long" id="newPwd_msg">4~8长度的字母、数字和下划线的组合</div>
                        </div>
                        <div class="text_info clearfix"><span>重复新密码：</span></div>
                        <div class="input_info">
                            <input type="password"  id="repPwd"/>
                            <span class="required">*</span>
                            <div class="validate_msg_long" id="repPwd_msg">两次密码必须相同</div>
                        </div>  
                    </div>                   
                    <div class="text_info clearfix"><span>电话：</span></div>
                    <div class="input_info">
                    	<s:textfield name="a.telephone" cssClass="width200"></s:textfield>
                        <span class="required">*</span>
                        <div class="validate_msg_medium error_msg">正确的电话号码格式：手机或固话</div>
                    </div>
                    <div class="text_info clearfix"><span>推荐人身份证号码：</span></div>
                    <div class="input_info">
                        <s:textfield name="recommenderIdCard" id="recIdCard"></s:textfield>
                        <s:hidden name="a.recommenderId" id="recommenderId"></s:hidden>
                        <div class="validate_msg_long error_msgs" id="recIdCard_msg">正确的身份证号码格式</div>
                    </div>
                    <div class="text_info clearfix"><span>生日：</span></div>
                    <div class="input_info">
                    	<s:textfield name="a.birthDate" readonly="true" cssClass="readonly">
                    		<s:param name="value">
                    			<s:date name="a.birthDate" format="yyyy-MM-dd"/>
                    		</s:param>
                    	</s:textfield>
                    </div>
                    <div class="text_info clearfix"><span>Email：</span></div>
                    <div class="input_info">
                    	<s:textfield name="a.email" cssClass="width200"></s:textfield>
                        <div class="validate_msg_medium">50长度以内，合法的 Email 格式</div>
                    </div> 
                    <div class="text_info clearfix"><span>职业：</span></div>
                    <div class="input_info">
                    	<s:select name="a.occupation" list="#{'0':'干部','1':'学生','2':'技术人员','3':'其他'}"></s:select>
                    </div>
                    <div class="text_info clearfix"><span>性别：</span></div>
                    <div class="input_info fee_type">
                      <s:radio name="a.gendar" list="#{'0':'女','1':'男'}"></s:radio>
                    </div> 
                    <div class="text_info clearfix"><span>通信地址：</span></div>
                    <div class="input_info">
                    	<s:textfield name="a.mailaddress" cssClass="width350"></s:textfield>
                        <div class="validate_msg_tiny">50长度以内</div>
                    </div> 
                    <div class="text_info clearfix"><span>邮编：</span></div>
                    <div class="input_info">
                    	<s:textfield name="a.zipcode"></s:textfield>
                        <div class="validate_msg_long">6位数字</div>
                    </div> 
                    <div class="text_info clearfix"><span>QQ：</span></div>
                    <div class="input_info">
                    	<s:textfield name="a.qq"></s:textfield>
                        <div class="validate_msg_long">5到13位数字</div>
                    </div>                
                    <!--操作按钮-->
                    <div class="button_info clearfix">
                        <input type="submit" value="保存" class="btn_save"  />
                        <input type="button" value="取消" class="btn_save" onclick="location='findAccount';"/>
                    </div>
                </form>  
        </div>
        <!--主要区域结束-->
        <div id="footer">
        </div>
    </body>
</html>
