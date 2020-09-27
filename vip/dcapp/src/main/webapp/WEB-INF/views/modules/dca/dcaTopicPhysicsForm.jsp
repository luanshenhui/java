<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<html>
<head>
	<title>物理表新建/编辑</title>
	<meta name="decorator" content="default"/>
	<script src="/static/jquery-validation/1.11.0/jquery.validate.js"></script>
	<script src="/static/ejs/ejs.min.js"></script>
	<script src="/assets/dca/js/jquery.topic.physics.js"></script>
	<link rel="stylesheet" type="text/css" href="/assets/dca/css/topicPhysicsForm.css"> 
	<script type="text/javascript">
		$(function() {
			
		});
	</script>
</head>
<body>	
<div id="topicPhysicsBody">
	<h6 class="span12">物理表结构${not empty dcaTopicPhysics.oldTableName?'修改':'添加'}</h6>
	<input id="oldIdxName" name="oldIdxName" type="hidden" value="${dcaTopicPhysics.oldTableName}">
	<div class="clearfix"></div>
		<form:form id="topicPhysicsTableForm" modelAttribute="dcaTopicPhysics" action="" method="post" class="breadcrumb form-horizontal form-search">
			<sys:message content="${message}"/>		
			<div class="control-group">
				<label class="control-label"><font color="red">*</font>数据库类型：</label>
				<div class="controls">
					<form:select path="dbType" class="input-medium">
						<form:option value="" label="ORACLE"/>
						<form:options items="${fns:getDictList('db_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label"><font color="red">*</font>物理表名(英文)：</label>
				<div class="controls">
					<form:input  path="tableName" placeholder="输入25位以'DCA_PHY_'开头的名称" htmlEscape="true" maxlength="25" class="tableName input-xlarge" value="${dcaTopicPhysics.tableName}"  readonly="${not empty dcaTopicPhysics.oldTableName?'true':'false'}" disabled="${not empty dcaTopicPhysics.oldTableName?'true':'false'}"/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">物理表名(中文)：</label>
				<div class="controls">
					<form:input path="tableComment" placeholder="输入25位的中文名称" htmlEscape="true" maxlength="25" class="input-xxlarge" value="${dcaTopicPhysics.tableComment}"/>
				</div>
			</div>
		
			<table id="columnTable" class="table table-striped table-bordered table-condensed">
				<thead>
					<tr>
						<th width="20%">字段名(英文)</th>
						<th width="20%">字段名(中文)</th>
						<th width="20%">数据类型</th>
						<th width="8%">是否主键</th>
						<th width="8%">是否唯一</th>
						<th width="8%">是否可空</th>
						<th width="8%">默认值</th>
						<th width="8%">操作</th>
					</tr>
				</thead>
				<tbody id="tbody">
				<c:choose>
				    <c:when test="${dcaTopicPhysics.columnList!=null && fn:length(dcaTopicPhysics.columnList) > 0}">  
				        <c:forEach items="${dcaTopicPhysics.columnList}" var="DcaTopicPhysicsFields" varStatus="status">
							<tr data-item='row'>
								<td>
									<a href="${ctx}/dca/dcaTopicPhysics/columnEdit?columnName=${DcaTopicPhysicsFields.columnName}">${DcaTopicPhysicsFields.columnName}</a>
								</td>
								<td>${DcaTopicPhysicsFields.columnComment}</td>
								
								   <c:if test="${DcaTopicPhysicsFields.columnType== '1'}">  
	     								<td>NUMBER ( ${DcaTopicPhysicsFields.dataLength}, ${not empty DcaTopicPhysicsFields.decimalDigits?DcaTopicPhysicsFields.decimalDigits:'0'})</td>
								   </c:if>
								   <c:if test="${DcaTopicPhysicsFields.columnType== '2'}">  
	     								<td>NCHAR ( ${DcaTopicPhysicsFields.dataLength} )</td>
								   </c:if>
								    <c:if test="${DcaTopicPhysicsFields.columnType== '3'}">  
	     								<td>NVARCHAR2 ( ${DcaTopicPhysicsFields.dataLength} )</td>
								   </c:if>
								   <c:if test="${DcaTopicPhysicsFields.columnType== '4'}">  
	     								<td>DATE</td>
								   </c:if>
								   <c:if test="${DcaTopicPhysicsFields.columnType== '5'}"> 
										<td>NCLOB</td>
								   </c:if>
								
								<td>${DcaTopicPhysicsFields.columnKey=="1"?"是":"否"}</td>
								<td>${DcaTopicPhysicsFields.isOnly=="1"?"是":"否"}</td>
								<td>${DcaTopicPhysicsFields.isNull=="1"?"是":"否"}</td>
								<td>${DcaTopicPhysicsFields.colDefault=="" ?"NULL":DcaTopicPhysicsFields.colDefault}</td>
								<shiro:hasPermission name="dca:dcaTopicPhysics:edit"><td>
									<a href="${ctx}/dca/dcaTopicPhysics/columnDelete?columnName=${DcaTopicPhysicsFields.columnName}" onclick="return confirmx('确认要删除该条数据吗？', this.href)">删除</a>
								</td></shiro:hasPermission>
							</tr>
						</c:forEach>    
				    </c:when>
				    <c:otherwise> 
				    	<tr>
							<td>&#12288;</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
				    </c:otherwise>
				</c:choose>
				</tbody>
			</table>
			<h6>字段定义</h6>
			<div class="control-group">
				<div class="pull-left">
					<label class="control-label"><font color="red">*</font>字段名(英文)：</label>
					<div class="controls">
						<form:input path="currentFiled.columnName" placeholder="输入20位的英文名称" name="columnName" htmlEscape="true" maxlength="20" class="columItem columnName input-xlarge"/>
					</div>
				</div>
				<input class="btn-s btn-opear btnColumnSave pull-right" name="btnColumnSave" type="button" value="字段保存"/>
			</div>
			<div class="control-group">
				<label class="control-label"><font color="red">*</font>字段名(中文)：</label>
				<div class="controls">
					<form:input path="currentFiled.columnComment" placeholder="输入10位的中文名称" name="columnComment" htmlEscape="true" maxlength="10" class="columItem columnComment input-xlarge"/>
				</div>
			</div>
		
			<div class="control-group">
				<label class="control-label"><font color="red">*</font>数据类型：</label>
				<div class="controls">
					<form:select path="currentFiled.columnType" class="input-medium columnType" name="columnType">
						<form:option value="" label="请选择"/>
						<form:options items="${fns:getDictList('oracle_data_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</div>
			</div>
			<div id="dataLengthDiv" class="control-group">
				<label class="control-label"><font color="red">*</font>位数：</label>
				<div class="controls">
					<form:input path="currentFiled.dataLength" htmlEscape="true" placeholder="输入位数(数字)" maxlength="4" name="dataLength" class="columItem dataLength"/>
				</div>
			</div>
			<div id="decimalDigitsDiv" class="control-group hide">
				<label class="control-label">小数位数：</label>
				<div class="controls">
					<form:input path="currentFiled.decimalDigits" htmlEscape="true" placeholder="输入位数(数字)" class="dcolumItem decimalDigits"/>
				</div>
			</div>
			<ul class="ul-form">
				<li><label class="label-width ml-40"><font color="red">*</font>是否为主键：</label>
					<form:radiobuttons path="currentFiled.columnKey" items="${fns:getDictList('yes_no')}"  itemLabel="label" itemValue="value" htmlEscape="false" class="columnKey"/>
				</li>
				<li><label class="label-width"><font color="red">*</font>是否唯一约束：</label>
					<form:radiobuttons path="currentFiled.isOnly" items="${fns:getDictList('yes_no')}"  itemLabel="label" itemValue="value" htmlEscape="false" class="isOnly"/>
				</li>
				<li><label><font color="red">*</font>是否可空：</label>
					<form:radiobuttons path="currentFiled.isNull" items="${fns:getDictList('yes_no')}"  itemLabel="label" itemValue="value" htmlEscape="false" class="isNull"/>
				</li>
				<li class="clearfix"></li>
				<li id="colDefaultDiv" class="mt-20">
					<label class="label-width ml-40">默认值：</label>
					<form:input path="currentFiled.colDefault" htmlEscape="true" rows="1" maxlength="10" class="columItem colDefault input-xlarge " placeholder="默认值类型和数据类型须一致"/>
				</li>
			</ul>
		</form:form>
	<div class="form-actions">
		<shiro:hasPermission name="dca:dcaTopicPhysics:edit"><input id="tphSubmit" class="btn-s btn-opear saveAll" type="button" value="保 存"/>&nbsp;</shiro:hasPermission>
		<input id="tphCancel" class="btn-s btn-opear" type="button" value="返 回"/>
	</div>
</div>
</body>
</html>