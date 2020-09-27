<%@page import="com.dpn.ciqqlc.common.util.YbcfStatusEnum"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>一般处罚/
			<c:if test="${step == '1' }">线索申报</c:if>
			<c:if test="${step == '2' }">线索预审批</c:if>
			<c:if test="${step == '3' }">稽查受理</c:if>
			<c:if test="${step == '5' }">法制受理</c:if>
			<c:if test="${step == '7' }">立案审批</c:if>
			<c:if test="${step == '9' }">调查取证/初审</c:if>
			<c:if test="${step == '18' }">调查取证/复审</c:if>
			<c:if test="${step == '19' }">调查取证/终审</c:if>
			<c:if test="${step == '10' }">审理决定/初审</c:if>
			<c:if test="${step == '11' }">审理决定/终审</c:if>
			<c:if test="${step == '12' }">审理决定/终审</c:if>
			<c:if test="${step == '13' }">送达执行</c:if>
			<c:if test="${step == '14' }">结案归档</c:if>
</title>
	<!-- jqGrid组件基础样式包-必要 -->
	<link rel="stylesheet" href="${ctx}/static/jqgrid/css/ui.jqgrid.css" />
<%@ include file="/common/resource_new.jsp"%>	
	<!-- jqGrid主题包-非必要 --> 
<style type="">
input[type=checkbox] {
	height: 17px;
	width:17px;
}
</style>
<script type="text/javascript"> 
		function pageUtil(page) {
			$("#search_form").attr("action", "/ciqs/generalPunishment/list?page="+page);
			$("#search_form").submit();
		}
		function pageUtilNew(page) {
			$("#search_form").attr("action", "/ciqs/generalPunishment/listNew?page="+page);
			$("#search_form").submit();
		}	
		jQuery(document).ready(function(){
			$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>行政处罚 /一般处罚</span><div>");
			$(".user-info").css("color","white");
		});
		
		function checkAllChange() {
		if ($("#checkAll").attr("checked")) {
			$("input[name='check']").each(function(i, e) {
				if ($(e).attr("disabled") == undefined) {
					$(e).attr("checked", true);
				}
			});
		} else {
			$("input[name='check']").each(function(i, e) {
				$(e).removeAttr("checked");
			});
		}
	}
	
	function search(){
		var step = '${step}';
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
/* 					if(this.name.indexOf("date_begin") != -1 || this.name.indexOf("date_end") != -1){
						name = "step_"+step+"_date"
					} */
					if(this.name.indexOf("date_begin") != -1){
						name = "sv.step_"+1+"_date";
						key = this.name;
					}
					if( this.name.indexOf("date_end") != -1){
						name = "sv.step_"+1+"_date";
						key = this.name;
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
	   
	   var opt = document.createElement("input");
	   opt.type = "submit";
	   tempform.appendChild(opt);
	   document.body.appendChild(tempform);
	   tempform.submit();
	   document.body.removeChild(tempform);     
	}
</script>
</head>
<body>
<%@ include file="/common/headMenu_Pn.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">一般处罚</a> &gt; 
			<c:if test="${step == '1' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=1">线索申报</a>
			</c:if>
			<c:if test="${step == '2' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=2">线索预审批</a>
			</c:if>
			<c:if test="${step == '3' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=3">稽查受理</a>
			</c:if>
			<c:if test="${step == '5' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=5">法制受理</a>
			</c:if>
			<c:if test="${step == '7' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=7">立案审批</a>
			</c:if>
			<c:if test="${step == '9' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=9">调查取证/初审</a>
			</c:if>
			<c:if test="${step == '18' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=18">调查取证/复审</a>
			</c:if>
			<c:if test="${step == '19' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=19">调查取证/终审</a>
			</c:if>
			<c:if test="${step == '10' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=10">审理决定/初审</a>
			</c:if>
			<c:if test="${step == '11' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=11">审理决定/复审</a>
			</c:if>
			<c:if test="${step == '12' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=12">审理决定/终审</a>
			</c:if>
			<c:if test="${step == '13' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=13">送达执行</a>
			</c:if>
			<c:if test="${step == '14' }">
				<a href="${cxt}/ciqs/generalPunishment/listNew?step=14">结案归档</a>
			</c:if>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="search">
			<div class="main">
				<form action="/ciqs/generalPunishment/listNew"  method="post" id="search_form">
					<input type="hidden" name="step" value="${step}"/>
					<%@ include  file="./seach.jsp" %>
				</form>
			</div>
		</div>
		<div class="table">
			<div class="data"><span style="float: left;">
				共有&nbsp;<span class="number">${counts }</span>&nbsp;条记录，
				每页显示&nbsp;<span class="number">${itemInPage }</span>&nbsp;条记录</span>
			</div>

			<div class="main">
					 <table id="list2"></table>
					<%@ include  file="./table.jsp" %>
<!-- 				<div
					style="text-align: center; margin: auto; margin-top: 10px; width: 200px; padding-bottom: 10px;">
					<input type="button" class="search-btn" value="提交"
						onclick="javascript:submitForm();" />
				</div> -->
			</div>
		</div>
	</div>
	<script type="text/javascript">
		$(function(){
			pageInit();

		});
	//创建jqGrid组件
		function pageInit(){
			var list = JSON.parse('${listJson}');
			console.log(list);
			/* var ss */
		}
	</script>
</body>
</html>

