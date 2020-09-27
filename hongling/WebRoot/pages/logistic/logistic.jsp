<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
<title></title>
<link rel="shortcut icon" href="rcmtm.ico" /> 
<meta http-equiv='Content-Type' content='text/html;charset=utf-8' />
<meta http-equiv='pragma' content='no-cache' />
<meta http-equiv='cache-control' content='no-store' />
<meta http-equiv='expires' content='0' />
<script language= "javascript" src="../../scripts/import.js"></script>
<script type="text/javascript" src="logistic.js"></script>
<link rel="stylesheet" href="logistic.css" type="text/css"></link>
<title>物流</title>
</head>
<body>
	<div class="wuliu_body">
		<div class="wuliu_biaoti">
			<h3>物流公司：<b class="name" id="kdgs"></b>&nbsp;&nbsp;&nbsp;订单编号：<b id="ordenNo"></b></h3>
		</div>
		<br/>
		<div class="wuliu_danhao" ><label id="ydh"></label></div>
		<div class="wuliu_liebiao">
			<ul id="info">
				<li><h4>正在获取数据，请稍候..</h4></li>
			</ul>
		</div>
	</div>
</body>
</html>