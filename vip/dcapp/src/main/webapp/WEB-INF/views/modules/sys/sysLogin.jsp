<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>${fns:getConfig('productName')} 登录</title>
	<meta name="decorator" content="blank"/>
	<style type="text/css">
      html,body,table{background: url(../static/img/bg.jpg) no-repeat center;width:100%;height:100%;text-align:center; overflow: hidden!important;}
      .form-signin-heading{font-family:Helvetica, Georgia, Arial, sans-serif, 黑体;font-size:36px;margin-bottom:20px;color:#0663a2;}
      .form-signin{position:relative;text-align:left;width:480px;height:420px;padding:25px 29px 29px;margin:0 auto -30px;background: url(../static/img/login-bg.png) no-repeat center;}
      .form-signin .checkbox{margin-bottom:10px;color:#0663a2;} 
     /*  .form-signin .input-label{font-size:16px;line-height:23px;color:#999;} */
     .input-box{position: relative;margin:125px 35px 15px 76px;}
      .form-signin .input-block-level{width:330px; font-size:16px;height:45px;line-height:45px;margin-bottom:15px;border:1px solid #d6d6d6;padding: 7px 7px 7px 40px;*width:283px;*padding-bottom:0;_padding:7px 7px 9px 7px;line-height:20px;}
      .form-signin .input-block-level:focus{border:1px solid #5fb2ff; box-shadow:none;}
      .form-signin .btn.btn-large{font-size:16px;} 
      .form-signin #themeSwitch{position:absolute;right:15px;bottom:10px;}
      .form-signin div.validateCode {padding-bottom:15px;} 
      .btn-log{display:inline-block;float:right;width:175px !important;height:58px;line-height:58px; margin-top: 4px; margin-right:28px;font-size:16px;color:#fff;background:url(../static/img/login-btn.png) no-repeat center;}
     
     .btn-log:hover{background:url(../static/img/login-btn-ov.png) no-repeat center;}
      .logo{position: absolute;display:block;top:0;left:0;width: 45px;height: 45px;}
      .user{background:url(../static/img/icon-user.png) no-repeat center;}
      .pwd{top:60px;left:0;background:url(../static/img/icon-password.png) no-repeat center;}
      .mid{vertical-align:middle; color:#333; font-size:14px;}
      .header{height:80px;padding-top:20px;} 
      .alert{position:relative;width:300px;margin:0 auto;*padding-bottom:0px;}
      label.error{background:none;width:270px;font-weight:normal;color:inherit;margin:0;}
      .footer{color:#fff;}
      .footer a{color:#fff;}
      .txt{width:80px;}
      .checkbox-group{margin-top:18px;}
      .check-box-btn{ position: absolute;  bottom: 0;  left: 0; z-index: -10; opacity: 0;}
      .check-box-btn + .remember{ position: relative;display: block; width: 22px;height: 22px; border:1px solid #d5d5d5;}
      .remember-txt{color:#999;font-size:12px; position: absolute; bottom: 3px;; left: 30px; }
    /*  .check-box-btn:checked + .remember {background:url(../static/img/checkbox-select.png) no-repeat 2px 5px;}  */
     .check-box-btn-checked {background:url(../static/img/checkbox-select.png) no-repeat 2px 5px;}
    </style>
   <script src="/static/crypto-js/crypto-js.js" type="text/javascript"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#loginForm").validate({
				rules: {
					validateCode: {remote: "${pageContext.request.contextPath}/servlet/validateCodeServlet"}
				},
				messages: {
					username: {required: "请填写用户名."},password: {required: "请填写密码."},
					validateCode: {remote: "验证码不正确.", required: "请填写验证码."}
				},
				invalidHandler: function(e,v ) {
					
					if(!v.checkForm()){
						$("#password").val("");
					}
					
				  // $( "#summary" ).text( validator.numberOfInvalids() + " field(s) are invalid" );
				  },
				errorLabelContainer: "#messageBox",
				errorPlacement: function(error, element) {
					error.appendTo($("#loginError").parent());
				} 
			});
			//checkbox选中/为选中
			$('.check-box-btn').click(function(){
				if($("input[name='rememberMe']").attr("checked")){ 
					$('.remember').addClass("check-box-btn-checked")
				}else{
					$('.remember').removeClass("check-box-btn-checked")
					};
			});
			
			
		
		
		});
		// 如果在框架或在对话框中，则弹出提示并跳转到首页
		if(self.frameElement && self.frameElement.tagName == "IFRAME" || $('#left').length > 0 || $('.jbox').length > 0){
			alert('未登录或登录超时。请重新登录，谢谢！');
			top.location = "${ctx}";
		}
		
		        
        function base64_encode(str){
            var c1, c2, c3;
            var base64EncodeChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";        
            var i = 0, len= str.length, string = '';
         
            while (i < len){
                c1 = str.charCodeAt(i++) & 0xff;
                if (i == len){
                    string += base64EncodeChars.charAt(c1 >> 2);
                    string += base64EncodeChars.charAt((c1 & 0x3) << 4);
                    string += "==";
                    break;
                }
                c2 = str.charCodeAt(i++);
                if (i == len){
                    string += base64EncodeChars.charAt(c1 >> 2);
                    string += base64EncodeChars.charAt(((c1 & 0x3) << 4) | ((c2 & 0xF0) >> 4));
                    string += base64EncodeChars.charAt((c2 & 0xF) << 2);
                    string += "=";
                    break;
                }
                c3 = str.charCodeAt(i++);
                string += base64EncodeChars.charAt(c1 >> 2);
                string += base64EncodeChars.charAt(((c1 & 0x3) << 4) | ((c2 & 0xF0) >> 4));
                string += base64EncodeChars.charAt(((c2 & 0xF) << 2) | ((c3 & 0xC0) >> 6));
                string += base64EncodeChars.charAt(c3 & 0x3F)
            }
                return string
        };
			
		function submitCheck(){
			var password = $("#password").val();
			var passwordBASE64 = base64_encode(password);
			
			$("#password").val(passwordBASE64);
			$("#loginForm").submit();
			//	ornZ/d3AJQFHNBZBsQsLGw==	
		}
	</script>
</head>
<body>
	<!--[if lte IE 6]><br/><div class='alert alert-block' style="text-align:left;padding-bottom:10px;"><a class="close" data-dismiss="alert">x</a><h4>温馨提示：</h4><p>你使用的浏览器版本过低。为了获得更好的浏览体验，我们强烈建议您 <a href="http://browsehappy.com" target="_blank">升级</a> 到最新版本的IE浏览器，或者使用较新版本的 Chrome、Firefox、Safari 等。</p></div><![endif]-->
	<div class="header">
		<div id="messageBox" class="alert alert-error ${empty message ? 'hide' : ''}"><button data-dismiss="alert" class="close">×</button>
			<label id="loginError" class="error">${message}</label>
		</div>
	</div>
	<%-- <h1 class="form-signin-heading">${fns:getConfig('productName')}</h1> --%>
	<form id="loginForm" class="form-signin"  action="${ctx}/login"  method="post">
		<!-- <label class="input-label" for="username">登录名</label> -->
		<div class="input-box">
		<input type="text" id="username" name="username" class="input-block-level required" value="${username}" placeholder="请输入用户名">
		<span class="logo user"></span>
		<!-- <label class="input-label" for="password">密码</label> -->
		<input type="password" id="password" name="password" class="input-block-level required" placeholder="请输入密码">
		<span class="logo pwd"></span>
		<%--<c:if test="${isValidateCodeLogin}">--%>
		
			<div class="validateCode">
			<label class="input-label mid" for="validateCode">验证码</label>
			<sys:validateCode name="validateCode" inputCssStyle="margin-bottom:0; width:80px;"/>
		</div>

		<%--</c:if>--%>
		<%--
		<label for="mobile" title="手机登录"><input type="checkbox" id="mobileLogin" name="mobileLogin" ${mobileLogin ? 'checked' : ''}/></label> --%>
		<button class="btn-log" type="button" onClick = "submitCheck()" value="登 录">登 录</button>
		<div class="checkbox-group">
		<input class="check-box-btn" type="checkbox" id="rememberMe" name="rememberMe" ${rememberMe ? 'checked' : ''}/> 
		<label for="rememberMe" title="下次不需要再登录" class="remember"></label><span class="remember-txt">记住我（公共场所慎用）</span>
		</div>
		
		<%-- <div id="themeSwitch" class="dropdown">
			<a class="dropdown-toggle" data-toggle="dropdown" href="#">${fns:getDictLabel(cookie.theme.value,'theme','默认主题')}<b class="caret"></b></a>
			<ul class="dropdown-menu">
			  <c:forEach items="${fns:getDictList('theme')}" var="dict"><li><a href="#" onclick="location='${pageContext.request.contextPath}/theme/${dict.value}?url='+location.href">${dict.label}</a></li></c:forEach>
			</ul>
			<!--[if lte IE 6]><script type="text/javascript">$('#themeSwitch').hide();</script><![endif]-->
		</div> --%>
		</div>
		<div class="clearfix"></div>
	</form>
	<div class="footer">
		 Copyright &copy; ${fns:getConfig('copyrightYearBegin')}-${fns:getConfig('copyrightYear')} ${fns:getConfig('productName')} - Powered By <a href="http://www.dhc.com.cn/" target="_blank">${fns:getConfig('rightByCompany')} </a> ${fns:getConfig('version')} 
	</div>
	<script src="${ctxStatic}/flash/zoom.min.js" type="text/javascript"></script>
</body>
</html>