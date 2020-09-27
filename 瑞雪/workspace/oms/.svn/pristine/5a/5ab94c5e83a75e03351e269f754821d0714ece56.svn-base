<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%-- <jsp:include page="../../../../import.jsp" flush="true" /> --%>
<title>集成管控平台</title>
<link rel="shortcut icon" href="img/naxin.ico" />
<link rel="stylesheet" type="text/css" href="/easyUi/jquery-easyui-1.4.5/themes/default/easyui.css" />
<link rel="stylesheet" type="text/css" href="/easyUi/jquery-easyui-1.4.5/themes/icon.css" />
<link rel="stylesheet" type="text/css" href="/easyUi/jquery-easyui-1.4.5/demo/demo.css" />
<script type="text/javascript" src="/easyUi/jquery-easyui-1.4.5/jquery.min.js"></script>
<script type="text/javascript" src="/easyUi/jquery-easyui-1.4.5/jquery.easyui.min.js"></script>
<script type="text/javascript" src="/easyUi/jquery-easyui-1.4.5/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="/Apollo/cookie.mini.js"></script>
<script type="text/javascript" src="/Apollo/Apollo.js"></script>
<script type="text/javascript">
//功能按钮权限控制
/* var priIdArray = [96,97,98];
$(function(){
	PriManager.queryPriInfoByUserAuth('',priIdArray);
}); */
</script>
<%
//获取session用户信息，如果为空，top窗口地址为登录页面
//if(request.getSession().getAttribute("_userInfo") == null){
		%>
<script>
		/* $(function(){
			if (window.top!=window.self) {
				window.top.location="/login.html";
			}
		}); */
		</script>
<%
	//}
