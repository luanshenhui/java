<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>隔离、留验与就地诊验</title>
<%@ include file="/common/resource_show.jsp"%>

<style type="text/css">
input.datepick{background:#FFF url(/ciqs/static/dec/images/dpn.date.pick.gif) no-repeat right}
.title a:link, a:visited {
    color:white;
    text-decoration: none;
}
 #title_a{color:#ccc}
 #title_a:hover{
 	color:white;
 }
.box-img-bg {
	background-image: url(../static/show/disc/bg.png);
	box-sizing: border-box;
	width: 1198px;
	height: 164px;
	padding: 0 200px;
	position: absolute;
	display: none;
	font-size: 20px;
	line-height: 35px;
	color: white;
}

.box-content-style {
	display: table-cell;
	vertical-align: middle;
	text-align: center;
}
</style>


</head>

<body  class="bg-gary">
<div class="freeze_div_list">
<div class="title-bg" >
<div class=" title-position margin-auto white">
<div class="title">
<!-- <a href="nav.html" class="white"><span  class="font-24px">隔离 /就地诊验或留验</span></a> -->
<span class="font-24px" style="color:white;">行政确认 /</span><a id="title_a" href="/ciqs/quartn/list">隔离、留验与就地诊验</a></div>
<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
</div>
</div>
<div class="flow-bg" >
<div class="flow-position margin-auto" >

<ul class="white font-18px flow-height font-weight">
<li>体温检测</li>
<li>医学排查</li>
<li>现场隔离</li>
<li>病例转诊</li>
<li></li>
<li></li>
<li></li>
<li></li>
</ul>
<ul>
  <li><img src="${ctx}/static/show/images/quartn/quartnA1.png" width="107" height="103" content="按照传播途径选用《口岸呼吸道传染病排查处置技术方案》、《口岸消化道传染病排查处置技术方案》、《口岸蚊媒传染病排查处置技术方案》表格。在PROSAS系统中填写《口岸传染病可疑病例流行病学调查表》。记录内容：体温监测仪录像、健康申明卡、执法记录、电话录音或保留纸质材料等。"/></li>
  <li><img src="${ctx}/static/show/images/quartn/quartnA2.png" width="107" height="103" content="进行详细的排查，包括临床表现及流行病学因素调查。做好自身防护，严防交叉感染。记录内容：体温、《口岸传染病可疑病例流行病学调查表》、《采样知情同意书》、《口岸传染病可疑病例医学排查记录表》。"/></li>
  <li><img src="${ctx}/static/show/images/quartn/quartnA3.png" width="107" height="103" content="经现场初步排查判定该旅客为（呼吸道、消化道、蚊媒）疑似病例后，首先划分密切接触者和一般接触者，在做好相关防护措施的前提下，将疑似病例和密切接触者转至隔离观察室。"/></li>
  <li><img src="${ctx}/static/show/images/quartn/quartnA4.png" width="107" height="103" content="对结合明确的旅行史和接触史，不能排除检疫传染病的，一律转交指定医疗机构进一步明确诊断，根据诊断结果分别实施隔离、就地诊验或留验。现场同时对疑似病例可能污染的区域、物品等实施消毒、除虫、除鼠等卫生处理措施。记录内容：电话记录、或保留纸质诊疗结果或出院证明、《口岸传染病可疑病例医学排查记录表》。"/></li>
  <li></li>
  <li></li>
  <li></li>
  <li></li>
</ul>
</div>
</div>
</div>
<div class="blank_div_list">
</div>
<div class="margin-auto width-1200 search-box">
	<div id="alertBoxId" class="box-img-bg"><span class="box-content-style" id="alertContentId"></span></div>
<form action="/ciqs/quartn/list" method="post" id="quartn_form">
<table width="100%" border="0" class="table-search margin-auto">
  <tr>
    <td height="25" align="left" valign="middle">证件类型</td>
    <td height="25" align="left" valign="middle">证件号码</td>
