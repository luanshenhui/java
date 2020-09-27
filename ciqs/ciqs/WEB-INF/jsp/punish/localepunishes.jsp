<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>简易处罚</title>
<%@ include file="/common/resource_show.jsp"%>
<script type="text/javascript">
function pageUtil(page){
     $("form").attr("action", "/ciqs/punish/localepunishes?page="+page);
	 $("form").submit();
}
//视频观看
/* function showVideo(path){
    $("#CuPlayerMiniV").show();
    var so = new SWFObject("/ciqs/cuplayer/CuPlayerMiniV3_Black_S.swf","CuPlayer","600","400","9","#000000");
	so.addParam("allowfullscreen","true");
	so.addParam("allowscriptaccess","always");
	so.addParam("wmode","opaque");
	so.addParam("quality","high");
	so.addParam("salign","lt");
	so.addVariable("CuPlayerFile","http://localhost:7001/ciqs/showVideo?imgPath="+path);
	so.addVariable("CuPlayerImage","/ciqs/cuplayer/Images/flashChangfa2.jpg");
	so.addVariable("CuPlayerLogo","/ciqs/cuplayer/Images/Logo.png");
	so.addVariable("CuPlayerShowImage","true");
	so.addVariable("CuPlayerWidth","600");
	so.addVariable("CuPlayerHeight","400");
	so.addVariable("CuPlayerAutoPlay","false");
	so.addVariable("CuPlayerAutoRepeat","false");
	so.addVariable("CuPlayerShowControl","true");
	so.addVariable("CuPlayerAutoHideControl","false");
	so.addVariable("CuPlayerAutoHideTime","6");
	so.addVariable("CuPlayerVolume","80");
	so.addVariable("CuPlayerGetNext","false");
	so.write("CuPlayer");
} */
function shes_clear(){
	$("#start_date").val("");
	$("#end_date").val("");
	$("#party_name").val("");
	$("#illegal_content").val();
	$("#punish_style").val("");
	
}
</script>
    <style type="text/css">
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
        table tr td{
        text-align:left;
        }
    </style>
</head>
<body  class="bg-gary">
<div class="freeze_div_list">
<div class="title-bg" >
<div class=" title-position margin-auto white">
<div class="title"><span class="font-24px" style="color:white;">行政处罚 /</span><a style="color:white;" href="localepunishes">简易处罚</a></div>
<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
</div>
</div>

<div class="flow-bg" >
<div class="flow-position margin-auto" >

<ul class="white font-18px flow-height font-weight">
	<li>申报</li>
	<li>现场处罚</li>
</ul>
<ul>
  <li><img src="${ctx}/static/show/images/punish/punishA1.png" width="107" height="103" content="业务部门获取证据后，将随附单据移交稽查部门。记录内容包括：《现场勘验笔录》、现场勘验所采集的图片、音像资料以及纸质《检验检疫涉嫌案件申报单》、案件相关报检单、合同、箱单等。" /></li>
  <li><img src="${ctx}/static/show/images/punish/punishA2.png" width="107" height="103" content="现场执法人员在发现涉案违法线索或行为后，对于“违法事实清晰，适用简易处罚程序”的，可以当场做出处罚决定。记录内容：《当场收缴罚款申请书》。"/></li>
</ul>
</div>
</div>

</div>
<div class="blank_div_list">
</div>
<div class="margin-auto width-1200 search-box">
    <div id="alertBoxId" class="box-img-bg"><span class="box-content-style" id="alertContentId"></span></div>
