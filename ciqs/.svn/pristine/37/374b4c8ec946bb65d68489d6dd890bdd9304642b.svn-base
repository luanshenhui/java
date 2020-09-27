<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>全过程查询</title>
<%@ include file="/common/resource_show.jsp"%>
<script type="text/javascript"> 
		function pageUtil(page) {
			$("#cp_form").attr("action", "/ciqs/cp/findLists?page="+page);
			$("#cp_form").submit();
		}
		function cpFormSubmit() {
			$("#cp_form").attr("action", "/ciqs/cp/findLists");
			$("#cp_form").attr("method", "post");
			$("#cp_form").submit();
		}
		function reset(){
			$("#comp_name").val("");
			$("#startDeclare_date").val("");
			$("#endDeclare_date").val("");
			$("#port_org_code").val("");
			$("#review_result").val("");
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
<div class="title"><span class="font-24px" style="color:white;">行政许可 /</span><a id="title_a" href="/ciqs/cp/findLists">口岸卫生许可证核发</a></div>
<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
</div>
</div>
<div class="flow-bg" >
<div class="flow-position margin-auto" >

<ul class="white font-18px flow-height font-weight">
<li>申报</li>
<li>受理</li>
<li>审查</li>
<li>决定与送达</li>
<li>期限与公示</li>
<!-- <li>变更、延续、补发</li> -->
<li>终止、撤销、注销 </li>
<li></li><li></li>
</ul>
<ul>
  <li><img src="${ctx}/static/show/images/cp/cpA1.png" width="107" height="103" content="卫生许可证的申请人通过“国境口岸卫生许可全过程记录”系统进行申请，按照企业的经营类型提交相应的申请材料。记录内容包括：《卫生许可证申请书》。"/></li>
  <li><img src="${ctx}/static/show/images/cp/cpA2.png" width="107" height="103" content="检验检疫机构通过“记录系统”对申请人提出的卫生许可申请，以电子文书记录形式决定是否受理卫生许可申请。记录内容包括：《国境口岸卫生许可工作“流程卡”》和《质量监督检验检疫行政许可申请材料接收清单》。"/></li>
  <li><img src="${ctx}/static/show/images/cp/cpA3.png" width="107" height="103" content="检验检疫机构应当对申请人提交的申请材料内容的完整性、有效性进行审查。依据相应类型的《卫生许可现场评审表》对企业的卫生状况、设备设施以及质量安全控制能力等进行现场审查，并填写现场审查监督电子笔录作为电子文书记录。"/></li>
  <li><img src="${ctx}/static/show/images/cp/cpA4.png" width="107" height="103" content="检验检疫机构应当根据申请材料审查和现场审查结果，对符合条件的，做出准予行政许可的决定。对不符合条件的，做出不予行政许可的决定。记录内容包括：《质量监督检验检疫准予行政许可决定书》及《质量监督检验检疫不予行政许可决定书》。"/></li>
  <li><img src="${ctx}/static/show/images/cp/cpA5.png" width="107" height="103" content="检验检疫机构应当自受理申请之日起20个工作日内做出行政许可决定。如有特殊原因可延长10个工作日。对准予行政许可决定的，检验检疫机构应当自做出决定之日起10个工作日内向申请人颁发卫生许可证。定期公示卫生许可结果作为电子文书记录。"/></li>
  <li>
<!--   <img src="${ctx}/static/show/images/cp/cpA6.png" width="107" height="103" content="生产经营者通过“记录系统”提交变更申请书，并上传变更说明和变更前后验证材料。申请人通过“记录系统”提交延续电子申请书。提供材料包括：卫生许可证申请书、原卫生许可证复印件、原申请提交材料是否发生变化的说明材料。生产经营者即通过“记录系统”申请补发，并上传公开声明佐证材料。原发证机构应当对材料进行审核，准予补发的，颁发新的卫生许可证，原卫生许可证号及有效期限不变。"/> -->
  </li>
  <li><img src="${ctx}/static/show/images/cp/cpA7.png" width="107" height="103" content="在依法应当终止办理卫生许可的情况下，检验检疫机构应当终止办理卫生许可。在依法可以撤销卫生许可的其他情形情况下，检验检疫机构应当依法撤销被许可人取得的卫生许可。在法律、法规规定的应当注销卫生许可的情形下，检验检疫机构应当依法办理卫生许可的注销手续。"/></li>
  <li></li>
</ul>
</div>
</div>
</div>
<div class="blank_div_list">
</div>
<div class="margin-auto width-1200 search-box">
	<div id="alertBoxId" class="box-img-bg"><span class="box-content-style" id="alertContentId"></span></div>
<form action="/ciqs/cp/findLists"  method="post" id="cp_form">
<table width="100%" border="0" class="table-search margin-auto">
  <tr>
    <td height="25" align="left" valign="middle">企业名称</td>
    <td height="25" align="left" >开始时间</td>
    <td height="25" align="left" >结束时间</td>
    <td height="25"></td>
  </tr>
  
  <tr>
	<td align="left">
		<input type="text" name="comp_name" id="comp_name" size="14" class="search-input input-175px" value="${comp_name}"/>
	</td>
	<td align="left">
		<input type="text" size="14" class="search-input input-175px datepick" name="startDeclare_date" id="startDeclare_date" value="${startDeclare_date}"/>
	</td>
	<td align="left">
		<input type="text" size="14" class="search-input input-175px datepick" name="endDeclare_date" id="endDeclare_date" value="${endDeclare_date}"/>
	</td>
  </tr>
 
  <tr>
    <td height="25" align="left" >受理局</td>
    <td height="25" align="left" >审查结果</td>
    <td height="25">&nbsp;</td>   
  </tr>
  
  <tr>
    <td align="left">
	    <select id="port_org_code" class="search-input input-175px" name="port_org_code">
			<option value=""></option>
			<c:if test="${not empty allorgList }">
				<c:forEach items="${allorgList}" var="row">
					<c:if test="${port_org_code == row.code}">
						<option selected="selected" value="${row.code}">${row.name}</option>
					</c:if>
					<c:if test="${port_org_code != row.code}">
						<option value="${row.code}">${row.name}</option>
					</c:if>
				</c:forEach>
			</c:if>
		</select>
	</td>
	<td align="left">
		<select name="review_result" class="search-input input-175px" id="review_result">
			<option value=""></option>
			<option value="0" <c:if test="${review_result == '0'}">selected="selected"</c:if>>合格</option>
			<option value="1" <c:if test="${review_result == '1'}">selected="selected"</c:if>>不合格</option>
		</select>
	</td>
  </tr>
  <tr>
  	<td style="width:30%"></td>
	<td style="width:26%;padding-top:8px;">
		<input type="submit" class="search-btn fo" value="搜索" style="cursor: pointer;" onclick="cpFormSubmit()" />
	</td>
	<td>	
		<input type="button" class="search-btn fo" value="清空" style="cursor: pointer;" onclick="reset()" />
	</td>
	<td></td>
  </tr>
</table>
</form>
</div>

<div class="margin-auto width-1200 tips" >共找到<span class="yellow font-18px" >  ${counts}  </span>条记录</div>
<div class="margin-auto width-1200  data-box">
<div class="margin-cxjg">
  <table class="margin-cxjg_table" border="0" cellspacing="0" cellpadding="0">
    <tr class="thead">
		<td>企业名称</td>
		<td>联系人</td>
		<td>联系电话</td>
		<td>经营类别 </td>
		<td>申请经营范围</td>
		<td>审查组人员</td>
		<td>审查结果</td>
	    <td>审查时间</td>		    
        <td>操作</td>
    </tr>
    <c:if test="${not empty list }">
		<c:forEach items="${list}" var="row">
			<tr class="thead_nr">
			  <td width="100" height="90" align="center"><strong> ${row.comp_name}</strong></td>
		      <td width="100" height="90" align="center">${row.contacts_name}</td>
		      <td width="100" height="90" align="center">${row.contacts_phone }</td>
		      <td width="100" height="35" align="center">
		      	<c:forEach items="${row.management_type}" var="items" varStatus="aa">
					<c:if test="${aa.index != 0}">
						,
					</c:if>
					<c:if test="${items == 1}">
						食品生产
					</c:if>
					<c:if test="${items == 2}">
						食品流通
					</c:if>
					<c:if test="${items == 3}">
						餐饮服务
					</c:if>
					<c:if test="${items == 4}">
						饮用水供应
					</c:if>
					<c:if test="${items == 5}">
						公共场所
					</c:if>
				</c:forEach>
		      </td>
		      <td width="100" >${row.apply_scope}</td>
		      <td width="100" >${row.approval_users_name}</td>
		      <td width="100" >
			      <c:if test="${row.review_result == 1}">
			     		 不合格
			      </c:if>
				  <c:if test="${row.review_result == 0}">
			      		合格
			      </c:if>				
			  </td>
		      <td width="100" height="90" align="center">${row.review_date}</td>
		     
		      <td width="100" height="90" align="center" valign="middle">
			      <a href='javascript:jumpPage("/ciqs/cp/toCompleteProcessDetail?id=${row.id}&license_dno=${row.license_dno}");'>
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
