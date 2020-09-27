<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>My JSP 'ordenInfo.jsp' starting page</title>
	<script language= "javascript" src="<%=path %>/scripts/jsp.js"></script>
    <script type="text/javascript" src="<%=path %>/pages/orden/ordenInfo.js"></script>
    <link rel="stylesheet" href="<%=path %>/pages/orden/bootstrap.min.css">
	<script src="<%=path %>/pages/orden/bootstrap.min.js"></script>
  	<style>
	.table-content {
		width:750px;
		text-align:center;
	}
	.table-content caption {
		font-size:14px;
		font-weight:bold;
		text-align:left;
		margin-bottom:10px;
	}
	.table-content th {
		font-size:12px;
		font-weight: bold;
		text-align:center;
		background-color:#efefef;
	}
	.tdStyle {
		font-size:12px;
		width:125px;
		background-color: #efefef
	}
	.table-content td {
		text-align:center;
		font-size:12px
	}
	.table-content span {
		text-align:center;
		font-size:12px
	}
	.listStyle {
		margin-left:0px;
	}
	.listStyle li {
		height:30px;
		list-style:none
	}
	</style>
    </head>
  
  <body>
  <jsp:include page="/servlet/GetOrdenByNo">
  	<jsp:param value="${param.orderNo}" name="code"/>
  </jsp:include>
  <c:set value="${orden}" scope="request" var="orden" ></c:set>
  <jsp:include page="/servlet/GetOrdenDetailByOrdenId">
  	<jsp:param value="${orden.ordenID}" name="ordenID"/>
  </jsp:include>
  <c:set value="${details}" scope="request" var="ordendetails"></c:set>
  <jsp:include page="/servlet/GetDressStyleByOrdenID">
  	<jsp:param value="${orden.sizeBodyTypeValues}" name="typeValues"/>
  </jsp:include>
  <c:set value="${dress}" scope="request" var="dress"></c:set>
  <jsp:include page="/servlet/GetDictByClothingID">
  	<jsp:param value="${orden.clothingID}" name="clothingid"/>
  </jsp:include>
  <c:set value="${dict}" scope="request" var="dict"></c:set>
  <jsp:include page="/servlet/GetFabricByFabircCode">
  	<jsp:param value="${orden.fabricCode}" name="fabricCode"/>
  </jsp:include>
  <c:set value="${fabric}" scope="request" var="fabric"></c:set>
  <jsp:include page="/servlet/GetBrandById">
  	<jsp:param value="${fabric.brands}" name="brandId"/>
  </jsp:include>
  <c:set value="${brand}" scope="request" var="brand"></c:set>
   <jsp:include page="/servlet/GetDictBycompId">
  	<jsp:param value="${fabric.composition}" name="compositionId"/>
  </jsp:include>
  <c:set value="${comp}" scope="request" var="comp"></c:set>
  <jsp:include page="/servlet/GetPartValues">
  	<jsp:param value="${orden.sizePartValues}" name="partValues"/>
  </jsp:include>
  <c:set value="${partmap}" scope="request" var="partmap"></c:set>
  <jsp:include page="/servlet/GetBodyTypeByValues">
  	<jsp:param value="${orden.sizeBodyTypeValues}" name="bodytype"/>
  </jsp:include>
  <c:set value="${bodymap}" scope="request" var="bodymap"></c:set>
  <jsp:include page="/servlet/GetClothingBodyInfo">
  	<jsp:param value="${orden.ordenID}" name="ordenNo"/>
  </jsp:include>
  <c:set value="${clothmap}" scope="request" var="clothmap"></c:set>
  <jsp:include page="/servlet/GetOrderProcess">
  	<jsp:param value="${orden.ordenID}" name="ordenNo"/>
  </jsp:include>
  <c:set value="${processmap}" scope="request" var="processmap"></c:set>
  <jsp:include page="/servlet/GetEmbroidery">
  	<jsp:param value="${orden.ordenID}" name="ordenNo"/>
  </jsp:include>
  <c:set value="${embmap}" scope="request" var="embmap"></c:set>
 <div style="width:750px; overflow:hidden; margin: auto; ">
