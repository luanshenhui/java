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
        	var flag=false;
        	$(function(){
        		document.getElementById("account").className="account_on";
        		$("#loginPassword").blur(function(){
        			var pwd=$(this).val();
        			if(pwd==null||pwd==""){
        				$("#pwd_msg").addClass("error_msg").html("密码不能为空");
        				flag=false;
        				return;
        			}
        			var reg=/^\w{4,8}$/;
        			if(!reg.test(pwd)){
        				$("#pwd_msg").addClass("error_msg").html("密码格式不对,请重新输入");
        				flag=false;
        				return;
        			}
        			flag=true;
        			$("#pwd_msg").removeClass("error_msg").html("4~8位的字母、数字和下划线的组合");
        		});
        		$("#loginPasswordRep").blur(function(){
        			var pwd=$("#loginPassword").val();
        			var repPwd=$(this).val();
        			if(repPwd!=pwd){
        				$("#pwd_repeate").addClass("error_msg");
        				flag=false;
        				return;
        			}
        			flag=true;
        			$("#pwd_repeate").removeClass("error_msg");
        		});
        		$("#checkIdNo").blur(function(){
        			var idNo=$(this).val();
        			if(idNo==null||idNo==""){
        				$("#idcardNoMsg").addClass("error_msg").html("身份证号不能为空");
        				flag=false;
        				return;
        			}
        			var reg=/^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{4}$/;
        			if(!reg.test(idNo)){
        				$("#idcardNoMsg").addClass("error_msg").html("请输入正确的身份证号");
        				flag=false;
        				return;
        			}
        			$("#idcardNoMsg").removeClass("error_msg").html("正确的身份证号码格式");
        			var year=idNo.substring(6,10);
        			var month=idNo.substring(10,12);
        			var day=idNo.substring(12,14);
        			var birthday=year+"-"+month+"-"+day;
        			$("#birthday").val(birthday);
        			flag=true;
        		});
        		$("#recommenderIdcardNo").blur(function(){
        			var idcardNo=$(this).val();
        			if(idcardNo==null||idcardNo==""){
        				$("#check_rec").removeClass("error_msg").html("正确的身份证号码格式");
        				
        				return;
        			}
        			var reg=/^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{4}$/;
        			if(!reg.test(idcardNo)){
        				$("#check_rec").addClass("error_msg").html("请输入正确的身份证号");
        				flag=false;
        				return;
        			}
        			$.post(
        				'searchRec',
        				{'idcardNo':idcardNo},
        				function(data){
        					if(data!=null){
        						flag=true;
        						$("#recommenderId").val(data.id);
        					}else{
        						flag=false;
        						$("#check_rec").addClass("error_msg").html("该推荐人不存在,请重新输入");
        					}
        				}
        			);
        			flag=true;
        			$("#check_rec").removeClass("error_msg").html("正确的身份证号码格式");
        		});
        		$("form").submit(function(){
        			showResult();
        			return flag;
        		});
        	});
            //保存成功的提示信息
            function showResult() {
                showResultDiv(flag);
                window.setTimeout(function(){
                	$("#save_result_info").hide();
                }, 3000);
                return flag;
            }
            function showResultDiv(flag) {
                var divResult = document.getElementById("save_result_info");
                if (!flag)
                    divResult.style.display = "block";
                else
                    divResult.style.display = "none";
            }

            //显示选填的信息项
            function showOptionalInfo(imgObj) {
                var div = document.getElementById("optionalInfo");
                if (div.className == "hide") {
                    div.className = "show";
                    imgObj.src = "../images/hide.png";
                }
                else {
                    div.className = "hide";
                    imgObj.src = "../images/show.png";
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
            <div id="save_result_info" class="save_fail">保存失败，表单验证失败！</div>
            <form action="addAccount" method="post" class="main_form">
                <!--必填项-->
                <div class="text_info clearfix"><span>姓名：</span></div>
                <div class="input_info">
                    <input type="text" name="a.realName" value="" />
                    <span class="required">*</span>
                    <div class="validate_msg_long">20长度以内的汉字、字母和数字的组合</div>
                </div>
                <div class="text_info clearfix"><span>身份证：</span></div>
                <div class="input_info">
                    <input type="text" name="a.idcardNo" value="" id="checkIdNo"/>
                    <span class="required">*</span>
                    <div class="validate_msg_long" id="idcardNoMsg">正确的身份证号码格式</div>
                </div>
                <div class="text_info clearfix"><span>登录账号：</span></div>
                <div class="input_info">
                    <input type="text" name="a.loginName" value=""  />
                    <span class="required">*</span>
                    <div class="validate_msg_long">30长度以内的字母、数字和下划线的组合</div>
                </div>
                <div class="text_info clearfix"><span>密码：</span></div>
                <div class="input_info">
                    <input type="password" name="a.loginPassword" id="loginPassword"/>
                    <span class="required">*</span>
                    <div class="validate_msg_long" id="pwd_msg">4~8位的字母、数字和下划线的组合</div>
                </div>
                <div class="text_info clearfix"><span>重复密码：</span></div>
                <div class="input_info">
                    <input type="password"  id="loginPasswordRep"/>
                    <span class="required">*</span>
                    <div class="validate_msg_long" id="pwd_repeate">两次密码必须相同</div>
                </div>     
                <div class="text_info clearfix"><span>电话：</span></div>
                <div class="input_info">
                    <input type="text" name="a.telephone" class="width200"/>
                    <span class="required">*</span>
                    <div class="validate_msg_medium">正确的电话号码格式：手机或固话</div>
                </div>                
                <!--可选项-->
                <div class="text_info clearfix"><span>可选项：</span></div>
                <div class="input_info">
                    <img src="../images/show.png" alt="展开" onclick="showOptionalInfo(this);" />
                </div>
                <div id="optionalInfo" class="hide">
                    <div class="text_info clearfix"><span>推荐人身份证号码：</span></div>
                    <div class="input_info">
                        <input type="text" id="recommenderIdcardNo"/>
                        <div class="validate_msg_long" id="check_rec">正确的身份证号码格式</div>
                        <input type="hidden" name="a.recommenderId" id="recommenderId"/>
                    </div>
                    <div class="text_info clearfix"><span>生日：</span></div>
                    <div class="input_info">
                        <input type="text" name="a.birthDate" value="" readonly="readonly" class="readonly" id="birthday" />
                    </div>
                    <div class="text_info clearfix"><span>Email：</span></div>
                    <div class="input_info">
                        <input type="text" name="a.email" class="width350"/>
                        <div class="validate_msg_tiny">50长度以内，合法的 Email 格式</div>
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
                        <input type="text" name="a.mailaddress" class="width350"/>
                        <div class="validate_msg_tiny">50长度以内</div>
                    </div> 
                    <div class="text_info clearfix"><span>邮编：</span></div>
                    <div class="input_info">
                        <input name="a.zipcode" type="text"/>
                        <div class="validate_msg_long">6位数字</div>
                    </div> 
                    <div class="text_info clearfix"><span>QQ：</span></div>
                    <div class="input_info">
                        <input name="a.qq" type="text"/>
                        <div class="validate_msg_long">5到13位数字</div>
                    </div>                
                </div>
                <!--操作按钮-->
                <div class="button_info clearfix">
                    <input type="submit" value="保存" class="btn_save"  />
                    <input type="button" value="取消" class="btn_save" onclick="location='findAccount'"/>
                </div>
            </form>  
        </div>
        <!--主要区域结束-->
        <div id="footer">
        </div>
    </body>
</html>
