<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>申请绑定</title>
<link type="text/css" rel="stylesheet" href="css/reset.css" />
<link type="text/css" rel="stylesheet" href="css/global.css" />
<script language= "javascript" src="../../scripts/jsp.js"></script>
<!-- <script type="text/javascript" src="js/jquery-1.6.min.js"></script> -->
<script type="text/javascript" src="js/jquery.reveal.js"></script>
<script language= "javascript" src="binding.js"></script>
<link rel="shortcut icon" href="images/favicon.ico" />
<!--[if IE 6]>
<style type="text/css">
.content IMG {
	behavior: url("images/iepngfix.htc")
}
.reveal-modal IMG {
	behavior: url("images/iepngfix.htc")
}
</style>
<![endif]-->
</head>

<body>
<div class="main">
  <div class="content">
    <div class="top_title"><a href="#" data-reveal-id="myModal"><img src="images/top_title.png" /></a></div>
    <ul>
      <li><img src="images/lc_01.png" /><span class="bind_font">提报申请</span></li>
      <li><img src="images/lc_02.png" /><span class="bind_font">资质审核</span></li>
      <li><img src="images/lc_03.png" /><span class="bind_font">公司审查</span></li>
      <li><img src="images/lc_04.png" /><span class="bind_font">签订协议</span></li>
      <li><img src="images/lc_05.png" /><span class="bind_font">培训体检</span></li>
      <li><img src="images/lc_06.png" /><span class="bind_font">开始下单</span></li>
    </ul>
    <div class="apply"><a href="#"><img src="images/aply.png" /></a></div>
  </div>
  <div id="myModal" class="reveal-modal">
    <h1><img src="images/bind.png" /></h1>
    <h1 id="srUserName" class="bind_font">欢迎您！</h1>
    <p>
    <form>
      <ul>
        <li><span class="bind_font">登录账号</span>
          <input type="text" id="hlUserName"/>
        </li>
        <li><span class="bind_font">&nbsp;密&nbsp;&nbsp;码&nbsp;</span>
          <input type="password" id="hlPassWord"/>
        </li>
        <li><span class="bind_font">确认密码</span>
          <input type="password"  id="hlPassWordTwo"/>
        </li>
      </ul>
      <div class="clear"></div>
      <div class="apply_b">
        <input type="button" class="bind_apple" id="userbinding" value="确认绑定" onclick="$.csBinding.bindingMember()"/>
      </div>
    </form>
    </p>
    <a class="close-reveal-modal"><img src="images/close.png" /></a> </div>
</div>
<iframe id="ccbMall" src="http://mall.ccb.com/alliance/getH.htm" height="0" width="0" frameborder="0" style="display:none" ></iframe>
<script type="text/javascript">
  var my_width  = Math.max(document.documentElement.clientWidth,document.body.clientWidth);
  var my_height = Math.max(document.documentElement.clientHeight,document.body.clientHeight);
  var ccbMall_iframe = document.getElementById("ccbMall");
  ccbMall_iframe.src = ccbMall_iframe.src+"#"+my_height+"|"+my_width;
</script>
</body>
</html>