%>
</head>
<body>
	<!-- 查询区 -->
	<div style="padding: 0px; border-bottom: 1px solid #ccc">信息查询</div>
	<div id="selectWhereby" style="padding: 3px">
		<span>登 录 名:</span> <input id="byUserId" style="line-height: 20px; border: 1px solid #ccc; margin-right: 20px" /> <span>姓
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;名:</span> <input id="byUserName"
			style="line-height: 20px; border: 1px solid #ccc; margin-right: 20px" /> <span>所属部门:</span> <input id="byDeptName"
			style="line-height: 20px; border: 1px solid #ccc; margin-right: 20px" />
	</div>
	<div>
		<span>账户状态:</span> <select id="userStatus" style="width: 144px; border: 1px solid #CCCCCC;">
			<option value="" selected="selected">请选择</option>
			<option value="1">启用</option>
			<option value="0">禁用</option>
		</select> <span style="margin-left: 20px">用户角色:</span> <select id="userAllRole"
			style="width: 145px; border: 1px solid #CCCCCC;">
		</select> <a href="#" class="easyui-linkbutton" style="width: 65px; margin-left: 60px" pri_id='96' onclick="doSearch()">查询</a>
	</div>
	<!-- 列表区 -->
	<table id="userList" style="padding: 0px; margin: 0px; width: 100%">
	</table>
	<div id="tb">
		<a id="addUserButton" href="javascript:void(0)" class="easyui-linkbutton" pri_id='97'
			data-options="iconCls:'icon-add',plain:true,text : '新增用户',"></a>
	</div>
	<!-- 弹出对话框区 -->
	<div id="addUser" style="display: none">
		<table class="datagrid-htable"
			style="border-collapse: collapse; width: 655px; padding: 10px; margin-top: 15px; margin-left: 5px; margin-right: 5px; margin-bottom: 5px;"
			border="1">
			<tr style="background-color: #F0F0F0">
				<td style="width: 140px; text-align: center">用户类型</td>
				<td style="width: 140px; text-align: center"><select id="userType" style="width: 143px;" disabled="disabled">
						<option value="1" selected="selected">内部用户</option>
						<option value="2">外部用户</option>
				</select></td>
				<td style="width: 140px; text-align: center"><a id="oaUser" href="#" class="easyui-linkbutton"
					style="width: 65px;" onclick="selectOAUser()">读取OA</a></td>
				<td style="width: 140px; text-align: center"></td>
			</tr>
			<tr>
				<td style="width: 140px; text-align: center">登 录 名</td>
				<td style="width: 140px; text-align: center"><input id='userId'
					style="line-height: 20px; border: 1px solid #ccc;" disabled="disabled" /></td>
				<td style="width: 140px; text-align: center">姓 名</td>
				<td style="width: 140px; text-align: center"><input id='userName'
					style="line-height: 20px; border: 1px solid #ccc;" disabled="disabled" /></td>
			</tr>
			<tr>
				<td style="width: 140px; text-align: center">所属部门</td>
				<td style="width: 140px; text-align: center"><input id='deptName'
					style="line-height: 20px; border: 1px solid #ccc;" disabled="disabled" /> <input id="deptId" type="hidden"></td>
				<td style="width: 140px; text-align: center">职 位</td>
				<td style="width: 140px; text-align: center"><input id='position'
					style="line-height: 20px; border: 1px solid #ccc;" disabled="disabled" /></td>
			</tr>
			<tr>
				<td style="width: 140px; text-align: center">手 机 号</td>
				<td style="width: 140px; text-align: center"><input id='mobile'
					style="line-height: 20px; border: 1px solid #ccc;" disabled="disabled" /></td>
				<td style="width: 140px; text-align: center">邮 箱</td>
				<td style="width: 140px; text-align: center"><input id='emal'
					style="line-height: 20px; border: 1px solid #ccc;" disabled="disabled" /></td>
			</tr>
			<tr>
				<td style="width: 140px; text-align: center">角 色</td>
				<td style="width: 140px; text-align: center"><select id="userAddRole" style="width: 143px;"></select></td>
				<td style="width: 140px; text-align: center">账户状态</td>
				<td style="width: 140px; text-align: center"><input name="userEnable" type="checkbox" value="1">启用 <input
					name="userDisable" type="checkbox" value="0" style="margin-left: 10px">禁用</td>
			</tr>
		</table>
		<!-- 项目授权区 -->
		<!-- <div style="padding:0px;">
	<span style="disply:block;border:1px solid #ccc;width:55px;height: 20px;">项目权限</span>
	<a href="#" class="easyui-linkbutton" style="width:75px;margin-left:20px" onclick="selectProject()">选取项目</a>
	</div> -->
		<div id="selectedProject" style="padding: 10px;"></div>
	</div>

	<!-- 选取项目区 -->
	<div id="selectProject" style="display: none">
		<div id="projectStructure" style="float: left">
			<table id="selectProjectManager" style="border-collapse: collapse; width: 380px;">
				<thead>
					<tr>
						<th field="ID" width="380" hidden="true" align="left">项目ID</th>
						<th field="PROJECT_CODE" width="380" hidden="true" align="left">项目CODE</th>
						<th field="PROJECT_NAME" width="380" align="left">项目</th>
					</tr>
				</thead>
			</table>
		</div>
		<div id="projectStructure2" style="float: left">
			<table id="existsProjectManager" style="border-collapse: collapse; width: 263px; margin-left: 9px; float: left">
				<thead>
					<tr>
						<th field="ID" width="20" hidden="true" align="left">项目ID</th>
						<th field="PROJECT_CODE" width="380" hidden="true" align="left">项目CODE</th>
						<th field="PROJECT_NAME" width="263" align="left">已选项目</th>
					</tr>
				</thead>
			</table>
		</div>
	</div>

	<!-- OA弹出选择区 -->
	<div id="selectOAUser" style="display: none">
		<span style="margin-left: 1px">用户编号:</span> <input id="oaUserId"
			style="line-height: 20px; border: 1px solid #ccc; margin-top: 4px; margin-left: 10px" /> <span
			style="margin-left: 60px">用户名称:</span> <input id="oaUserName"
			style="line-height: 20px; border: 1px solid #ccc; margin-top: 4px; margin-left: 10px" /> <a href="#"
			class="easyui-linkbutton" data-options="iconCls:'icon-search'" style="width: 65px; margin-left: 50px"
			onclick="userMatchQuery()">查询</a>
		<table id="selectUser"
			style="border-collapse: collapse; padding: 10px; margin-top: 10px; margin-left: 0px; margin-right: 0px; margin-bottom: 0px;"
			border="1">
			<thead>
				<tr>
					<th field="userId" width="316" align="center">用户编号</th>
					<th field="userName" width="316" align="center">用户名称</th>
				</tr>
			</thead>
		</table>
	</div>
	<script type="text/javascript">
