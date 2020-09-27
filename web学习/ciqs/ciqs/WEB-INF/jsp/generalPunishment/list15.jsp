<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>一般处罚</title>
<%@ include file="/common/resource_show.jsp"%>
<script type="text/javascript"> 
		function pageUtilNew(page) {
/* 			$("#search_form").attr("action", "/ciqs/generalPunishment/listNew?page="+page);
			$("#search_form").submit(); */
			var step = "15";
			var tempform = document.createElement("form");
			tempform.action = $("#search_form").attr("action");
		    tempform.method = "post";
		    tempform.style.display="none";
		    
			var wList = new Array();
			$.each($("#search_form").serializeArray(),function(){
				if(this.name.indexOf("t.") >= 0 || this.name.indexOf("sv.") >= 0){
					var map = {};
					var name = this.name;
					var key = "";
					if(this.name){
						if(this.name.indexOf("date_begin") != -1){
							name = "sv.step_"+1+"_date";
							key = "sv.step_"+1+"_date_begin"
						}
						if( this.name.indexOf("date_end") != -1){
							name = "sv.step_"+1+"_date";
							key = "sv.step_"+1+"_date_end"
						}
					}
					map.wName = name;
					map.key = key;
					map.wValue = this.value;
					map.wOpera = (this.opera) ? this.opera : "";
					wList.push(map)
				}else{
			   	   var opt1 = document.createElement("input");
				   opt1.name = this.name;
				   opt1.value = this.value;
				   tempform.appendChild(opt1);
				}
			});
		   
		   	var opt3 = document.createElement("input");
	   		opt3.name = "wListStr";
	  		opt3.value = JSON.stringify(wList);
	   		tempform.appendChild(opt3);
	   
   		   var opt4 = document.createElement("input");
		   opt4.name = "page";
		   opt4.value = page;
		   tempform.appendChild(opt4);
		   
		   var opt = document.createElement("input");
		   opt.type = "submit";
		   tempform.appendChild(opt);
		   document.body.appendChild(tempform);
		   tempform.submit();
		   document.body.removeChild(tempform);   
		}