<form action="" id="form" method="post">
<table width="100%" border="0" class="table-search margin-auto">
  <tr>
    <td height="25">开始时间</td>
    <td height="25">结束时间</td>
    <td height="25" align="left" valign="middle">当事人名称</td>
    <td height="25" align="left" valign="middle">违法法规内容</td>
    <td height="25" align="left" valign="middle">处罚方式</td>
    <td height="25">&nbsp;</td>
  </tr>
  <tr>
    <td width="160" height="50"><input name="start_date" type="text" class="search-input input-140px datepick dp-applied" id="start_date" value="${map.start_date}"/></td>
    <td width="185" height="50"><input name="end_date" type="text" class="search-input input-140px datepick" id="end_date" value="${map.end_date}"/></td>
    <td width="195" height="50" align="left" valign="middle"><input name="party_name" type="text" class="search-input input-175px" id="party_name" value="${map.party_name}"/></td>
    <td width="220" height="50" align="left" valign="middle"><input name="illegal_content" type="text" class="search-input input-175px" id="illegal_content" value="${map.illegal_content}"/></td>
    <td width="185" height="50" align="left" valign="middle">
       <select name="punish_style" class="search-input input-140px" id="punish_style">
            <option value="">无</option>
            <option value="0"<c:if test="${map.punish_style=='0'}">selected="selected"</c:if>>警告</option>
            <option value="1"<c:if test="${map.punish_style=='1'}">selected="selected"</c:if>>罚款</option>
       </select>
    </td>
  </tr>
  <tr>
    <td colspan="2" height="25" align="left" valign="middle">直属局</td>
    <td colspan="2" height="25" align="left" valign="middle">分支机构</td>
  </tr>
  <tr>
    <td colspan="2" width="300" height="50" align="left" valign="middle">
       <select name="port_org_code"  class="search-input input-175px" id="port_org_code" style="width:300px;">
           <c:if test="${not empty organizes}">
                <c:forEach items="${organizes}" var="organize">
                     <option value="${organize.code}" <c:if test="${map.port_org_code==organize.code}">selected="selected"</c:if>>${organize.name}</option>
                </c:forEach>   
           </c:if>
       </select>
    </td>
    <td colspan="2" width="220" height="50" align="left" valign="middle">
         <select name="port_dept_code" class="search-input input-175px" id="port_dept_code" style="width:300px;">
               <c:if test="${not empty deptments}">
			         <c:forEach items="${deptments}" var="deptment">
			              <option value="${deptment.code}" <c:if test="${map.port_dept_code==deptment.code}">selected="selected"</c:if>>${deptment.name}</option>
			         </c:forEach>   
			    </c:if>
         </select>
    </td>
    <td></td>
  </tr>
  <tr>
	<td></td>
	<td></td>
	<td style="width:250px">
		<input type="submit" class="search-btn fo" value="搜索" style="cursor: pointer;" onclick="pageUtil('1')"/>
	</td>
	<td>	
		<input type="button" onclick="shes_clear();" class="search-btn fo" value="清空" style="cursor: pointer;"/>
	</td>
	<td></td>
  </tr> 
</table>
</form>

</div>

<div class="margin-auto width-1200 tips" >共找到<span class="yellow font-18px" id="counts">${counts}</span>条记录</div>
<div class="margin-auto width-1200  data-box">
<div class="margin-cxjg">
<table class="margin-cxjg_table" border="0" cellspacing="0" cellpadding="0">
 	<tr class="thead">
      <td>处罚时间</td>
      <td>当事人名称</td>
      <td>违法法规内容</td>
      <td>处罚方式</td>
      <td>直属局</td>
      <td>分支机构</td>
      <td>操作</td>
    </tr>
	   <tbody>
	       <c:forEach items="${results}" var="result">
		        <tr>
					<td width='100px' height='90' align='center'><strong><span class='gary'><fmt:formatDate value="${result.punish_time}" type="both" pattern="yyyy-MM-dd"/></span></strong></td>
					<td width='100px' height='90' align='center'>${result.party_name}</td>
					<td width='200px' height='90' align='center'>${result.illegal_content}</td>
					<td width='100px' height='90' align='center' class=' green'>${result.punish_style=='0'?"警告":"罚款"}</td>
					<td width='150px' height='90' align='center'>${result.port_org_code}</td>
					<td width='150px' height='90' align='center'>${result.port_dept_code}</td>
					<td width='50px' height='90' align='center' valign='middle'><a href='localepunishinfojsp?punish_id=${result.punish_id}'><span class='data-btn margin-auto' style='width:50px'>详细+</span></a></td>
			    </tr>
	       </c:forEach>
	   </tbody> 
	   <tfoot>
	       <jsp:include page="/common/pageUtil.jsp" flush="true"/>
	   </tfoot>
  </table>
  </div>
</div>
<div class="margin-auto width-1200 tips" ></div>
<!--酷播迷你 CuPlayerMiniV3.0 代码开始-->
<!-- <div id="CuPlayerMiniV" style="width:620px;height:500px;position: fixed;left:35%;top:30%;margin:-100px 0px 0px -100;z-index:300000;visibility: hidden;">
		<div style="width:30px;margin:0px 500px 0px 602px;background:white;cursor: pointer;" onclick="hideVideo()">关闭</div>
		<div id="CuPlayer" style="position: fixed;left:35%;top:30%;margin:-100px 0px 0px -100;z-index:300000;"></div> 
		<strong>提示：您的Flash Player版本过低！</strong> 
</div> -->
<%@ include file="/common/player.jsp"%>
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