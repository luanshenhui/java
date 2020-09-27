<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>一般处罚/稽查受理</title>
<%@ include file="/common/resource_show.jsp"%>
<script type="text/javascript"> 
		function submit() {
			$("#search_form").submit();
		}
</script>
<style type="text/css">
input.datepick{background:#FFF url(/ciqs/static/dec/images/dpn.date.pick.gif) no-repeat right}
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
<div class="title"><a href="nav.html" class="white"><span  class="font-24px">一般处罚</span>/稽查受理</a></div>
<div class="user-info">你好[${user.name }]，欢迎登录系统     |      退出</div>
</div>
</div>
<div class="flow-bg" >
<div class="flow-position margin-auto" >

<ul class="white font-18px flow-height font-weight">
<li>线索移送</li>
<li>立案申报</li>
<li>调查取证</li>
<li>审理决定</li>
<li>送达执行</li>
<li>结案归档</li>
</ul>
<ul>
  <li><img src="${ctx}/static/show/images/generalPunishment/generalPunishmentA1.png" width="107" height="107" content="通过现场勘察搜集相关违法证据。业务部门获取证据后，将相关材料移交稽查部门。记录内容包括：《现场勘验笔录》及《检验检疫涉嫌案件申报单》。"/></li>
  <li><img src="${ctx}/static/show/images/generalPunishment/generalPunishmentA2.png" width="107" height="107" content="稽查部门接到移交的案件后，及时对有关案卷材料进行书面审核。决定不予立案的，应当将不予立案理由、依据等事项书面告知提供案源的单位和个人。记录内容包括：《行政处罚案件立案审批表》。"/></li>
  <li><img src="${ctx}/static/show/images/generalPunishment/generalPunishmentA3.png" width="107" height="107" content="案件调查人员对行政相对人进行调查取证过程中，应着统一执法制式服装，不得少于2人，佩戴执法记录仪。记录内容包括：《调查笔录》、《调查通知书》、《现场勘验笔录》、《行政执法抽样通知书》、登记保存、查封、扣押、封存等措施决定书及《行政处罚案件调查报告》。"/></li>
  <li><img src="${ctx}/static/show/images/generalPunishment/generalPunishmentA4.png" width="107" height="107" content="需要做出行政处罚决定的，由法制工作部门填写《行政处罚案件办理审批表》，报部门负责人、局领导审查批准，批准后制作《行政处罚告知书》、《行政处罚决定书》。"/></li>
  <li><img src="${ctx}/static/show/images/generalPunishment/generalPunishmentA5.png" width="107" height="107" content="法制部门应当制作《行政处罚告知书》和《送达回证》。行政相对人进行签收。做出处罚决定后，应当制作《行政处罚决定书》和《送达回证》。做出原处罚决定的出入境检验检疫机构或者其上级机构发现原处罚决定确有错误，撤销或者变更原处罚决定时应制作《撤销（变更）行政处罚决定书》。"/></li>
  <li><img src="${ctx}/static/show/images/generalPunishment/generalPunishmentA6.png" width="107" height="107" content="做出原处罚决定的出入境检验检疫机构或者其上级机构发现原处罚决定确有错误，撤销或者变更原处罚决定时应制作《撤销（变更）行政处罚决定书》。"/></li>
</ul>
</div>
</div>
</div>
<div class="blank_div_list">
</div>
<div class="margin-auto width-1200 search-box">
	<div id="alertBoxId" class="box-img-bg"><span class="box-content-style" id="alertContentId"></span></div>
<form action="/ciqs/generalPunishment/update_3"  method="post" id="search_form">
<table width="100%" border="0" class="table-search margin-auto">
  <tr>
  	<td height="25" align="left" valign="middle">单位名称</td>
  	<td height="25" align="left" valign="middle">姓名</td>
  	<td height="25" align="left" valign="middle">性别</td>
  	<td height="25" align="left" valign="middle">出生年月</td>
  </tr>
  <tr>
    <td width="195" height="50" align="left" valign="middle">
    	<input type="hidden" id="id" name="id" value="${model.id}"/>
    	<input type="hidden" id="pre_report_no" name="pre_report_no" value="${model.pre_report_no}"/>
    	<input type="text" name="comp_name" id="comp_name"size="14" value="${model.comp_name}" class="search-input input-175px" />
    </td>
    <td width="195" height="50" align="left" valign="middle"><input type="text" name="psn_name" id="psn_name"size="14" value="${model.psn_name}" class="search-input input-175px" /></td>
    <td width="195" height="50" align="left" valign="middle">
    	
    	<select id="gender" class="search-input input-175px" name="gender">
			<c:if test="${empty model.gender}">
				<option selected="selected" value="0">不详</option>
			</c:if>
			<c:if test="${not empty model.gender}">
				<option value="0">不详</option>
			</c:if>
			<c:if test="${'1' == model.gender}">
				<option selected="selected" value="1">男</option>
			</c:if>
			<c:if test="${'1' != model.gender}">
				<option value="1">男</option>
			</c:if>
			<c:if test="${'2' == model.gender}">
				<option selected="selected" value="2">女</option>
			</c:if>
			<c:if test="${'2' != model.gender}">
				<option value="2">女</option>
			</c:if>
		</select>
    </td>
    <td width="160" height="50" align="left"><input name="birth" type="text" class="search-input input-175px datepick" id="birth" value="${model.birth}"/></td>
  </tr>
  <tr>
  	<td height="25" align="left" valign="middle">国籍</td>
    <td height="25" align="left" valign="middle">法定代表人</td>
    <td height="25" align="left" valign="middle">住址或地址</td>
    <td height="25" align="left" valign="middle">电话</td>
  </tr>
  <tr>
  	<td width="195" height="50" align="left" valign="middle"><input type="text" name="nation" id="nation"size="14" value="${model.nation}" class="search-input input-175px" /></td>
    <td width="195" height="50" align="left" valign="middle"><input type="text" name="corporate_psn" id="corporate_psn"size="14" value="${model.corporate_psn}" class="search-input input-175px" /></td>
    <td width="195" height="50" align="left" valign="middle"><input type="text" name="addr" id="addr"size="14" value="${model.addr}" class="search-input input-175px" /></td>
    <td width="195" height="50" align="left" valign="middle"><input type="text" name="tel" id="tel"size="14" value="${model.tel}" class="search-input input-175px" /></td>
  </tr>
  <tr>
  	<td height="50" colspan="4" align="center">
    	<span style="cursor: pointer;" class="search-btn fo" onclick="submit()" >提交</span>
    </td>
  </tr>
</table>
</form>
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
