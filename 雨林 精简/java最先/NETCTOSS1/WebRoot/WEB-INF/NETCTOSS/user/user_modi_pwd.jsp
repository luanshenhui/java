<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>NetCTOSS</title>
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global.css" />
        <link type="text/css" rel="stylesheet" media="all" href="../styles/global_color.css" />    
        <script type="text/javascript" src="../js/jquery-1.4.3.js"></script> 
        <script type="text/javascript">
        	function load(){
        		document.getElementById("password").className="password_on";
        	}
        	function validOldPwd(oldPwd){
        			if(oldPwd==null||oldPwd==""){
        				$("#oldPwd_msg").addClass("error_msg").html("旧密码不能为空");
        				return false;
        			}else{
        				$("#oldPwd_msg").removeClass("error_msg")
        				.html("30长度以内的字母、数字和下划线的组合");
        				return true;
        			}
        	}
        	function validNewPwd(newPwd){
        			if(newPwd==null||newPwd==""){
        				$("#newPwd_msg").addClass("error_msg")
        				.html("新密码不能为空");
        				return false;
        			}
        			var reg=/^\w{6,30}$/;
        			if(!reg.test(newPwd)){
        				$("#newPwd_msg").addClass("error_msg")
        				.html("新密码长度至少6位，不能超过30位");
        				return false;
        			}
        			$("#newPwd_msg").removeClass("error_msg")
        				.html("30长度以内的字母、数字和下划线的组合");
        			return true;
        	}
        	function validRepPwd(repPwd){
        			var newPwd=$("#newPwd").val();
        			if(repPwd!=newPwd){
        				$("#repPwd_msg").addClass("error_msg");
        				return false;
        			}else{
        				$("#repPwd_msg").removeClass("error_msg");
        				return true;
        			}
        	}
        	$(function(){
        		$("#showMsg").click(function(){
        			var oldPwd=$("#oldPwd").val();
        			var newPwd=$("#newPwd").val();
        			var repPwd=$("#repPwd").val();
        			var f1=validOldPwd(oldPwd);
        			var f2=validNewPwd(newPwd);
        			var f3=validRepPwd(repPwd);
        			if(f1&&f2&&f3){
        				$.post(
        					'../user/modiPwd',
        					{'oldPwd':oldPwd,
        					'newPwd':newPwd},
        					function(data){
        						if(data){
        							$("#save_result_info").css('display','block');
        							showResult();
        						}else{
        							$("#oldPwd").val("");
        							$("#newPwd").val("");
        							$("#repPwd").val("");
        							$("#save_result_info").css('display','block').removeClass("save_success")
        							.addClass("save_fail").html("保存失败，旧密码错误！");
        							showResult();
        						}
        					}
        				);
        				return f1&&f2&f3;
        			}
        		});
        	})
        	function showResult(){
        		window.setTimeout(function(){
        			$("#save_result_info").hide();
        		},3000);
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
        <div id="main" >      
            <!--保存操作后的提示信息：成功或者失败-->      
            <div id="save_result_info" class="save_success">保存成功！</div>
            <form action="" method="post" class="main_form">
                <div class="text_info clearfix"><span>旧密码：</span></div>
                <div class="input_info">
                    <input type="password" id="oldPwd" class="width200" onblur="validOldPwd(this.value);" /><span class="required">*</span>
                    <div class="validate_msg_medium" id="oldPwd_msg">30长度以内的字母、数字和下划线的组合</div>
                </div>
                <div class="text_info clearfix"><span>新密码：</span></div>
                <div class="input_info">
                    <input type="password" id="newPwd" class="width200"  onblur="validNewPwd(this.value);"/><span class="required">*</span>
                    <div class="validate_msg_medium" id="newPwd_msg">30长度以内的字母、数字和下划线的组合</div>
                </div>
                <div class="text_info clearfix"><span>重复新密码：</span></div>
                <div class="input_info">
                    <input type="password" class="width200" id="repPwd"  onblur="validRepPwd(this.value);"/><span class="required">*</span>
                    <div class="validate_msg_medium" id="repPwd_msg">两次新密码必须相同</div>
                </div>
                <div class="button_info clearfix">
                    <input type="button" value="保存" class="btn_save" id="showMsg" />
                    <input type="button" value="取消" class="btn_save" />
                </div>
            </form>  
        </div>
        <!--主要区域结束-->
        <div id="footer">
        </div>
    </body>
</html>
