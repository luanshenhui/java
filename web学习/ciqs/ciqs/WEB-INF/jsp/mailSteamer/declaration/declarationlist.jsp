<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>邮轮入境检疫申报查询</title>
<%@ include file="/common/resource_new.jsp"%>
<script type="text/javascript"> 
		function pageUtil(page) {
			$("#user_form").attr("action", "/ciqs/mailSteamer/showdeclarationlist");
			$("#user_form").append("<input type='hidden' name='page' value='"+page+"'/>");
			$("#user_form").submit();
		}
		function download(file){
			window.location.href="/ciqs/mailSteamer/download?fileName="+file;
		}
		
		jQuery(document).ready(function(){
			$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>行政许可 /入境检疫申报</span><div>");
			$(".user-info").css("color","white");
		});
</script>
<style>
.span{
	height: 25px;
    padding-right: 5px;
    padding-left: 5px;
    margin-right: 5px;
    margin-left: 5px;
    align-items: flex-start;
    text-align: center;
    cursor: default;
    color: buttontext;
    background-color: buttonface;
    box-sizing: border-box;
    padding: 2px 6px 3px;
    border-width: 2px;
    border-style: outset;
    border-color: buttonface;
    border-image: initial
}
</style>
</head>
<body>
<%@ include file="/common/headMenu2.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：</a>出入境邮轮检疫 &gt; 入境检疫申报
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="title">邮轮入境检疫申报查询</div>
		<div class="search">
			<div class="main">
				<form action="/ciqs/mailSteamer/showdeclarationlist"  method="post" id="user_form">
					<table class="table_search" id="aa">
						<tr>
							<td >中文船名:</td>
							<td >英文船名	:</td>
							<td >开始时间:</td>
							<td >结束时间:</td>
						</tr>
					
						<tr>
							<td align="left"><input type="text" name="cnVslm" id="cnVslm"
								size="14" value="${map.cnVslm}"/></td>
							<td align="left"><input type="text" name="fullVslm" id="fullVslm"
								size="14" value="${map.fullVslm}"/></td>
						  	<td align="left"><input type="text" class="search-input input-175px datepick" name="startdate" id="startdate"
														size="14" value="${map.startdate}"/></td>
						  	<td align="left"><input type="text" class="search-input input-175px datepick" name="enddate" id="enddate"
														size="14" value="${map.enddate}"/></td>
						</tr>
						
						<tr>
						<td colspan="4"><input name="searchF" onclick="pageUtil('1')" type="button" style="margin-left: 735px;"
								class="abutton" value="查 询" /></td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		<div class="table">
			<div class="data"><span style="float: left;">
				共有&nbsp;<span class="number">${counts }</span>&nbsp;条记录，
				分为&nbsp;<span class="number">${allPage }</span>&nbsp;页，
				每页显示&nbsp;<span class="number">${itemInPage }</span>&nbsp;条记录</span>
			</div>
			<div class="main">
					<table>
						<thead>
							<tr>
								<!-- <td>
									序号
								</td> -->
								<td>
									中文船名
								</td>
								<td>
									英文船名
								</td>
								<td>
									呼号
								</td>
								<td>
									申报单位
								</td>
								<td>
									申报时间
								</td>
								<td>
									邮轮入境检疫申报
								</td>
								<td>
									附件
								</td>
								<td>
									审批状态
								</td>
								<td>
									风险等级
								</td>
								<td>
									确定检疫方式
								</td>
								<td>
									异常事项
								</td>
<!-- 								<td> -->
<!-- 									归档 -->
<!-- 								</td> -->
							</tr>
						</thead>
						<c:if test="${not empty list }">
							<c:forEach items="${list}" var="row">
								<tr>
								<%-- 	<td>${row.rowNum}</td> --%>
									<td>${row.cn_vsl_m}</td>
									<td>${row.full_vsl_m }</td>
									<td>${row.vsl_callsign }</td>
									<td>${row.dec_org }</td>
									<td><fmt:formatDate value="${row.dec_date }" type="both"/></td>
									<td>${row.mail_dec}</td>
									<td>${row.file_name}</td>
									<td>${row.ciq_resault}</td>
									<td>
									<c:forEach items="${levels }" var="level">
										<c:if test="${level.code == row.cent_war_level }">
											${level.name }
										</c:if>
									</c:forEach>
									</td>
									<td>
									<c:forEach items="${inspTypes }" var="inspType">
										<c:if test="${inspType.code == row.insp_type }">
											${inspType.name }
										</c:if>
									</c:forEach>
									</td>
									<td>${row.expt_iterm}</td>
<%-- 									<td><a href="/ciqs/mailSteamer/toDocPage?page=ms_guidangxiangxiliebiao&proc_main_id=${row.dec_master_id }">归档</a></td> --%>
								</tr>
							</c:forEach>
						</c:if>
						<tfoot>
                        	<jsp:include page="/common/pageUtil.jsp" flush="true"/>
                    	</tfoot>
					</table>
			</div>
		</div>
	</div>
</body>
</html>