<!--     <td height="25" align="left" valign="middle">抵/离境日期</td> -->
    <td height="25" align="left" valign="middle">出入境方式</td>
    <td height="25" align="left" valign="middle">发现渠道</td>
  </tr>
  
  <tr>
    <td width="200" height="50" align="left">
	    <select id="cardType" class="search-input input-175px" name="cardType">
	    <option value="">全部</option>
			<c:if test="${not empty cardlist}">
				<c:forEach items="${cardlist}" var="row">
					<c:if test="${obj.cardType== row.code}">
						<option  selected="selected"  value="${row.code}">${row.name}</option>
					</c:if>
					<c:if test="${obj.cardType!= row.code}">
						<option value="${row.code}">${row.name}</option>
					</c:if>
				</c:forEach>
			</c:if>
		</select>
    </td>
    <td width="200" height="50" align="left" ><input name="cardNo" id="consignee_name" size="14"  value="${obj.cardNo}" class="search-input input-175px" /></td>
    <td width="200" height="50" align="left">
	    <select id="enterExpMod" class="search-input input-175px" name="enterExpMod">
	     	<option value="">全部</option>
			<c:if test="${not empty outsidelist }">
				<c:forEach items="${outsidelist}" var="row">
					<c:if test="${obj.enterExpMod== row.code}">
						<option selected="selected" value="${row.code}">${row.name}</option>
					</c:if>
					<c:if test="${obj.enterExpMod!= row.code}">
						<option value="${row.code}">${row.name}</option>
					</c:if>
				</c:forEach>
			</c:if>
		</select>
    </td>
    <td width="200" height="50" align="left">
	    <select id="discoverWay" class="search-input input-175px" name="discoverWay">
	    	<option value="">全部</option>
			<c:if test="${not empty discoverlist }">
				<c:forEach items="${discoverlist}" var="row">
					<c:if test="${obj.discoverWay== row.code}">
						<option selected="selected" value="${row.code}">${row.name}</option>
					</c:if>
					<c:if test="${obj.discoverWay!= row.code}">
						<option value="${row.code}">${row.name}</option>
					</c:if>
				</c:forEach>
			</c:if>
		</select>
    </td>
    
  </tr>
  
   <tr>
    <td height="25" align="left" valign="middle">直属局</td>
    <td height="25" align="left" valign="middle">分支机构</td>
    <td height="25" align="left" valign="middle">抵/离境日期</td>
    <td height="25" align="left" valign="middle"></td>
  </tr>
  <tr>
    <td width="200" height="50" align="left">
	    <select id="directyUnderOrg" class="search-input input-175px" name="<!-- directyUnderOrg -->">
			<option selected="selected"  value="210000">辽宁出入境检验检疫局</option>
<!-- 	    	<option value="">全部</option> -->
<!-- 			 <c:if test="${not empty organizes }"> -->
<!-- 				<c:forEach items="${organizes}" var="row"> -->
<!-- 					<c:if test="${obj.directyUnderOrg== row.code}"> -->
<!-- 						<option selected="selected"  value="${row.code}">${row.name}</option> -->
<!-- 					</c:if> -->
<!-- 					<c:if test="${obj.directyUnderOrg!= row.code}"> -->
<!-- 						<option value="${row.code}">${row.name}</option> -->
<!-- 					</c:if> -->
<!-- 				</c:forEach> -->
<!-- 			</c:if>  -->
		</select>
    </td>
   <td width="200" height="50" align="left">
	    <select id="portOrgCode" class="search-input input-175px" name="portOrgCode">
	    	<option value="">全部</option>
			 <c:if test="${not empty qlcdeptments }">
				<c:forEach items="${qlcdeptments}" var="row">
					<c:if test="${obj.portOrgCode== row.code}">
						<option selected="selected" value="${row.code}">${row.name}</option>
					</c:if>
					<c:if test="${obj.portOrgCode!= row.code}">
						<option value="${row.code}">${row.name}</option>
					</c:if>
				</c:forEach>
			</c:if> 
		</select>
    </td>
     <td width="200" height="50" align="left"><input name="enterExpDate_begin" type="text" id="enterExpDate_begin" class="search-input input-175px datepick " value="${obj.enterExpDate_begin}"/></td>
     <td width="200" height="50" align="left"><input name="enterExpDate_over" type="text" id="enterExpDate_over" class="search-input input-175px datepick " value="${obj.enterExpDate_over}"/></td>
  </tr>
  <tr>
	<td></td>
	<td></td>
	<td style="width:250px">
		<input type="submit" class="search-btn fo" value="搜索" style="cursor: pointer;" onclick="formSubmit()"/>
	</td>
	<td>	
		<input type="button" class="search-btn fo" value="清空" style="cursor: pointer;" onclick="cleanUp()"/>
	</td>
	<td></td>
  </tr>
