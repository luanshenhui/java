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
</style>
<script type="text/javascript">
    	function pageUtil(page) {
			window.location.href="${ctx}/web/list?page="+page;
        }
        
        function add(){
        	layerIndex = layer.open({
			title:'添加',
			type: 2, 
			area: ['600px', '300px'],
			  content: '${ctx}/web/add.html' //这里content是一个普通的String
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
                <span class="font-24px" style="color:white;">DALIAN RESUME</span>
                <a id="title_a" href="javaScript:void()"></a>
            </div>
        </div>
    </div>
	</div>

	<div class="margin-auto width-1200 search-box">
		<div id="alertBoxId" class="box-img-bg">
			<span class="box-content-style" id="alertContentId"></span>
		</div>
		<form action="${ctx}/web/list" method="post">
			<table>
				<tr style="height: 50px;display:block;margin-top:10px">
					<td>姓名</td>
					<td width="60" height="20"><input name="name" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="name" value="${domain.name}" /></td>
					<td>电话</td>
					<td width="60" height="20"><input name="tel" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="tel" value="${domain.tel}" /></td>
					<td>毕业学校</td>
					<td width="60" height="20"><input name="sch" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="sch" value="${domain.sch}" /></td>
					<td>户口</td>
					<td width="60" height="20"><input name="city" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="city" value="${domain.city}" /></td>
					<td width="60" height="20"><input type="submit" value="search" /></td>
					<td width="60" height="20"><input type="reset" value="clear"/></td>
				</tr>
				<tr style="height: 50px; display:block;margin-top:10px">
					<td>学历</td>
					<td width="60" height="20"><input name="xl" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="xl" value="${domain.xl}" /></td>
					<td>生日</td>
					<td width="60" height="20"><input name="borth" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="borth"
						value="${domain.borth}" /></td>
					<td>邮箱</td>
					<td width="60" height="20"><input name="emil" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="emil" value="${domain.emil}" /></td>
					<td>住址</td>
					<td width="60" height="20"><input name="address" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="address"
						value="${domain.address}" /></td>
					<td width="60" height="20"><input type="button" id="add" value="add"/></td>
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
					<td>手机</td>
					<td>学校</td>
					<td>生日</td>
					<td>地址</td>
					<td>图片</td>
					<td>操作</td>
				</tr>
				<c:if test="${not empty list }">
					<c:forEach items="${list}" var="row" varStatus="status">
						<tr class="thead_nr">
							<td>${status.index + 1}</td>
							<td width="20%" height="90" align="center">${row.tel}</td>
							<td width="20%" height="90" align="center">${row.sch}</td>
							<td width="20%" height="90" align="center">${row.borth}</td>
							<td width="20%" height="90" align="center">${row.address}</td>
							<td width="20%" height="90" align="center"><img src="${row.image}" /></td>
							<td width="20%" align="center" valign="middle">
								<a href='javascript:jumpPage("${ctx}/web/info?tel=${row.tel}");'>
									<span class="data-btn margin-auto">详细+</span>
								</a> 
								<a href='javascript:jumpPage("${ctx}/web/updateList?tel=${row.tel}");'>
									<span class="data-btn margin-auto">删除+</span>
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
