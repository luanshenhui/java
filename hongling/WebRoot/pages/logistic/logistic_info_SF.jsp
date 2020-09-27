<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fm"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
<script language= "javascript" src="logistic_info_SF.js"></script>
<link rel="stylesheet" href="bootstrap.min.css">
<style>
.table-content {
	width:730px;
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
	width:800px;
	vertical-align:middle;
	line-height:200px;
}
</style>
<title>物流详情</title>
</head>
<body>
<jsp:include page="/servlet/GetSFInfoByOrdenNo">
	<jsp:param value="${param.ordenID}" name="ordenNo"/>
</jsp:include>
<c:set scope="request" value="${SFmap}" var="sfmap"></c:set>
<div class="main-content">
  <table class="text-left listStyle">
  	<tr>
  		<td width=100>物流公司 :</td>
  		<td width=200 id="logisticCompany">${sfmap.logisticCompany }</td>
  	
  		<td width=100>电&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;话 :</td>
  		<td width=200 id="mobile">${sfmap.mobile }</td>
  	</tr>
  	<tr>
  		<td>物流单号:</td>
  		<td id="logisticNo">${sfmap.logisticNo}</td>
  		<td>物流状态:</td>
  		<td id="logisticStatus">${sfmap.logisticStatus}</td>
  	</tr>
  </table>
  <table class="table table-bordered table-striped table-content listStyle">
    <thead>
      <tr>
        <th>序号</th>
        <th>操作时间</th>
        <th>操作信息</th>
      </tr>
    </thead>
    <tbody>
    <c:forEach items="${sfmap.SFinfo}" var="info" varStatus="status">
      <c:forEach items="${info}" var="item" varStatus="s">
      <tr>
        <td>${item.key}</td>
        <td><c:out value="${fn:substring(item.value,0,19)}"></c:out></td>
        <td><c:out value="${fn:substring(item.value,19,fn:length(item.value))}"></c:out></td>
      </tr>
      </c:forEach>
    </c:forEach>
    </tbody>
  </table>
  <!-- <button class="btn btn-danger btn-large">确定&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i class="icon-chevron-right"></i></button> -->
</div>

</body>
</html>