</table>
</form>
</div>

<div class="margin-auto width-1200 tips" >共找到<span class="yellow font-18px" >${counts}</span>条记录</div>
<div class="margin-auto width-1200  data-box">
<div class="margin-cxjg">
	<table class="margin-cxjg_table" border="0" cellspacing="0" cellpadding="0">
 			<tr class="thead">
      <td>证件类型</td>
      <td>证件号码</td>
      <td>姓名</td>
      <td>直属局</td>
      <td>分支机构</td>
      <td>出入境口岸</td>
      <td>出入境目的地</td>
      <td>出入境时间</td>
	  <td>发现方式</td>
	  <td>记录人员</td>					
      <td>操作</td>
    </tr>
    <c:if test="${not empty list }">
		<c:forEach items="${list}" var="row">
			<tr>
			  <td width="120" height="90" align="center" class="font-18px">${row.cardType}
			  <c:if test="${row.cardType == '其他'  and not empty row.card_type_rmk}"><br/>（${row.card_type_rmk}）
			  </c:if>
			  </td>
		      <td width="100" height="90" align="center">${row.cardNo}</td>
		      <td width="100" height="90" align="center">${row.name}</td>
		      <td width="150" height="90" align="center">${row.portOrg}</td>
		      <td width="100" height="90" align="center">${row.portOrgUnder}</td>
		      <td width="100" height="90" align="center">${row.enterExpPort}</td>
		      <td width="100" height="90" align="center">${row.enterExpPlc}</td>
		      <td width="100" height="90" align="center">${row.enterExpDate}<%-- <fmt:formatDate value="${row.intrcept_date}" type="both"/> --%></td>
		      <td width="100" height="90" align="center">${row.discoverWay}</td>
		      <td width="100" height="90" align="center">${row.createUser}</td>
		      <td height="90" align="center" valign="middle"><a href='javascript:jumpPage("/ciqs/quartn/detail?id=${row.id}");'><span class="data-btn margin-auto">详细+</span></a></td>
			</tr>
	</c:forEach>
	</c:if>	
	<tfoot>
		<jsp:include page="/common/pageUtil.jsp" flush="true"/>
	</tfoot>       
  </table>
  </div>
</div>

<div class="margin-auto width-1200 tips" ></div>
<script type="text/javascript"> 
		function pageUtil(page) {
			$("#quartn_form").attr("action", "/ciqs/quartn/list?page="+page);
			$("#quartn_form").submit();
		} 
		
		function formSubmit() {
			$("#quartn_form").submit();
		}
		
		function cleanUp(){
			$("#enterExpDate_begin").val('');
			$("#enterExpDate_over").val('');
			$("#consignee_name").val('');
			$("#cardType").val(null);
			$("#discoverWay").val(null);
			$("#portOrgCode").val(null);
			$("#portDeptCode").val(null);
			$("#enterExpMod").val(null);
		}
</script>
<script type="text/javascript">
    $("li").mouseenter(function () {
        var img = this.getElementsByTagName("img")[0];
        var str = img.getAttribute("content");
        var alertBox = document.getElementById("alertBoxId");
        var alertContent = document.getElementById("alertContentId");
        alertContent.innerText = str;
        alertBox.style.display = 'table';
    });

    $("li").mouseleave(function () {
        var alertBox = document.getElementById("alertBoxId")
        alertBox.style.display = 'none';
    });
</script>
</body>
</html>