var userStatus = [{ TEXT:"启用",  VALUE:"1"},{ TEXT:"禁用",  VALUE:"0"}];
var isDel;
$('#userList').datagrid({
    	title:'功能菜单',
    	iconCls:'icon-edit',
    	//width:952,
    	//fit:true, 
        height:'auto', 
        nowrap: false,
        striped: true,
        border: true, 
        collapsible:false,
        fitColumns:true,
        method:'post',
        url:'/sysUser/ajaxQryUserList.action',
        sortOrder: 'desc',
        remoteSort:true,
        idField:'fldId',
        singleSelect:true,
        pagination:true,
        rownumbers:true,
       /*  frozenColumns:[[  //和列（column）属性一样，但是这些列将被冻结在左边。
              {field:'ck',checkbox:true} 
                    ]],  */
         columns:[[
    		{field:'status',title:'用户状态',width:100,align:'center',formatter:function(value, row,index){
    			return formatterByData(value,userStatus);
    		}},
    		//{field:'userType',title:'用户类型',width:100},
    		{field:'roleName',title:'用户角色',width:100,align:'center'},
    		{field:'userId',title:'登录名',width:130,align:'center'},
    		{field:'userName',title:'姓名',width:100,align:'center'},
    		{field:'deptName',title:'所属部门',width:110,align:'center'},
    		{field:'postName',title:'职位',width:120,align:'center'},
    		{field:'emal',title:'邮箱',width:200,align:'center'},
    		{field:'mobile',title:'手机号',width:130,align:'center'},
    		{field:'1',title:'操作',width:190,formatter:userFormatter,align:'center'}
        ]],
        toolbar: '#tb',
        onLoadSuccess:function(data){
			PriManager.queryPriInfoByUserAuth('','');
			PriManager.priFunction('','');
		}
    		
    });
    
    function formatterByData(srcValue,data){
    	if(!srcValue && srcValue != 0){
    		return srcValue;
    	}		
    	if(!data){
    		return srcValue ;
    	}
    	var retStr = srcValue;
    	$.each(data,function(key,item){
    		if(item && srcValue == item.VALUE){
    			if(item.TITLE){
    				retStr = item.TITLE;
    			}
    			if(item.TEXT){
    				retStr = item.TEXT;
    			}
    		}
    	});
    	return retStr;
    }
    
   /*  //权限控制
    $('#userList').datagrid({
		toolbar: '#tb',
	}); */
	
	$(function(){
    $("#addUserButton").click(function(){
    	openDialog('add');
    });
    
    //为网格头部添加动作按钮
   /*  $('#userList').datagrid({
    	toolbar: [{
    		text: '新增用户',
    		iconCls: 'icon-add',
    		handler: function(){
    			openDialog('add');
    			//loadUserProject('');
    		}
    	}]
    }); */
    
    var pager = $('#userList').datagrid('getPager');	
    pager.pagination({ 
        pageSize: 10, //每页显示的记录条数，默认为10 
        pageList: [5,10,15], //可以设置每页记录条数的列表 
        beforePageText: '第', //页数文本框前显示的汉字 
        afterPageText: '页    共 {pages} 页', 
        displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录', 
       /* onBeforeRefresh:function(){
            $(this).pagination('loading');
            alert('before refresh');
            $(this).pagination('loaded');
        } */
       /*  onSelectPage:function(pageNumber, pageSize){
        	$('#userList').datagrid().datagrid('getPager').pagination('loading');
        	alert(11);
        	$('#userList').datagrid().datagrid('getPager').pagination('loaded');
        } */

    }); 
    
    //面板
    $('#selectedProject').panel({
    	title:'选取项目',
		width:660,
		height:'auto',
		noheader:false,
		doSize:true,
		cache:false,
		 tools:[{
			 iconCls:'icon-add',
			 handler:function(){
				 var selectProjectAction = true;
				 if(!isDel){
					 if($("#userName").val() == ""){
						 $.messager.alert('提示','请先读取OA用户');
						 selectProjectAction = false;
					 }
				 }
				 if(selectProjectAction){
				 	selectProject();
				 }
			 }
			 }]

		});  
	});
	
	//异步加载角色(包含账户管理查询条件，增加用户中的角色)
	$.ajax({
		type:'post',
		url:'/sysUser/ajaxQryRoleList.action',
		data:{'id':'all'},
		dataType:'json',
		success:function(json){
			var optionHtml = '<option selected="selected" value="">请选择</option>';
			var userAddRoleHtml = '<option selected="selected" value="">请选择</option>';
			$.each(json.rows,function(index,p){
				optionHtml += '<option value="'+p.id+'">'+p.rolename+'</option>';
				userAddRoleHtml += '<option value="'+p.id+'">'+p.rolename+'</option>';
			})
			$("#userAllRole").html(optionHtml);
			$("#userAddRole").html(userAddRoleHtml);
		}
	});
	
	/* //增加账号-加载角色
	$("#userRoles").combobox({
		editable : false,
		url:'/sysUser/ajaxQryRoleList.action',
		panelHeight : 'auto', //设置下拉框的长度
		width : 150,
		height : '20',
		valueField : 'id',
		textField : 'text'
	}); */
	
	
	
		//查询按钮传递参数到后台
		function doSearch() {
			var userStatus = $('#userStatus').val();
			var userRoleId = $('#userAllRole').val();
			var userId = $("#byUserId").val();
			var userName = $("#byUserName").val();
			var deptName = $("#byDeptName").val();
			/* if(userId != ""){
				//不能出现%号、单引号、双引号、？号
				var reg = /^[^\%\'\"\?]*$/;  
				if(!reg.test(userId)){
					$.messager.alert('提示','登录名不能是特殊字符');
					return false;
				}
			}else if(deptName != ""){
				var reg = [\u4e00-\u9fa5];
				if(!reg.test(deptName)){
					$.messager.alert('提示','部门名称只能输入中文或者英文');
					return false;
				}*/
			$('#userList').datagrid('load', {
				userid : userId,
				comaccountName : userName,
				deptName : deptName,
				userStatus : userStatus,
				roleId : userRoleId
			});
		}
	
	//弹出新增用户对话框
	function openDialog(actionType){
		//初始化进来清空上次异步加载的数据
		if('add' != actionType){ //如果不是增加就“删除读取oa用户事件”
			$('#oaUser').removeAttr('onclick');
			isDel = true;
		}else{
			isDel = false;			
			$("#oaUser").attr("onclick","selectOAUser();"); 
			$("input:checkbox[value='1']").prop('checked',true);
			$("input:checkbox[value='0']").prop('checked',false);
		}
		$("#userId").val('');
		$("#userName").val('');
		$("#deptName").val('');
		$("#position").val('');
		$("#mobile").val('');
		$("#emal").val('');
		$("#userAddRole").val('');
		$("#selectedProject").html('');
		$('#addUser').dialog({
			title: 'add' == actionType ?'新增用户信息':'编辑用户信息',
			width: 680,
			height: 448,
			closed: false,
			cache: false,
			modal: true,
			/* onLoad:function(){
				//alert($("#userId").val());
			}, */
			buttons:[{
				text:'保存',
				width:55,
				handler:function(){
					//测试获取数据
					var status = "";
					var userId = $("#userId").val(); //用户ID
					var userName = $("#userName").val();//用户名称
					var roleId = $("#userAddRole").val(); //角色ID
					var position = $("#position").val(); //职位
					var deptName = $("#deptName").val();//部门名称
					var deptId = $("#deptId").val();//部门ID
					var userEnable = $('input:checkbox[name="userEnable"]:checked').val(); //启用
					var userDisable = $('input:checkbox[name="userDisable"]:checked').val(); //禁用
					if("undefined" == typeof(userEnable) || "" == userEnable){
						status = userDisable;
					}else if("undefined" == typeof(userDisable) || "" == userDisable){
						status = userEnable;
					}
					var projectId = $("#projectId").val();
					var projectCode = $("#projectCode").val();
					if(userId == ""){
						$.messager.alert('提示','请选择OA用户!');
					}else if(roleId == ""){
						$.messager.alert('提示','请选择角色!');
					}else if("undefined" == typeof(status) || status == ""){
						$.messager.alert('提示','请选择账户状态!');
					}else if("undefined" == typeof(projectCode) || projectCode == ""){
						$.messager.alert('提示','请选择项目!');
					}else{
						var addUserObj = {
								 "userId": userId,
								 "comaccountName": userName,
								 "deptName": deptName,
								 "deptId": deptId,
								 "roleId": roleId,
								 "status": status,
								 "position": position,
								 "projectId": projectId,
								 "projectCode" : projectCode		 
						}
						addModifyUser(actionType,addUserObj);
					}
				 }
				},
				{
				text:'取消',
				width:55,
				handler:function(){
					$('#addUser').dialog('close');
				}
				}]
			});
	}
	
	//弹出选取项目区
	function selectProject(){
		var userId = $("#userId").val();
		loadAllProject();
		//loadUserProject(userId);
		$("#selectProject").dialog({
					title: '',
					width: 680,
					height: 448,
					closed: false,
					cache: false,
					modal: true,
					buttons:[{
						text:'保存',
						width:55,
						handler:function(){
							//获取已选区中的项目
							var all_row = $("#existsProjectManager").datagrid("getData");
						 	if(all_row != null){
								$("#selectedProject").html("");
								var phtml = "";
								var projectCode = "";
								var projectId = "";
								$.each(all_row.rows,function (key,value){
									 phtml += '<p>'+value.PROJECT_NAME+'</p>';
									 if (projectCode != '') {
										 projectCode += ',';
										}
									 	projectCode += value.PROJECT_CODE;
									 	
									 if(projectId != ''){
										 projectId +=',';
									 }
										 projectId += value.ID;
								});
									phtml += '<input id="projectId" type="hidden" value="'+projectId+'"/>';
									phtml += '<input id="projectCode" type="hidden" value="'+projectCode+'"/>';
									$("#selectedProject").html(phtml);
									$('#selectProject').dialog('close');
								} 
						   }
						},
						{
						text:'取消',
						width:55,
						handler:function(){
							$('#selectProject').dialog('close');
						}
						}]
						
		});
	}
	
	
	/* $('#cc').combogrid({
		delay: 500, //延迟加载
		panelWidth:450,
		value:'006',
		idField:'id',
		textField:'text',
		fitColumns:true,
		striped: true,  //条纹状
        multiple: true, //点击不隐藏
        //readonly:true,
		//url:'/data/datagrid_data.json',
		columns:[[
		{field:'id',title:'用户编号',width:60},
		{field:'text',title:'用户名称',width:100},
		]],
		data: [
   			{f1:'value11', f2:'value12'},
   			{f1:'value21', f2:'value22'}
   		]

		}); */
	
	//读取OA用户弹出框
	function selectOAUser(){
			$("#oaUserId").val("");
			$("#oaUserName").val("");
			//显示OA用户列表
			$('#selectUser').datagrid({
					width: 665,			
				 	height:'auto',
			        nowrap: false,
			        striped: true,
			        border: true,
			        collapsible:false,
			        method:'post',
			        url:'/sysUser/ajaxQryUserAllList.action',
			        sortOrder: 'desc',
			        remoteSort:true,
			        idField:'fldId',
			        singleSelect:true,
			        pagination:true,
			        rownumbers:true,
			        onLoadSuccess:function(){
			            $('#selectUser').datagrid('clearSelections'); //不会记住之前的选择状态  
			        }
			        
			});
			 var pager = $('#selectUser').datagrid().datagrid('getPager');	
			    pager.pagination({ 
			        pageSize: 10, //每页显示的记录条数，默认为10 
			        pageList: [5,10,15], //可以设置每页记录条数的列表 
			        beforePageText: '第', //页数文本框前显示的汉字 
			        afterPageText: '页    共 {pages} 页', 
			        displayMsg: '当前显示 {from} - {to} 条记录   共 {total} 条记录', 
			    }); 
			    userMatchQuery(); //重复查询一遍，目的清除上一次查询的记录
		$("#selectOAUser").dialog({
			title: '选择用户',
			width: 680,
			height: 448,
			closed: false,
			cache: false,
			//href: '/select_user_list.jsp',
			modal: true,
			/* onLoad:function(){
			}, */
			toolbar:[{
				text:'确定',
				iconCls:'icon-save',
				handler:function(){
					getAllUser();
					}
				},
				{
				text:'刷新',
				iconCls:'icon-reload',
				handler:function(){
					$('#selectUser').datagrid('reload');
				 }
				},
				{
				text:'关闭',
				iconCls:'icon-cancel',
				handler:function(){
					$('#selectOAUser').dialog('close');	
				}
				}]
	});
}
	
