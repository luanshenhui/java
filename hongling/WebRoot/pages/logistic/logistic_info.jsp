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
<script language= "javascript" src="logistic_info.js"></script>
<link rel="stylesheet" href="bootstrap.min.css">
<style>
.table-content {
	width:880px;/* 730px; */
	text-align:center;
}
.table-content th {
	font-size:12px;
	font-weight: bold;
	text-align:center;
	background-color:#efefef;
}
.table-content td {
	text-align:center;
	font-size:12px
}
.listStyle {
	margin-left:0px;
	margin-top:20px;
}
.listStyle td {
	height:35px;
	line-height:35px;
	list-style:none;
	font-size:14px;
}
body{TEXT-ALIGN: center;}
.main-content{ 
	MARGIN-RIGHT: auto;
	MARGIN-LEFT: auto;
	height:200px;
	width:880px;/* 800px; */
	vertical-align:middle;
	line-height:200px;
}
</style>
<title>物流</title>
</head>
<body>
<div class="main-content">
  <table class="text-left listStyle" width=800>
  	<tr>
  		<td width=100>物流公司 :</td>
  		<td width=200 id="logisticCompany"></td>
  		<td width=100>电&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;话 :</td>
  		<td width=200 id="mobile"></td>
  	</tr>
  	<tr>
  		<td>物流单号 :</td>
  		<td id="logisticNo"></td>
  		<td>物流状态 :</td>
  		<td id="logisticStatus"></td>
  	</tr>
  </table>
  <table class="table table-bordered table-striped table-content listStyle">
    <thead>
      <tr>
        <th>序号</th>
        <th>操作时间</th>
        <th>操作信息</th>
      </tr>
    <thead>
    <tbody id="logistic_info">
    </tbody>
  </table>
</div>
</body>
</html>