<table class="table table-bordered table-striped table-content" width="100%">
  <caption>
  商品明细
  </caption>
  <thead>
    <tr>
      <th>商品编号</th>
      <th>商品图片</th>
      <th>名称</th>
      <th>类型</th>
      <th>风格</th>
      <th>数量</th>
      <th>价格</th>
      <th>小计</th>
    </tr>
  </thead>
  <c:forEach items="${ordendetails}" var="detail">
	  	<tr>
	      <td><c:out value="${orden.ordenID}"></c:out></td>
	      <td><img alt="" src="pages/per_img/orderhead.png" style="height: 50px; width: 50px"></td>
	      <td>
	      	<jsp:include page="/servlet/GetClothingByDictID">
	      		<jsp:param value="${detail.singleClothingID}" name="clothingid"/>
	      	</jsp:include>
	      	<c:out value="${requestScope.clothingname}"></c:out>
	      </td>
	      <td>
	  		<c:if var="cloth" test="${orden.clothingID ne 1 and orden.clothingID ne 2}">单件</c:if>
	  		<c:if test="${not cloth}"><c:out value="${dict.name}"></c:out></c:if>
	      </td>
	      <td>${dress}</td>
	      <td>${detail.amount}</td>
	      <td><c:out value="${detail.cmtPrice+detail.fabricPrice+detail.processPrice}" ></c:out></td>
	      <td><c:out value="${(detail.cmtPrice+detail.fabricPrice+detail.processPrice)*detail.amount}"></c:out></td>
	    </tr>
  </c:forEach>
  		<tr>
  			<td colspan="6">&nbsp;</td>
  			<td>合计</td>
  			<td>${orden.ordenPrice}</td>
  		</tr>
</table>
<table class="table table-bordered table-striped table-content">
  <caption>
  面料信息
  </caption>
  <thead>
    <tr>
      <th>面料图片</th>
      <th>面料名称</th>
      <th>成分</th>
      <th>纱织</th>
      <th>品牌</th>
      <th>产地</th>
    </tr>
  </thead>
    <tr>
      <td><img src=""></td>
      <td><c:out value="${fabric.fabricNo}"></c:out></td>
      <td><c:out value="${comp.name}"></c:out></td>
      <td><c:out value="${fabric.shazhi}"></c:out></td>
      <td><c:out value="${brand.traderName}"></c:out></td>
      <td><c:out value="${fabric.address}"></c:out></td>
    </tr>
</table>
<table class="table table-bordered table-content">
  <caption>
  绣字信息
  </caption>
  <c:if test="${!empty embmap}">
    <tr>
    <c:forEach items="${embmap}" var="item">
    	<td class="tdStyle">${item.key}</td>
    </c:forEach>
    </tr>
    <tr>
    <c:forEach items="${embmap}" var="item">
    	<td>${item.value}</td>
    </c:forEach>
    </tr>
  </c:if>
</table>
<table class="table table-bordered  table-content">
  <caption>
  量体信息
  </caption>
  	 <c:if test="${!empty clothmap}" var="nullcloth">
 	 <tr>
	  <c:forEach items="${clothmap}" var="item" >
	  	<td class="tdStyle">${item.key}</td>
	  </c:forEach>
	  </tr>
	  <tr>
	  <c:forEach items="${clothmap}" var="item" >
	  	<td>${item.value}</td>
	  </c:forEach>
	  </tr>
	  </c:if>
	  <c:if test="${!nullcloth}">
	  	<tr><td>&nbsp;</td></tr>
	  </c:if>	
</table>
<table class="table table-bordered  table-content">
  <caption>
  尺寸信息
  </caption>
  
  <tr>
  <c:if test="${!empty partmap}">
  	<c:forEach items="${partmap}" var="item" varStatus="status">
  	   <td class="tdStyle">${item.key} :</td><td>${item.value }</td>
  	   <c:if test="${(status.index+1) mod 3 == 0}">
  	 	 <tr></tr>
  	   </c:if>
  </c:forEach>
  </c:if>
  </tr>
</table>
<table class="table table-bordered table-content">
  <caption>
  身体特征
  </caption>
    <tr>
    <c:forEach items="${bodymap}" var="item" >
    	<th>${item.key}</th>
    </c:forEach>
    </tr>
    <tr>
    <c:forEach items="${bodymap}" var="item" >
    	<td>${item.value}</td>
    </c:forEach>
    </tr>
</table>
<table class="table table-bordered  table-content">
  <caption>
  工艺信息
  </caption>
  <tbody>
    <tr>
    	<c:if test="${!empty processmap}">
  		<c:forEach items="${processmap}" var="item" varStatus="status">
  	   <td class="tdStyle">${item.key} :</td><td>${item.value }</td>
  	   <c:if test="${(status.index+1) mod 3 == 0}">
  	 	 <tr></tr>
  	   </c:if>
  		</c:forEach>
 		</c:if>
    </tr>
  </tbody>
</table>
<button class="btn btn-danger btn-large">确定&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i class="icon-chevron-right"></i></button>
</div>
</body>
</html>
