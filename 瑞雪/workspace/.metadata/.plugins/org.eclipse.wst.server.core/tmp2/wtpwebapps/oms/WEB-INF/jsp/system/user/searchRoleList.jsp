<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
/* var priIdArray = [93,94,95];
$(function(){
	PriManager.queryPriInfoByUserAuth('',priIdArray);
}); */
</script>
</head>
<body>
	<!-- 查询区 -->
	<div style="padding: 3px 2px; border-bottom: 0px solid #ccc; color: #5578AE">系统管理>角色管理</div>
	<!-- 列表区 -->
	<table id="roleList" style="padding: 0px; margin: 0px; width: 100%"></table>
	<div id="tb">
		<a id="addRoleButton" href="javascript:void(0)" class="easyui-linkbutton" pri_id='93'
			data-options="iconCls:'icon-add',plain:true,text : '新增角色',"></a>
	</div>
	<!-- 增加编辑角色区 -->
	<div id="addRole" style="display: none;">
		<form id="addRoleForm" method="post" style="padding: 18px; margin-left: 7px;">
			<table cellpadding="5">
				<tr id="roleCode" style="display: none;">
					<td>角色编号:</td>
					<td><input id="roleId" class="easyui-textbox" type="text" name="id" style="width: 250px; height: 30px;"
						disabled="disabled"></input></td>
				</tr>
				<tr>
					<td>角色名称:</td>
					<td><input id="roleName" class="easyui-textbox" type="text" name="rolename" data-options="required:true"
						style="width: 250px; height: 30px;"></input></td>
				</tr>
				<tr>
					<td>备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注:</td>
					<td><input id="remark" class="easyui-textbox" name="remark" data-options="multiline:true"
						style="width: 250px; height: 80px"></input></td>
				</tr>
			</table>
		</form>
		<div style="padding: 5px; margin-left: 125px;">
			<a href="javascript:void(0)" class="easyui-linkbutton" style="width: 80px; height: 32px" onclick="submitForm()">保存</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" style="width: 80px; height: 32px; margin-left: 35px;"
				onclick="clearForm()">取消</a>
		</div>
	</div>
	<!-- 权限菜单区 -->
	<div id="userPrivilege" style="display: none;">
		<ul id="privilege">
		</ul>
		<!-- <table id="privilege" style="width: 500px; height: 400px">
		<thead>
			<tr>
				<th field="text" width="240" align="left">权限菜单</th>
				<th field="note" width="260" align="center">说明</th>
			</tr>
		</thead> -->
		</table>
	</div>

	<script type="text/javascript">
	$('#roleList').datagrid({
		title : '功能菜单',
		//width : 952,
		height : 'auto',
		nowrap : false,
		//fit:true, //不能使用
		striped : true,
		border : true,
		collapsible : false,
		method : 'post',
		url : '/sysRole/ajaxQryRoleList.action',
		sortOrder : 'desc',
		remoteSort : false,
		idField : 'fldId',
		singleSelect : true,
		pagination : false,
		rownumbers : true,
		columns : [[ {field : 'id',title : '角色编号',width : 100,align : 'center'},
		              {field : 'rolename',title : '角色名',width : 200,align : 'center'},
		              {field : 'remark',title : '备注',width : 350,align : 'center'},
		              {field : 'userId',title : '操作',width : 290,align : 'center',formatter : roleFormatter}
					]],
		queryParams : {
			id : 'all'
		},
		toolbar: '#tb',
		onLoadSuccess:function(data){
			PriManager.queryPriInfoByUserAuth('','');
			PriManager.priFunction('','');
		}
	});

	//账户管理列表操作
	function roleFormatter(value, row, index) {
		var retStr = "";
		retStr += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' pri_id='94' onclick='qryRoleInfo("
				+ row.id + ")'>修改角色</a>";
		retStr += "&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' pri_id='95' onclick='openDialogPrivilege("
				+ row.id + ")'>功能授权</a>";
		return retStr;
	}
	
	//为网格头部添加动作按钮
	/* $('#roleList').datagrid({
		toolbar : [ {
			text : '新增角色',
			iconCls : 'icon-add',
			handler : function() {
				//清除修改时候遗留的表单信息
				$("#roleCode").hide();
				$("#roleId").textbox('setValue', '');
				$("#roleName").textbox('setValue', '');
				$("#remark").textbox('setValue', '');
				openDialog('add');
			}
		} ]
	}); */
	
	//这样写的目地是为了控制住easyui原生按钮权限(如果多绑定一次就会请求两次体验不好)
	/* $('#roleList').datagrid({
		toolbar: '#tb',
	});
	 */
$(function() {
	$("#addRoleButton").click(function(){
		//清除修改时候遗留的表单信息
		$("#roleCode").hide();
		$("#roleId").textbox('setValue', '');
		$("#roleName").textbox('setValue', '');
		$("#remark").textbox('setValue', '');
		openDialog('add');
	});

	//网格式Tree (缺点是已经分配的角色权限，无法默认选中)
	/*   $('#privilege').treegrid({
	 method:'post',
	 url:'/data/treegrid_data1.json',
	 idField:'id',
	 treeField:'text',
	 title:'功能权限',
	 singleSelect:false,
	 selectOnCheck:true,
	 rownumbers:true, //行号 
	      frozenColumns:[[  //和列（column）属性一样，但是这些列将被冻结在左边。
	             {field:'ck',checkbox:true,width:80} 
	                   ]],
	     onLoadSuccess:function(row,data){ //数据异步加载成功后对以前分配的权限默认选中
	       	  console.log(data);
	             $.each(data,function(i,e){ //第一级对象
	           	  alert(e.text);
	           	  $("#privilege").treegrid('selectRow',i);
	           	 $.each(e.children,function(j,p){ //第二级对象
	           		  alert(p.text);
	           		$("#privilege").treegrid('selectRow',j);
	           		$.each(p.children,function(z,p1){ //第三级对象
	           			alert(p1.text);
	           			$("#privilege").treegrid('selectRow',z);
	           		})
	           	  })
	             });
	         },
	 rownumbers:true
	});
	 */
});

//弹出增加角色表单
function openDialog(actionType) {
	$('#addRole').dialog({
		title : 'add' == actionType ? '新增角色' : '编辑角色',
		width : 450,
		height : 300,
		closed : false,
		cache : false,
		modal : true
	});
}

//保存角色信息
function submitForm() {
	$('#addRoleForm').form('submit', {
		url : '/sysRole/ajaxAddRole.action',
		onSubmit : function(param) {
			var isValid = $(this).form('validate');
			var roleId = $("#roleId").textbox('getValue');
			var remark = $("#remark").textbox('getValue');
			if(remark.length > 50){
				$.messager.alert('提示', "备注限制长度50个字符！");
				isValid = false;
			}
			param.id = roleId;
			return isValid; // 返回false将阻止表单提交
		},
		success : function(json) {
			var data = eval('(' + json + ')'); //改变javascript对象的JSON字符串 
			if (data.success) {
				var message = "增加角色成功！";
				if(roleId != ""){
					message = "修改角色成功！";
				}
				$.messager.alert('提示', message);
				clearForm();
				$('#roleList').datagrid('reload');
			} else {
				$.messager.alert('提示', data.message);
			}
		}
	});
}

//取消增加角色信息
function clearForm() {
	$('#addRole').dialog('close');
}

//弹出分配权限对话框
function openDialogPrivilege(roleId) {
	qryRolePrivilege(roleId);
	$('#userPrivilege').dialog({
		title : '功能权限',
		width : 532,
		height : 400,
		closed : false,
		cache : false,
		modal : true,
		buttons : [ {
			text : '保存',
			width : 55,
			handler : function() {
				//分配角色权限
				getAuthChecked(roleId);
			}
		}, {
			text : '取消',
			width : 55,
			handler : function() {
				$('#userPrivilege').dialog('close');
			}
		} ]
	});
}

function qryRolePrivilege(roleId) {
	//异步树构建-分配权限菜单
	 $('#privilege').tree({
		url : '/sysRole/ajaxQryRolePrivilege.action',
		method : 'post',
		//cascadeCheck :false, //是否级联勾选
		checkbox : true,
		cache : false,
		lines : true,
		onBeforeLoad : function(node, param) {
			param.roleId = roleId
		},
		onLoadSuccess:function(node,data){
			if("false"==data.success){
				$.messager.alert('提示', '查询角色权限失败！','',function(){
					$('#userPrivilege').dialog('close');
				});
			}
		},
		onLoadError : function(arguments) {
			window.parent.location.href='/login.html';
		}
	});

}

//保存分配的权限获取树checkBox选中的节点包含父节点 就需要 加上 'indeterminate'
function getAuthChecked(roleId) {
	//var nodes = $('#privilege').treegrid('getSelections');
	var nodes = $('#privilege').tree('getChecked', [ 'checked','indeterminate' ]);
	var privilegeId = '';
	if (nodes.length > 0) {
		for (var i = 0; i < nodes.length; i++) {
			if (privilegeId != '') {
				privilegeId += ',';
			}
			privilegeId += nodes[i].id;
		}
	}
	/* if (privilegeId == "") {  //有可能取消所有权限
		$.messager.alert('提示', '请选择要分配的功能菜单');
		return false;
	} */
	$.ajax({
		type : 'post',
		url : '/sysRole/ajaxAuthRolePrivilege.action',
		data : {
			'roleId' : roleId,
			'menuId' : privilegeId
		},
		dataType : 'json',
		success : function(json) {
			if (json.success) {
				$.messager.alert('提示', '分配角色权限成功！');
				$('#userPrivilege').dialog('close');
			} else {
				$.messager.alert('提示', '分配角色权限失败！');
			}
		}
	});
	console.log("选中的权限ID为：" + privilegeId);
}

//修改查询角色
function qryRoleInfo(roleId) {
	$.ajax({
		type : 'post',
		url : '/sysRole/ajaxQryRoleList.action',
		data : {
			'id' : roleId
		},
		dataType : 'json',
		success : function(json) {
			$("#roleCode").show();
			$("#roleId").textbox('setValue', json.rows[0].id);
			$("#roleName").textbox('setValue', json.rows[0].rolename);
			$("#remark").textbox('setValue', json.rows[0].remark);
			openDialog();
		}
	});
}
</script>
</body>
</html>