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
			window.location.href="${ctx}/web/myAddList?page="+page;
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
	        	add();
			});
		});
        
   		function update(id){
        	layerIndex = layer.open({
			title:'修改',
			type: 2, 
			area: ['600px', '500px'],
			  content: '${ctx}/web/updateTab.html?id='+id //这里content是一个普通的String
			});
        }
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
					<td style="width: 60px">联系人</td>
					<td width="60" height="20"><input name="name" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="name" value="${obj.name}" /></td>
					<td style="width: 60px">职业</td>
					<td width="60" height="20"><input name="age" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="age" value="${obj.age}" /></td>
					<td style="width: 60px">生日</td>
					<td width="60" height="20"><input name="borth" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="borth" value="${obj.borth}" /></td>
					<td style="width: 60px">学历</td>
					<td width="60" height="20"><input name="xl" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="xl" value="${obj.xl}" /></td>
				</tr>
				<tr style="height: 50px;display:block;margin-top:10px">	
					<td style="width: 60px">住址</td>
					<td width="60" height="20"><input name="city" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="city" value="${obj.city}" /></td>
					<td style="width: 60px">中间电话</td>
					<td width="60" height="20"><input name="midetel" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="midetel" value="${obj.midetel}" /></td>
					<td style="width: 60px">最终电话</td>
					<td width="60" height="20"><input name="tel" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="tel" value="${obj.phone}" /></td>
					<td style="width: 60px">个人信息</td>
					<td width="60" height="20"><input name="hukou" type="text" style="margin-right: 50px;"
						class="search-input input-140px" id="hukou" value="${obj.hukou}" /></td>
				</tr>
				<tr style="height: 50px;display:block;margin-top:10px">		
					<td style="width: 60px">状态</td>
					<td width="60" height="20">
						<select id="zt"  name="zt">
						<option value="" <c:if test="${obj.zt eq '' }"> selected="selected"</c:if>>全部</option>
						<option value="1" <c:if test="${obj.zt eq '1' }"> selected="selected"</c:if>>通过</option>
						<option value="2" <c:if test="${obj.zt eq '2' }"> selected="selected"</c:if>>报警</option>
						</select>
					</td>	
					<td width="60" height="20"><input type="submit" class="abutton" value="search" /></td>
					<td width="190" height="20"><input type="button" class="mbutton" value="add" id="add"/></td>
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
					<td>频率</td>
					<td>联系人</td>
					<td>中间手机</td>
					<td>最终人</td>
					<td>学历</td>
					<td>职业</td>
					<td>最终手机</td>
					<td>生日</td>
					<td>地址</td>
					<td>需求</td>
					<td>操作</td>
				</tr>
				<c:if test="${not empty list }">
					<c:forEach items="${list}" var="row" varStatus="status">
						<tr class="thead_nr" 
							<c:if test="${row.zt eq '1' }"> style="background-color:#0080005c"</c:if>
							<c:if test="${row.zt eq '2' }"> style="background-color:#ff006d1a"</c:if>
							<c:if test="${row.zt eq '3' }"> style="background-color:green"</c:if>
							<c:if test="${row.zt ne '1' and row.zt ne '2' and row.color le '5'}">
								style="background-color:#efecb5fc"
							</c:if>
							>
							<td width="2%">${status.index + 1}</td>
							<td width="2%">${row.beginPage}</td>
							<td width="6%"  align="center">${row.personName}</td>
							<td width="8%"  align="center">${row.midetel}</td>
							<td width="6%"  align="center">${row.name}</td>
							<td width="5%"  align="center">${row.xl}</td>
							<td width="4%"  align="center">${row.hukou}</td>
							<td width="8%"  align="center">${row.phone}</td>
							<td width="4%"  align="center">${row.borth}</td>
							<td width="6%"  align="center">${row.city}</td>
							<td width="17%" align="center">${row.content}</td>
							<td width="36%" align="center" valign="middle">
								<a href='javascript:jumpPage("${ctx}/web/updateUser?id=${row.id}&zt=2");'>
									<span class="data-btn margin-auto" style="display:inline-block">警报+</span>
								</a>
								<a href='javascript:jumpPage("${ctx}/web/updateUser?id=${row.id}&zt=1");'>
									<span class="data-btn margin-auto" style="display:inline-block">邀请+</span>
								</a>
								<a href='javascript:jumpPage("${ctx}/web/updateUser?id=${row.id}&zt=3");'>
									<span class="data-btn margin-auto" style="display:inline-block">关注+</span>
								</a>
								<a href='javascript:void();' onclick="update(${row.id})">
									<span class="data-btn margin-auto" style="display:inline-block">修改+</span>
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
