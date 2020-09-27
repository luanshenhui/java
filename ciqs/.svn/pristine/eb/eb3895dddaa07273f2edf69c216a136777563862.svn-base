<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>出口食品生产企业备案</title>
<%@ include file="/common/resource_show.jsp"%>
<style type="text/css">
input.datepick{background:#FFF url(/ciqs/static/dec/images/dpn.date.pick.gif) no-repeat right}
a:link, a:visited {
    color:white;
    text-decoration: none;
}
</style>
<script type="text/javascript"> 
	function pageUtil(page) {
		$("#orig_place").attr("action", "/ciqs/origplace/origList?page=" + page);
		$("#orig_place").submit();
	}
</script>
</head>
<body  class="bg-gary">
	<div class="freeze_div_list">
		<div class="title-bg">
			<div class=" title-position margin-auto white">
				<div class="title">
				<span class="font-24px" style="color:white;">行政许可 /</span><a id="title_a" href="/ciqs/expFoodPOF/expFoodList">出口食品生产企业备案</a>
				</div>
				<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
			</div>
		</div>
	</div>
<%-- <%@ include file="myOrg.jsp"%> --%>
<div class="blank_div_dtl" style="height: 70px">
</div>
	<div class="margin-auto width-1200  data-box">
  	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="gary">
	   <tr>
	      <td height="70" width="5%" align="center"  class="flow-td-bord" valign="middle">序号</td>
	      <td height="70" width="70%" align="center" style="font-size: 40px;color: #333;" class="flow-td-bord" valign="middle">标题</td>
	      <td height="70" width="25%" align="center"  class="flow-td-bord" valign="middle">&nbsp;</td>
	   </tr>
  	</table>
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-data">
			<c:if test="${not empty list }">
				<c:forEach items="${list}" var="row" begin="0" varStatus="st">
					<tr>
						<td width="5%" height="70" class="flow-td-bord" align="center" valign="middle">菜单${st.index+1}</td>
						<td width="70%"  class="flow-td-bord" height="70" align="center" class="font-18px"><%-- ${row.check_menu_type}: --%>${row.check_title}</td>
						<td width="25%" height="70"  class="flow-td-bord" align="center" valign="middle">
						<a href='javascript:jumpPage("/ciqs/expFoodPOF/toTextView?apply_no=${apply_no}&check_menu_type=${row.check_menu_type}");'>
						<span class="data-btn margin-auto">详细+</span></a></td> 
					</tr>
			</c:forEach>
		</c:if>
		<tr>
			<td width="5%" height="70" class="flow-td-bord" align="center" valign="middle">菜单12</td>
			<td width="70%"  class="flow-td-bord" height="70" align="center" class="font-18px">其他</td>
			<td width="25%" height="70"  class="flow-td-bord" align="center" valign="middle">
			<a href='javascript:jumpPage("/ciqs/expFoodPOF/toTextViewQt?apply_no=${apply_no}&check_menu_type=${compName}");'>
			<span class="data-btn margin-auto">详细+</span></a></td> 
		</tr>
		<tr>
			<td width="5%" height="70" class="flow-td-bord" align="center" valign="middle">菜单13</td>
			<td width="70%"  class="flow-td-bord" height="70" align="center" class="font-18px">不符合项跟踪报告</td>
			<td width="25%" height="70"  class="flow-td-bord" align="center" valign="middle">
			<a href='javascript:jumpPage("/ciqs/expFoodPOF/unPassable?apply_no=${apply_no}&compName=${compName}");'>
			<span class="data-btn margin-auto">详细+</span></a></td> 
		</tr>
	 </table>
</div>
<div class="margin-auto width-1200 tips" ></div>
</body>
</html>
