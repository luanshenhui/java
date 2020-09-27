<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>进境邮寄物全过程执法记录</title>
<%@ include file="/common/resource_show.jsp"%>
<script type="text/javascript"> 
		function pageUtil(page) {
			$("#mail_form").attr("action", "/ciqs/mail/findMail?page="+page);
			$("#mail_form").submit();
		}
		function mailFormSubmit() {
			$("#mail_form").attr("action", "/ciqs/mail/findMail");
			$("#mail_form").attr("method", "post");
			$("#mail_form").submit();
		}
		function reset(){
			$("#package_no").val("");
			$("#consignee_name").val("");
			$("#textfield3").val("");
			$("#textfield4").val("");
			$("#deal_type").val("");
			$("#cago_name").val("");
			$("#port_zsorg_code").val("CIQGVLN");
			$("#port_org_code").val("DLGWBSC");
		}
</script>
<style type="text/css">
input.datepick{background:#FFF url(/ciqs/static/dec/images/dpn.date.pick.gif) no-repeat right}
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
<div class="title"><span class="font-24px" style="color:white;">行政确认 /</span><a id="title_a" href="/ciqs/mail/findMail">进境邮寄物检疫</a></div>
<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
</div>
</div>
<div class="flow-bg" >
<div class="flow-position margin-auto" >

<ul class="white font-18px flow-height font-weight">
<li>信息采集</li>
<li>开包查验</li>
<li>截留</li>
<li>抽样送检</li>
<li>放行</li>
<li>退回</li>
<li>集中销毁</li>
<li>归档</li>
</ul>
<ul>
  <li><img src="${ctx}/static/show/images/mail/mailA1.png" width="107" height="103" content="收集寄件人提供的邮寄物信息。记录内容包括：寄件人及邮寄物的信息以及相关照片。"/></li>
  <li><img src="${ctx}/static/show/images/mail/mailA2.png" width="107" height="103" content="开包前使用移动执法终端拍摄邮单及邮寄物外包装，查验包内是否有禁止邮寄进境物品。记录内容包括：相关电子图像记录、《入/出境特殊物品卫生检疫审批单》及《入出境特殊物品卫生检疫查验记录》。"/></li>
  <li><img src="${ctx}/static/show/images/mail/mailA3.png" width="107" height="103" content="对带有《中华人民共和国禁止携带、邮寄进境的动植物及其产品名录》内物品，以及其他禁止进境物品的予以截留。记录内容包括：《进出境邮寄物检疫处理通知单》及进境邮寄物截留情况登记表。"/></li>
  <li><img src="${ctx}/static/show/images/mail/mailA4.png" width="107" height="103" content="对截留物进行抽样并送到实验室进行检测。记录内容包括：《抽样凭证》及《委托检验申请单》。"/></li>
  <li><img src="${ctx}/static/show/images/mail/mailA5.png" width="107" height="103" content="经检疫未发现动物疫病和植物有害生物、需办理检疫审批手续的邮寄物，检疫许可证等相关证明文件齐全的，且检验检疫合格的、属于农业转基因生物材料，相关文件齐全，且检验检疫合格的、属于濒危野生动植物及其产品的，进出口证明书齐全且检疫合格的及能进行有效检疫处理并处理合格的物品予以放行。"/></li>
  <li><img src="${ctx}/static/show/images/mail/mailA6.png" width="107" height="103" content="符合退回条件的邮寄物，邮政部门负责将该邮寄物退回并告知收件人。记录内容包括：《进出境邮寄物检疫处理通知单》、进境邮寄物截留情况登记表及电子音像记录。"/></li>
  <li><img src="${ctx}/static/show/images/mail/mailA7.png" width="107" height="103" content="对作销毁处理的进境邮寄物，注明销毁原因，并通知邮政部门及收件人。记录内容包括：《进出境邮寄物检疫处理通知单》、进境邮寄物截留情况登记表及电子音像记录。"/></li>
  <li><img src="${ctx}/static/show/images/mail/mailA8.png" width="107" height="103" content="检查整理电子文书、音像资料是否齐备，所出具证单是否符合相关细则和规定。档案调阅需符合《辽宁检验检疫局检务档案管理规定》要求，填写《查阅档申请表》或《借阅档申请表》。"/></li>
</ul>
</div>
</div>
</div>
<div class="blank_div_list">
</div>
<div class="margin-auto width-1200 search-box">
	<div id="alertBoxId" class="box-img-bg"><span class="box-content-style" id="alertContentId"></span></div>
<form action="/ciqs/mail/findMail"  method="post" id="mail_form">
<table width="100%" border="0" class="table-search margin-auto">
  <tr>
    <td height="25" align="left" valign="middle">邮件单号</td>
    <td height="25" align="left" valign="middle">收件人姓名</td>
    <td height="25" align="left" >截获开始时间</td>
    <td height="25" align="left" >截获结束时间</td>
    <td height="25" align="left" >处理方式</td>
    <td height="25">&nbsp;</td>
  </tr>
  
  <tr>
    <td width="195" height="50" align="left" valign="middle"><input type="text" name="package_no" id="package_no"size="14" value="${package_no}" class="search-input input-175px" /></td>
    <td width="200" height="50" align="left" valign="middle"><input type="text" name="consignee_name" id="consignee_name" size="14" value="${consignee_name}" class="search-input input-175px" /></td>
    <td width="196" height="50" align="left"><input name="startIntrceptDate" type="text" class="search-input input-175px datepick" id="textfield3" value="${startIntrceptDate}"/></td>
    <td width="196" height="50" align="left"><input name="endIntrceptDate" type="text" class="search-input input-175px datepick" id="textfield4" value="${endIntrceptDate}"/></td>
    <td width="195" height="50" align="left">
	    <select id="deal_type" class="search-input input-175px" name="deal_type">
	    	<option value="">请选择</option>
			<c:if test="${not empty allDeal_type }">
				<c:forEach items="${allDeal_type}" var="row">
				   <c:if test="${deal_type_selected == row.code}">
					<option selected="selected" value="${row.code}">${row.name}</option>
				   </c:if>
				   <c:if test="${deal_type_selected != row.code}">
					<option value="${row.code}">${row.name}</option>
				   </c:if>
				</c:forEach>
			</c:if>
		</select>
    </td>
  </tr>
  
  <tr>
    <td height="25" align="left" valign="middle">物品名称</td>
    <td height="25" align="left" valign="middle">直属局</td>
    <td height="25" align="left" colspan="2">分支机构</td>
    
    <td height="25">&nbsp;</td>
    <td height="25">&nbsp;</td>
  </tr>
  
  <tr>
    <td width="195" height="50" align="left" valign="middle"><input type="text" name="cago_name" id="cago_name"size="14" value="${cago_name}" class="search-input input-175px" /></td>
    
    <td width="195" height="50" align="left">
	    <select id="port_zsorg_code" class="search-input input-175px" name="port_zsorg_code">
			<option value="210000">辽宁出入境检验检疫局</option>
			<c:if test="${not empty allorgList }">
				<c:forEach items="${allorgList}" var="row">
					<c:if test="${zselected == row.code}">
						<option selected="selected" value="${row.code}">${row.name}</option>
					</c:if>
					<c:if test="${zselected != row.code}">
						<option value="${row.code}">${row.name}</option>
					</c:if>
				</c:forEach>
			</c:if>
		</select>
    </td>
    <td width="195" height="50" align="left" colspan="2">
	    <select id="port_org_code" class="search-input input-175px" style="width:300px" name="port_org_code">
	        <option value="211940">大连局港湾办事处</option>
			<c:if test="${not empty alldepList }">
				<c:forEach items="${alldepList}" var="row">
					<c:if test="${oselected == row.code}">
						<option selected="selected" value="${row.code}">${row.name}</option>
					</c:if>
					<c:if test="${oselected != row.code}">
						<option value="${row.code}">${row.name}</option>
					</c:if>
				</c:forEach>
			</c:if>
		</select>
    </td>
  </tr>
  <tr>
	<td></td>
	<td></td>
	<td style="width:250px">
		<input type="submit" class="search-btn fo" value="搜索" style="cursor: pointer;" onclick="mailFormSubmit()" />
	</td>
	<td>	
		<input type="button" class="search-btn fo" value="清空" style="cursor: pointer;" onclick="reset()"/>
	</td>
	<td></td>
  </tr>
</table>
</form>
</div>

<div class="margin-auto width-1200 tips">
	共找到<span class="yellow font-18px"> 
	<c:if
			test="${not empty list }">${counts} 
    </c:if> 
    <c:if test="${empty list }">0</c:if>
    </span>条记录
</div>

<div class="margin-auto width-1200  data-box">
<div class="margin-cxjg">
  <table class="margin-cxjg_table" border="0" cellspacing="0" cellpadding="0">
    <tr class="thead">
      <td>邮件单号</td>
      <td>收件人姓名</td>
      <td>物品名称</td>
      <td>寄件国/地区</td>
      <td>物品数量</td>
      <td>物品重量</td>
      <td>处理方式</td>
      <td>处理状态</td>
      <td>截获时间</td>
	  <td>检疫人员</td>	
	  <td>列入黑名单</td>				
      <td>操作</td>
    </tr>
    <c:if test="${not empty list }">
		<c:forEach items="${list}" var="row">
			<tr class="thead_nr">
			  <td width="130" height="90" align="center"><strong>${row.package_no}</strong></td>
		      <td width="100" height="90" align="center">${row.consignee_name}</td>
		      <td width="100" height="90" align="center">${row.cago_name }</td>
		      <td width="180" height="90" align="center">${row.consignor_country }</td>
		      <td width="80" height="90" align="center">${row.cago_num }</td>
		      <td width="100" height="90" align="center">${row.cago_weight }<span class="gary">（总重）</span></td>
		      <td width="100" height="90" align="center">${row.deal_name }</td>
		      <td width="100" height="90" align="center">
			      <c:if test="${row.deal_status == 0}">
			      	未完结
			      </c:if>
			      <c:if test="${row.deal_status == 1}">
			      	已完结
			      </c:if>
		      </td>
		      <td width="100" height="90" align="center"><fmt:formatDate value="${row.intrcept_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/></td>
		      <td width="100" height="90" align="center">${row.insp_user }</td>
		      <td width="100" height="35" align="center">
		      <c:if test="${not empty decl_no }">
		      	是
		      </c:if>
		      <c:if test="${empty decl_no }">
		      	否
		      </c:if>
		      </td>
		      <td height="90" align="center" valign="middle">
			      <a href='javascript:jumpPage("/ciqs/mail/toMailObjCheckDetail?id=${row.id}&package_no=${row.package_no}");'>
			      	<span class="data-btn margin-auto">详细+</span>
			      </a>
		      </td>
			</tr>
		</c:forEach>
	</c:if>
    <tfoot >
       <jsp:include page="/common/pageUtil.jsp" flush="true"/>
    </tfoot>  
  </table>
  </div>
</div>
<div class="margin-auto width-1200 tips" ></div>
</body>

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
</html>