/* 	function search(){
  
	} */
	function reSet(){
		$("#case_no,#comp_name,#step_7_date_begin,#step_7_date_end").val('');
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
<!-- 
<div class="title"><a href="nav.html" class="white"><span  class="font-24px">一般处罚</span>/调查报告局审批</a></div>
 -->
<div class="title"><span class="font-24px" style="color:white;">行政处罚/</span><a id="title_a" href="/ciqs/generalPunishment/listNew?step=15">一般处罚</a></div>
<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
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
<li></li>
<li></li>
</ul>
<ul>
	<li><img src="${ctx}/static/show/images/generalPunishment/generalPunishmentA1.png" width="107" height="107" content="通过现场勘察搜集相关违法证据。业务部门获取证据后，将相关材料移交稽查部门。记录内容包括：《现场勘验笔录》及《检验检疫涉嫌案件申报单》。"/></li>
	<li><img src="${ctx}/static/show/images/generalPunishment/generalPunishmentA2.png" width="107" height="107" content="稽查部门接到移交的案件后，及时对有关案卷材料进行书面审核。决定不予立案的，应当将不予立案理由、依据等事项书面告知提供案源的单位和个人。记录内容包括：《行政处罚案件立案审批表》。"/></li>
	<li><img src="${ctx}/static/show/images/generalPunishment/generalPunishmentA3.png" width="107" height="107" content="案件调查人员对行政相对人进行调查取证过程中，应着统一执法制式服装，不得少于2人，佩戴执法记录仪。记录内容包括：《调查笔录》、《调查通知书》、《现场勘验笔录》、《行政执法抽样通知书》、登记保存、查封、扣押、封存等措施决定书及《行政处罚案件调查报告》。"/></li>
	<li><img src="${ctx}/static/show/images/generalPunishment/generalPunishmentA4.png" width="107" height="107" content="需要做出行政处罚决定的，由法制工作部门填写《行政处罚案件办理审批表》，报部门负责人、局领导审查批准，批准后制作《行政处罚告知书》、《行政处罚决定书》。"/></li>
	<li><img src="${ctx}/static/show/images/generalPunishment/generalPunishmentA5.png" width="107" height="107" content="法制部门应当制作《行政处罚告知书》和《送达回证》。行政相对人进行签收。做出处罚决定后，应当制作《行政处罚决定书》和《送达回证》。做出原处罚决定的出入境检验检疫机构或者其上级机构发现原处罚决定确有错误，撤销或者变更原处罚决定时应制作《撤销（变更）行政处罚决定书》。"/></li>
	<li><img src="${ctx}/static/show/images/generalPunishment/generalPunishmentA6.png" width="107" height="107" content="做出原处罚决定的出入境检验检疫机构或者其上级机构发现原处罚决定确有错误，撤销或者变更原处罚决定时应制作《撤销（变更）行政处罚决定书》。"/></li>
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
<form action="/ciqs/generalPunishment/listNew"  method="post" id="search_form">
<input type="hidden" name="step" value="15"/>
<table width="100%" border="0" class="table-search margin-auto">
  <tr>
  	<td height="25" align="left" valign="middle">立案号</td>
  	<td height="25" align="left" valign="middle">单位名称</td>
  	<td height="25" align="left" valign="middle">申报时间（起）</td>
    <td height="25" align="left" valign="middle">申报时间（止）</td>
    <td height="25" align="left" valign="middle">业务处/办事处</td>
  </tr>
  <tr>
    <td width="195" height="50" align="left" valign="middle"><input type="text" name="t.case_no" id="case_no"size="14" value="${case_no}" class="search-input input-175px" /></td>
    <td width="195" height="50" align="left" valign="middle"><input type="text" name="t.comp_name" id="comp_name"size="14" value="${comp_name}" class="search-input input-175px" /></td>
    <td width="196" height="50" align="left"><input name="sv.step_1_date_begin" opera=">=" type="text" class="search-input input-175px datepick" id="step_7_date_begin" value="${step_1_date_begin}"/></td>
    <td width="196" height="50" align="left"><input name="sv.step_1_date_end" opera="<=" type="text" class="search-input input-175px datepick" id="step_7_date_end" value="${step_1_date_end}"/></td>
    <td width="195" height="50" align="left">
	    <select id="step_1_org" class="search-input input-175px" name="org_code">
	    	<c:forEach items="${orgList}" var="l">
				<option <c:if test="${l.code == form.org_code }">selected="selected"</c:if> value="${l.code }">${l.name }</option>
	    	</c:forEach>
		</select>
    </td>
  </tr>
  <tr>
	<td></td>
	<td></td>
	<td style="width:250px">
		<input type="button" class="search-btn fo" value="搜索" style="cursor: pointer;" onclick="pageUtilNew('1')"/>
	</td>
	<td>	
		<input type="button" class="search-btn fo" value="清空" onclick="reSet();" style="cursor: pointer;"/>
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
 	  <td width="0" style="display: none;"></td>
      <td>立案号</td>
      <td>单位名称</td>
      <td>申报时间</td>
      <td>业务处/办事处</td>
      <td>立案审批状态</td>
      <td>详情</td>
    </tr>
    <c:if test="${not empty list }">
		<c:forEach items="${list}" var="row">
			<tr>
			  <td width="0" style="display: none;" height="90" align="center">${row.PRE_REPORT_NO}</td>
			  <td width="100" height="30" align="center">${row.CASE_NO}</td>
			  <td width="100" height="30" align="center">${row.COMP_NAME }</td>
		      <td width="80" height="30" align="center"><fmt:formatDate value="${row.STEP_1_DATE }" type="both" pattern="yyyy-MM-dd"/></td>
		      <td width="100" height="30" align="center"><%-- ${row.STEP_1_ORG } --%>${row.DECLARE_ORG_NAME }</td>
		      <td width="90" height="30" align="center">
		      	<c:if test="${empty row.STEP_7_STATUS}">未审核</c:if>
				<c:if test="${'0' == row.STEP_7_STATUS}">未审核</c:if>
				<c:if test="${'1' == row.STEP_7_STATUS}">立案</c:if>
				<c:if test="${'2' == row.STEP_7_STATUS}">不立案</c:if>
				<c:if test="${'15' == row.STEP_7_STATUS}">移送</c:if>
			  </td>
		      <td width="80" height="30" align="center" valign="middle">
			      <a href='javascript:jumpPage("/ciqs/generalPunishment/detail?id=${row.ID}&step=15&main_id=${row.MAIN_ID }");'>
			      	<span class="data-btn margin-auto">详细+</span>
			      </a>
		      </td>
			</tr>
		</c:forEach>
	</c:if>
	<tfoot >
       <jsp:include page="/common/pageNewUtil.jsp" flush="true"/>
    </tfoot>
  </table>
  </div>
</div>
<div class="margin-auto width-1200 tips" ></div>
</body>
<script type="text/javascript">
    $("li").mouseenter(function () {
        var img = $(this).find("img");
        var str = img.attr("content");
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
