<%@page pageEncoding="utf-8" isELIgnored="false"
	contentType="text/html; charset=utf-8"%>
<%@taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>NetCTOSS</title>
		<link type="text/css" rel="stylesheet" media="all"
			href="../styles/global.css" />
		<link type="text/css" rel="stylesheet" media="all"
			href="../styles/global_color.css" />
		<script type="text/javascript" src="../js/jquery-1.4.3.js">
</script>
		<script language="javascript" type="text/javascript">
//排序按钮的点击事件
		$(function(){
				document.getElementById("cost").className="fee_on";
					var type = $("#sort").val();
		            var colName=$("#colName").val();
		            var obj=document.getElementById(colName);
		             if(type=='asc'){
		            	$(obj).removeClass("sort_desc").addClass("sort_asc");
		             }else{
		            	$(obj).removeClass("sort_asc").addClass("sort_desc");
		            }
		});
            function sort1(obj){
            	var type = $("#sort").val();
            	var colName=obj.id;
            	if(type==""||type=='asc'){
            		 type='desc';
            		 }else{
            		 type='asc';
            		 }
            	 toPage(1,type,colName);
            }
            function toPage(currentP,type,colName){
            	$("#currentpage").val(currentP);
            	$("#sort").val(type);
            	$("#colName").val(colName);
            	
            	document.forms[0].submit();
            }
            //启用
            function startFee() {
                var r = window.confirm("确定要启用此资费吗？资费启用后将不能修改和删除。");
                document.getElementById("operate_result_info").style.display = "block";
            }
            //删除
            function deleteFee(id) {
                var r = window.confirm("确定要删除此资费吗？");
                if(r){
                	location.href="deleteCost.action?id="+id;
                	document.getElementById("operate_result_info").style.display = "block";
                }else{
                	return;
                }
                
            }
        </script>
	</head>
	<body>
		<!--Logo区域开始-->
		<div id="header">
			<img src="../images/logo.png" alt="logo" class="left" />
			<span>当前账号：<b><s:property value="#session.admin.name" />
			</b>
			</span>
			<a href="#">[退出]</a>
		</div>
		<!--Logo区域结束-->
		<!--导航区域开始-->
		 <%@include file="../navigator/navigator.jsp" %>
		<!--导航区域结束-->
		<!--主要区域开始-->
		<div id="main">
			<form action="findCost" method="post">
				<s:hidden name="pages" id="currentpage" />
				<s:hidden name="type" id="sort" />
				<s:hidden name="colName" id="colName" />
				<!--排序-->
				<div class="search_add">
					<div>
						<input type="button" id="base_cost" value="月租" class="sort_asc"
							onclick="sort1(this);" />
						<input type="button" id="unit_cost" value="基费" class="sort_asc" onclick="sort1(this);"  />
						<input type="button" id="base_duration" value="时长" class="sort_asc" onclick="sort1(this);" />
					</div>
					<input type="button" value="增加" class="btn_add"
						onclick="location.href='toAdd.action';" />
				</div>
				<!--启用操作的操作提示-->
				<div id="operate_result_info" class="operate_success">
					<img src="../images/close.png"
						onclick="this.parentNode.style.display='none';" />
					删除成功！
				</div>
				<!--数据区域：用表格展示数据-->
				<div id="data">
					<table id="datalist">
						<tr>
							<th>
								资费ID
							</th>
							<th class="width100">
								资费名称
							</th>
							<th>
								基本时长
							</th>
							<th>
								基本费用
							</th>
							<th>
								单位费用
							</th>
							<th>
								创建时间
							</th>
							<th>
								开通时间
							</th>
							<th class="width50">
								状态
							</th>
							<th class="width200"></th>
						</tr>

						<s:iterator value="costs">
					
							<tr>
								<td>
									<s:property value="id" />
								</td>
								<td>
									<a href="javascript:;"
										onclick="location.href='loadCost.action?id=${id}'"><s:property
											value="name" />
									</a>
								</td>
								<td>
									<s:property value="baseDuration" />
								</td>
								<td>
									<s:property value="baseCost" />
								</td>
								<td>
									<s:property value="unitCost" />
								</td>
								<td>
									<s:property value="createTime" />
								</td>
								<td>
									<s:property value="startTime" />
								</td>
								<td>
									<s:if test="status==0">开通</s:if>
									<s:elseif test="status==1">暂停</s:elseif>
									<s:else>删除</s:else>
								</td>
								<td>
									<s:if test="status!=0&&status!=2">
										<input type="button" value="启用" class="btn_start" />
										<input type="button" value="修改" class="btn_modify"
											onclick="location.href='load_cost?id=${id}'" />
										<input type="button" value="删除" class="btn_delete"
											onclick="deleteFee(<s:property value='id'/>)" />
									</s:if>
								</td>
							</tr>
						</s:iterator>
					</table>
					<p>
						业务说明：
						<br />
						1、创建资费时，状态为暂停，记载创建时间；
						<br />
						2、暂停状态下，可修改，可删除；
						<br />
						3、开通后，记载开通时间，且开通后不能修改、不能再停用、也不能删除；
						<br />
						4、业务账号修改资费时，在下月底统一触发，修改其关联的资费ID（此触发动作由程序处理）
					</p>
				</div>
				<!--分页-->
				<div id="pages">
					<s:if test="pages>1">
						<a
							href="javascript:toPage(<s:property value='pages-1'/>,'${type}','${colName}');">上一页</a>
					</s:if>
					<s:else>
						上一页
					</s:else>
					<s:iterator begin="1" end="totalPage" var="p">
						<s:if test="pages==#p">
							<a
								href="javascript:toPage(<s:property />,'${type}','${colName}');"
								class="current_page"> <s:property value="#p" /> </a>
						</s:if>
						<s:else>
							<a
								href="javascript:toPage(<s:property />,'${type}','${colName}');">
								<s:property value="#p" /> </a>
						</s:else>
					</s:iterator>
					<s:if test="pages<totalPage">
						<a
							href="javascript:toPage(<s:property value='pages+1'/>,'${type}','${colName}');">下一页</a>
					</s:if>
					<s:else>
						下一页
					</s:else>
				</div>
			</form>
		</div>
		<!--主要区域结束-->
		<div id="footer">
		</div>
	</body>
</html>
