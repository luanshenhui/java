<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/common/resource_show.jsp"%>
 <script type="text/javascript" src="${ctx}/static/layer/layer.js"></script>
<style type="text/css">
.title{
	 text-align: center;
     width: 100%;
}
.margin-cxjg .margin-cxjg_table tr td {
    text-align: center;
    padding: 10px 2px 10px 2px;
    border-bottom: 1px solid #CCC;
    border-right: 1px solid #CCC;
}
</style>
<script type="text/javascript">
    	function pageUtil(page) {
			window.location.href="${ctx}/web/list?page="+page;
        }
        
        function add(){
        	layerIndex = layer.open({
			title:'添加',
			type: 2, 
			area: ['600px', '500px'],
			  content: '${ctx}/web/addTab.html' //这里content是一个普通的String
			});
        }
        
		$(function () {
	        $("#add").click(function(){
	        debugger;
	  			add();
			});
		});
</script>
</head>
<body class="bg-gary">
	<div class="blank_div_list" style="margin-left: auto;margin-right: auto;width: 1200px">
	 <div class="title-bg">
        <div class=" title-position margin-auto white">
            <div class="title">
                <span class="font-24px" style="color:white;">DALIAN PERSON</span>
                <a id="title_a" href="javaScript:void()"></a>
            </div>
        </div>
    </div>
	</div>

	<div class="margin-auto width-1200 search-box">
		<div id="alertBoxId" class="box-img-bg">
			<span class="box-content-style" id="alertContentId"></span>
		</div>
		<form action="${ctx}/web/myAddList" method="post">
			<table>
				<tr style="height: 50px;display:block;margin-top:10px">
					<td>联系人</td>
					<td width="60" height="20"><input name="name" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="name" value="${obj.name}" /></td>
					<td>年龄</td>
					<td width="60" height="20"><input name="age" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="age" value="${obj.age}" /></td>
					<td>生日</td>
					<td width="60" height="20"><input name="borth" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="borth" value="${obj.borth}" /></td>
					<td>学历</td>
					<td width="60" height="20"><input name="xl" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="xl" value="${obj.xl}" /></td>
				</tr>
				<tr style="height: 50px;display:block;margin-top:10px">	
					<td>住址</td>
					<td width="60" height="20"><input name="city" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="city" value="${obj.city}" /></td>
					<td>中间电话</td>
					<td width="60" height="20"><input name="midetel" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="midetel" value="${obj.midetel}" /></td>
					<td>最终电话</td>
					<td width="60" height="20"><input name="tel" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="tel" value="${obj.tel}" /></td>
					<td>户口</td>
					<td width="60" height="20"><input name="hukou" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="hukou" value="${obj.hukou}" /></td>
				</tr>
				<tr style="height: 50px;display:block;margin-top:10px">			
					<td width="60" height="20"><input type="submit" class="abutton" value="search" /></td>
					<td width="60" height="20"><input type="button" class="mbutton" value="add" id="add"/></td>
					<td width="60" height="20"><input type="reset"  class="mbutton" value="clear"/></td>
				</tr>
			</table>
		</form>
	</div>

	<div class="margin-auto width-1200 tips">共找到<span class="yellow font-18px">
	<c:if test="${not empty list }">
        ${counts}
    </c:if>
	<c:if test="${empty list }">
        0
    </c:if>
	</span>条记录
	</div>
	
	<div class="margin-auto width-1200  data-box">
		<div class="margin-cxjg">
			<table class="margin-cxjg_table" border="0" cellspacing="0" cellpadding="0">
				<tr class="thead">
					<td>序号</td>
					<td>联系人姓名</td>
					<td>中间手机</td>
					<td>最终手机</td>
					<td>生日</td>
					<td>地址</td>
					<td>操作</td>
				</tr>
				<c:if test="${not empty list }">
					<c:forEach items="${list}" var="row" varStatus="status">
						<tr class="thead_nr" 
							<c:if test="${row.zt eq '1' }"> style="background-color:green"</c:if>
							<c:if test="${row.zt eq '2' }"> style="background-color:red"</c:if>>
							<td width="5%">${status.index + 1}</td>
							<td width="10%"  align="center" >${row.personName}</td>
							<td width="13%"  align="center">${row.midetel}</td>
							<td width="13%"  align="center">${row.tel}</td>
							<td width="11%"  align="center">${row.borth}</td>
							<td width="13%"  align="center">${row.city}</td>
							<td width="35%" align="center" valign="middle">
								<a href='javascript:jumpPage("${ctx}/web/info?id=${row.id}");'>
									<span class="data-btn margin-auto" style="display:inline-block">详细+</span>
								</a>
								<a href='javascript:jumpPage("${ctx}/web/updateList?id=${row.id}");'>
									<span class="data-btn margin-auto" style="display:inline-block">删除+</span>
								</a>
								<a href='javascript:jumpPage("${ctx}/web/updateUser?id=${row.id}&zt=2");'>
									<span class="data-btn margin-auto" style="display:inline-block">警报+</span>
								</a>
								<a href='javascript:jumpPage("${ctx}/web/updateUser?id=${row.id}&zt=1");'>
									<span class="data-btn margin-auto" style="display:inline-block">通过+</span>
								</a>
							</td>
						</tr>
					</c:forEach>
				</c:if>
				<tfoot>
					<jsp:include page="/common/pageUtil.jsp" flush="true" />
				</tfoot>
			</table>
		</div>
	</div>
</body>
</html>