/* 	//显示OA用户列表
	$('#selectUser').datagrid({
		url:'/sysUser/ajaxQryUserAllList.action',
		singleSelect:true
	}); */
	
	
	//根据用户ID,用户名称
	function userMatchQuery(){
		var userId = $("#oaUserId").val();
		var userName = $("#oaUserName").val();
		$('#selectUser').datagrid('load', {
			userid : userId,
			userName : userName
		});
	}
	
	//模糊匹配查询 【匹配指定的列名】
	function matchingSelect() {
		var row;
		var hideIndexs = new Array();
		hideIndexs.length = 0;
		var userId = $.trim($("#comaccountCode").val());
		var userName = $.trim($("#comaccountName").val());
		if (userId != "" || userName != "") {
			var rows = $('#selectUser').datagrid('getRows');
			var cols = $('#selectUser').datagrid('options').columns[0];
			for (var i = rows.length - 1; i >= 0; i--) {
				if (userId != null) {
					row = rows[i]['comaccountCode']; //数据接入后需要更改实际名称
				} else {
					row = rows[i]['comaccountName']; //数据接入后需要更改实际名称
				}
				var isMatch = false;
				var pValue = row;
				if (pValue == undefined) {
					continue;
				}
				if (pValue.toString().indexOf(userId) >= 0) {
					console.log("匹配成功", row);
					isMatch = true;
				}
				if (pValue.toString().indexOf(userName) >= 0) {
					console.log("匹配成功", row);
					isMatch = true;
				}
				if (!isMatch) {
					hideIndexs.push(i);
					//$('#selectUser').datagrid('refreshRow', i);
				}
			}
			$('#selectUser').datagrid({
				singleSelect : true,
				rowStyler : function(index, row) {
					if (hideIndexs.indexOf(index) >= 0) {
						return 'background-color:red; display:none';
					} else {
						//return 'background-color:#FFE48D'; //选中的显示样式
					}
				}
			});
		}

	}
	//获取选中OA用户值
	function getAllUser() {
		var row = $("#selectUser").datagrid("getSelected");
		if(null != row && row.userId != null && row.userName != ""){
		var userCode = row.userId;
		//var userCode = 'zhangxinyuan';
		if (row != null) {
			$.ajax({
				type:'post',
				url:'/sysUser/ajaxQryUserInfo.action',
				data:{'userid':userCode,'type':'1','tag':'1'},
				dataType:'json',
				success:function(json){
					$("#userId").val(json.userId);
					$("#userName").val(json.userName);
					$("#deptName").val(json.deptName);
					$("#deptId").val(json.deptId);
					$("#position").val(json.postName);
					$("#mobile").val(json.mobile);
					$("#emal").val(json.emal);
					/*  if(json.status == 1){
							$("input:checkbox[value='1']").prop('checked',true);
							$("input:checkbox[value='0']").prop('checked',false);
						}else{
							$("input:checkbox[value='0']").prop('checked',true);
							$("input:checkbox[value='1']").prop('checked',false);
						}  */
					//展示已经加载的项目
					loadUserProject(json.userId);
					loadProject.existsProject(json.userId);
					$('#selectOAUser').dialog('close');
				}
			});
		  }
		}else{
			$.messager.alert('提示','请选择用户');
		}
	}
	
	//账户管理列表操作
	 function userFormatter(value,row,index){
	        var retStr ="";
	        //if(row.RULE_STATUS == 1){
	            retStr += "&nbsp;&nbsp;&nbsp;<a href='#' pri_id='98' onclick='qryUserInfo(\""+row.userId+"\",1)'>修改</a>";
	        //}
	            //PriManager.queryPriInfoByUserAuth('',priIdArray);
	        	//setTimeout(PriManager.priFunction,400);
	        return retStr;
	    }
	
	//账户修改查询
	function qryUserInfo(userId,type){
		$.ajax({
			type:'post',
			url:'/sysUser/ajaxQryUserInfo.action',
			data:{'userid':userId,'type':type,'tag':'2'},
			dataType:'json',
			success:function(json){
				//返回的json 填充到页面
				openDialog('modify');
				$("#userId").val(json.userId);
				$("#userName").val(json.userName);
				$("#deptName").val(json.deptName);
				$("#position").val(json.postName);
				$("#mobile").val(json.mobile);
				$("#emal").val(json.emal);
				$("#userAddRole").val(json.roleId);
				 if(json.status == 1){
					$("input:checkbox[value='1']").prop('checked',true);
					$("input:checkbox[value='0']").prop('checked',false);
				}else{
					$("input:checkbox[value='0']").prop('checked',true);
					$("input:checkbox[value='1']").prop('checked',false);
				} 
				//展示已经加载的项目
				loadUserProject(json.userId);
				loadProject.existsProject(json.userId);
			}
			
		});
			
	}
	//点击选取项目的时候加载
	function loadAllProject() {
		$('#selectProjectManager').datagrid({
			title : '待选取项目',
			height : 'auto',
			nowrap : false,
			striped : true,
			border : true,
			collapsible : false,
			method : 'post',
			url : '/sysUser/ajaxQryAllProject.action',
			sortOrder : 'desc',
			remoteSort : false,
			idField : 'fldId',
			singleSelect : false,
			pagination : false,
			rownumbers : false,
			frozenColumns : [ [ {
				field : 'ck',
				checkbox : true
			} ] ],
			onLoadSuccess:function(){  
	            $('#selectProjectManager').datagrid('clearSelections'); //一定要加上这一句，要不然datagrid会记住之前的选择状态  
	        },
	        toolbar: [{
	    		text: '添加',
	    		iconCls: 'icon-add',
	    		handler: function(){
	    			//获取待选区域的选中的项目
					var row = $("#selectProjectManager").datagrid("getSelections");
					var all_row = $("#existsProjectManager").datagrid("getData");
	    			if(null == row || "" == row){
	    				 $.messager.alert('提示','请选择要添加的项目');
	    				 return false;
	    			}
    				for(var i=0;i<row.length;i++){
    					//去重并添加
    					if(!existsProject(row[i].PROJECT_CODE,all_row.rows)){
    						$("#existsProjectManager").datagrid('insertRow', {   //在指定行添加数据，appendRow是在最后一行添加数据
                                   index: 0,    // 行数从0开始计算
                                   row: {
                                	ID:row[i].ID,
                                   	PROJECT_CODE:row[i].PROJECT_CODE,
                                   	PROJECT_NAME:row[i].PROJECT_NAME
                                   }
                               });
    					}
    				}
	    		}
	    	}]
		});
	}
	
	//添加项目区重复
	 function existsProject(projectCode,existList){
         var flag = false;
         $.each(existList,function (key,value){
			if(value.PROJECT_CODE == projectCode){
                 flag = true;
             }
         });
         return flag;
     }
	
	//点击选取项目的时候加载
	function loadUserProject(userId){
		$('#existsProjectManager').datagrid({
			title : '已选取项目',
			height : 'auto',
			nowrap : false,
			striped : true,
			border : true,
			collapsible : false, 
			method : 'post',
			url : '/sysUser/ajaxQryUserProject.action',
			sortOrder : 'desc',
			remoteSort : false,
			idField : 'fldId',
			singleSelect : false,
			pagination : false, 
			rownumbers : false,
			frozenColumns : [ [ {
				field : 'ck',
				checkbox : true
			} ] ],
			onLoadSuccess:function(){  
	            $('#existsProjectManager').datagrid('clearSelections'); //一定要加上这一句，要不然datagrid会记住之前的选择状态  
	        },
			queryParams: {
					userId: userId
				},
			toolbar: [{
		    		text: '删除',
		    		iconCls: 'icon-remove',
		    		handler: function(){
		    			var rows = $('#existsProjectManager').datagrid("getSelections");
		    			 /**
		    			   datatgrid删除行deleteRow的方法中，他在删除行以后会去调
		    			   opts.view.deleteRow.call(opts.view,_4d2,_4d3);刷新页面上的行的index，index会发生改变；
		    			      你原来rows的数据也会发生改变，把这个rows复制给另外一个数组,否则达不到删除全部效果
		    			 */
		    			 if("undefined" == typeof(rows) || "" == rows){
		    				 $.messager.alert('提示','请选择要删除的项目');
		    				 return false;
		    			 }
	    			 	var copyRows = [];
	    		        for ( var j= 0; j < rows.length; j++) {
	    		        		copyRows.push(rows[j]);
	    		      		}
	    		       
		    		     for(var i = 0;i < copyRows.length; i++){
		    		    	 var createDt = copyRows[i].CREATE_DT;
		    		    	 if("undefined" == typeof(createDt) || createDt == ""){
		    		    		 var index = $('#existsProjectManager').datagrid('getRowIndex',copyRows[i]);
			    		         $('#existsProjectManager').datagrid('deleteRow',index); 
		    		    	 }else{
		    		    	     if(!isDel){ //用全局变量来控制新增的时候已经存在的人员
		    		    	    	 $.messager.alert('提示','此新增用户已经存在，如要删除请点击修改。');
		    		    	    	 return false;
		    		    	     }
		    		    		 $.ajax({
		    		    		 type:'post',
		    		    		 url:'/sysUser/ajaxModifyUserProject.action',
		    		    		 data:{'userId':userId,'projectId':copyRows[i].ID},
		    		    		 async: false,
		    		    		 dataType:'json',
		    		    		 success:function(json){
		    		    			 if(json.success){
		    		    				 var index = $('#existsProjectManager').datagrid('getRowIndex',copyRows[i]);
		 		    		             $('#existsProjectManager').datagrid('deleteRow',index); 
		    		    			 }
		    		    		 }
		    		    	 });
		    		         }
		    		      }
		    		}
		    	}]
		});
	}
	
	//保存 或者修改账户
	function addModifyUser(action,userObj){
		$.ajax({
			type:'post',
			url:'/sysUser/ajaxAddModifyUser.action',
			data:{
				'userid':userObj.userId,
				'roleId':userObj.roleId,
				'userStatus':userObj.status,
				'projectId':userObj.projectId,
				'projectCode':userObj.projectCode,
				'comaccountName':userObj.comaccountName,
				'deptName':userObj.deptName,
				'deptId':userObj.deptId,
				'position':userObj.position,
				'tag': 'add' == action ? 'add' :'update'
				},
			dataType:'json',
			success:function(json){
				if(json.success){
					if("add" == action){
						$.messager.alert('提示','增加账户成功！');
					}else{
						$.messager.alert('提示','修改账户成功！');
					}
					//关闭对话框
					$('#addUser').dialog('close');
					//刷新列表
					$('#userList').datagrid('reload');
				}else{
				    if("-301" == json.resulStatus){
				    	$.messager.alert('提示','用户已存在！');
				    }else if("add" == action){				
						$.messager.alert('提示','增加账户失败！');
					}else{
						$.messager.alert('提示','修改账户失败！');
					}
				}
			}
		});
	}
	
	//展示已经加载的项目
	var loadProject = {
			existsProject:function(userId){
				$.ajax({
					type : 'post',
					url : '/sysUser/ajaxQryUserProject.action',
					data:{'userId':userId},
					dataType:'json',
					success:function(json){
						$("#selectedProject").html("");
						var phtml = "";
						var projectCode = "";
						var projectId = "";
						$.each(json,function(index,value){
							 phtml += '<p>'+value.PROJECT_NAME+'</p>';
							 if (projectCode != '') {
								 projectCode += ',';
								}
							 	projectCode += value.PROJECT_CODE;
							 	
							 if(projectId != ''){
								 projectId +=',';
							 }
								 projectId += value.ID;	
						
						});
						phtml += '<input id="projectId" type="hidden" value="'+projectId+'"/>';
						phtml += '<input id="projectCode" type="hidden" value="'+projectCode+'"/>';
						$("#selectedProject").html(phtml);
					}
				});
			
			}
	}
	
</script>
</body>
</html>