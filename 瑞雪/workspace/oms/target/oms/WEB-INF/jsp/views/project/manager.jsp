<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 2016/6/26
  Time: 9:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<title>项目管理</title>
<jsp:include page="../../../../import.jsp" flush="true" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
	<table id="projectGrid">
	</table>
	<div id="project_detail_tabs" class="easyui-tabs" style="height: 400px; width: 100%; display: none;">
		<div title="店铺列表" style="padding: 10px;">
			<table id="project_shop_grid">
			</table>
		</div>
		<!-- end tab 店铺列表 -->
		<div title="人员列表" style="padding: 10px;">
			<table id="project_user_grid">
			</table>
		</div>
		<!-- end tab 人员列表 -->
		<div title="结算规则" style="padding: 10px;">
			<table id="project_rule_grid">
			</table>
		</div>
		<!-- end tab 结算规则 -->
		<div title="账期管理" style="padding: 10px;">
			<table id="project_settle_grid">
			</table>
		</div>
		<!-- end tab 账期管理 -->
	</div>
	<div id="projectForm">
		<INPUT TYPE="hidden" NAME="index" id="index" value=''> <INPUT TYPE="hidden" NAME="projectId" id="projectId"
			value=''>
		<table class="apollo-form">
			<tr>
				<!-- <td>项目编号：</td>
				<td><input id="PROJECT_CODE" required="true" /></td> -->
				<td><span style="color: red;">*</span>项目名称：</td>
				<td><input id="PROJECT_NAME" required="true" /></td>
			</tr>
			<tr>
				<td>是否关联ERP：</td>
				<td><input id='IS_RELATE_ERP' type="checkbox" onclick="checkRelate();" /></td>
				<td>ERP项目名称：</td>
				<td><input id='ERP_PROJ_NAME' class="easyui-combobox" disabled="disabled" required="true" /></td>
			</tr>
			<tr>
				<td><span style="color: red;">*</span>项目类型：</td>
				<td><input id='PROJECT_TYPE' class="easyui-combobox" required="true" /></td>
				<td><span style="color: red;">*</span>签约公司：</td>
				<td><input id='SIGN_COMPANY' class="easyui-combobox" required="true" /></td>
			</tr>
			<tr>
				<td><span style="color: red;">*</span>项目状态：</td>
				<td><input id='PROJECT_STATUS' class="easyui-combobox" /></td>
				<td><span style="color: red;">*</span>所属地区：</td>
				<td><input id='AREA' class="easyui-combobox" /></td>
			</tr>
			<tr>
				<td><span style="color: red;">*</span>经营类目：</td>
				<td><input id='OPERATE_GENRE' class="easyui-combobox" required="true" /></td>
			</tr>
		</table>
	</div>

	<div id="projectUserForm" class="easyui-dialog" closed="true"
		data-options="iconCls:'icon-save',resizable:true,modal:true,buttons:'#projectUserForm_bb',onClose:function(){
    $('#projectUserForm_userName').val('');$('#projectUserForm_deptName').val('');}"
		title="对话框" iconCls="icon-edit">
		<div id="cc" class="easyui-layout" style="width: 100%; height: 380px;">
			<div data-options="region:'north',title:'人员选择'" style="height: 0px;"></div>
			<div data-options="region:'west',split:true" style="width: 580px;">
				<table id="projectUserForm_grid" style="height: 300px"></table>
			</div>
			<div data-options="region:'center'" style="padding: 5px;">
				<table id="projectUserForm_grid_checked" style="height: 300px"></table>
			</div>
		</div>
	</div>


	<div id="projectUserForm_bb">
		<a href="#" class="easyui-linkbutton">确定</a> <a href="#" class="easyui-linkbutton">取消</a>
	</div>
	</div>

	<div id="projectShopForm" class="easyui-dialog" closed="true" style="padding: 10px 20px;"
		data-options="iconCls:'icon-save',resizable:true,modal:true,buttons:'#projectShopForm_bb'" title="对话框"
		iconCls="icon-edit">

		<INPUT TYPE="hidden" NAME="projectShopFormShopId" id="projectShopFormShopId" value=''>
		<table class="apollo-form">
			<tr>
				<td>项目名称：</td>
				<td><input id='PROJECT_NAME_FORM' /></td>
				<td><span style="color: red;">*</span>店铺名称：</td>
				<td><input id='SHOP_NAME_FORM' required='ture' /></td>
			</tr>
			<tr>
				<td><span style="color: red;">*</span>关联ERP店铺：</td>
				<td><input id='ERP_SHOP_NAME_FORM' class="easyui-combobox" /></td>
				<td><span style="color: red;">*</span>平台：</td>
				<td><input id='PLAT_NAME_FORM' class="easyui-combobox" required='ture' /></td>
			</tr>
		</table>
		<div id="projectShopForm_bb">
			<a href="#" class="easyui-linkbutton">确定</a> <a href="#" class="easyui-linkbutton">取消</a>
		</div>
	</div>

	<iframe name='hidden_frame' id="hidden_frame" style='display: none'></iframe>

	<div id="projectSettleRuleForm" class="easyui-dialog" closed="true" style="padding: 10px 20px;"
		data-options="iconCls:'icon-save',resizable:true,modal:true,buttons:'#projectSettleRuleForm_bb'" title="对话框"
		iconCls="icon-edit">
		<form id="fm" action="/project/rule/filesUpload.action" method="post" enctype="multipart/form-data"
			target="hidden_frame">
			<table class="apollo-form" id="projectSettleRuleForm_table">
				<tr>
					<td>项目名称：</td>
					<td><input id='rule_proj_name' name="rule_proj_name" disabled="disabled"
						class="easyui-validatebox projectSettleRule_text" data-options="required:true" /></td>
					<td>签约公司：</td>
					<td><input id='rule_sign_company' name="rule_sign_company" class="easyui-validatebox projectSettleRule_combo" /></td>
				</tr>
				<tr>
					<td>品牌商名称：</td>
					<td><input id='rule_brand_biz_name' name="rule_brand_biz_name"
						class="easyui-validatebox projectSettleRule_text" data-options="required:true" /></td>
					<td>品牌公司合作方式：</td>
					<td><input id='rule_contact_type' name="rule_contact_type" class="easyui-validatebox projectSettleRule_combo" /></td>
				</tr>
				<tr>
					<td>品牌商公司地址：</td>
					<td colspan="3"><input id='rule_brand_biz_addr' name="rule_brand_biz_addr"
						class="easyui-validatebox projectSettleRule_text" style="width: 100%;" data-options="required:true" /></td>
				</tr>
				<tr>
					<td>仓库负责方：</td>
					<td><input id='rule_wms_charge' name="rule_wms_charge" class="easyui-validatebox projectSettleRule_combo" /></td>
					<td>仓储费承担方：</td>
					<td><input id='rule_wms_fee_charge' name="rule_wms_fee_charge"
						class="easyui-validatebox projectSettleRule_combo" /></td>
				</tr>
				<tr>
					<td>快递负责方：</td>
					<td><input id='rule_tms_charge' name="rule_tms_charge" class="easyui-validatebox projectSettleRule_combo" /></td>
					<td>快递费承担方：</td>
					<td><input id='rule_tms_fee_charge' name="rule_tms_fee_charge"
						class="easyui-validatebox projectSettleRule_combo" /></td>
				</tr>
				<tr>
					<td>客服负责方：</td>
					<td><input id='rule_custorm_charge' name="rule_custorm_charge"
						class="easyui-validatebox projectSettleRule_combo" /></td>
					<td>退款操作方：</td>
					<td><input id='rule_refund_charge' name="rule_refund_charge"
						class="easyui-validatebox projectSettleRule_combo" /></td>
				</tr>
				<tr>
					<td>软件使用情况：</td>
					<td><input id='rule_software_use' name="rule_software_use" class="easyui-validatebox projectSettleRule_text"
						data-options="required:true" /></td>
					<td><input id="checkCurrency" type="checkbox" onchange="selectCurrency()" value="1">备用金：</td>
					<td><input id='rule_spare_currency' name="rule_spare_currency"
						class="easyui-validatebox projectSettleRule_text" disabled="disabled" data-options="required:true" /></td>
				</tr>
				<tr>
					<td>我司结算负责人：</td>
					<td><input id='rule_we_settle_person' name="rule_we_settle_person"
						class="easyui-validatebox projectSettleRule_text" data-options="required:true" /></td>
					<td>我司结算负责人联络方式：</td>
					<td><input id='rule_we_person_phone' name="rule_we_person_phone"
						class="easyui-validatebox projectSettleRule_text" data-options="required:true" /></td>
				</tr>
				<tr>
					<td>品方运营负责人：</td>
					<td><input id='rule_pf_operator' name="rule_pf_operator" class="easyui-validatebox projectSettleRule_text"
						data-options="required:true" /></td>
					<td>品方运营负责人联络方式：</td>
					<td><input id='rule_pf_operator_phone' name="rule_pf_operator_phone"
						class="easyui-validatebox projectSettleRule_text" data-options="required:true" /></td>
				</tr>


				<tr>
					<td>品方结算联系人：</td>
					<td><input id='rule_pf_settle_person' name="rule_pf_settle_person"
						class="easyui-validatebox projectSettleRule_text" data-options="required:true" /></td>
					<td>品方结算人联络方式：</td>
					<td><input id='rule_pf_settle_person_phone' name="rule_pf_settle_person_phone"
						class="easyui-validatebox projectSettleRule_text" data-options="required:true" /></td>
				</tr>
				<tr>
					<td>品方结算人邮箱：</td>
					<td colspan="3"><input id='rule_pf_settle_person_email' name="rule_pf_settle_person_email"
						style="width: 100%;" class="easyui-validatebox projectSettleRule_text"
						data-options="required:true,validType:'email'" /></td>
				</tr>
				<tr>
					<td>品牌公司邮寄地址：</td>
					<td colspan="3"><input id='rule_pf_company_addr' name="rule_pf_company_addr" style="width: 100%;"
						class="easyui-validatebox projectSettleRule_text" data-options="required:true" /></td>
				</tr>
				<tr>
					<td>合同开始日期：</td>
					<td><input id='rule_contract_begin_dt' name="rule_contract_begin_dt"
						class="easyui-validatebox easyui-datetimebox projectSettleRule_date" /></td>
					<td>合同截止日期：</td>
					<td><input id='rule_contract_end_dt' name="rule_contract_end_dt"
						class="easyui-validatebox easyui-datetimebox projectSettleRule_date" /></td>
				</tr>
				<tr>
					<td>基础服务费：</td>
					<td><input id='rule_currency_type' name="rule_currency_type"
						class="easyui-validatebox projectSettleRule_combo" /> <input id='rule_service_fee' name="rule_service_fee"
						class="easyui-validatebox projectSettleRule_text" data-options="required:true" /></td>
					<td>基础服务费计费周期：</td>
					<td><input id='rule_service_fee_period' name="rule_service_fee_period"
						class="easyui-validatebox projectSettleRule_combo" /></td>
				</tr>

				<tr>
					<td>佣金提点：</td>
					<td><input id='rule_commission_td' name="rule_commission_td" class="easyui-validatebox projectSettleRule_text"
						data-options="required:true" /></td>
					<td>佣金计费周期：</td>
					<td><input id='rule_commission_fee_period' name="rule_commission_fee_period"
						class="easyui-validatebox projectSettleRule_combo" /></td>
				</tr>
				<tr>
					<td>佣金提点计算公式：</td>
					<td><input id='rule_commission_td_rule' name="rule_commission_td_rule"
						class="easyui-validatebox projectSettleRule_text" data-options="required:true" /></td>
					<!--  <td>币种：</td><td><input id='rule_currency_type' name="rule_currency_type" class="easyui-validatebox projectSettleRule_combo"/></td> -->
				</tr>
				<tr>
					<td>基础服务费回款约定：</td>
					<td><input id='rule_service_fee_remark' name="rule_service_fee_remark"
						class="easyui-validatebox projectSettleRule_text" data-options="required:true" /></td>
					<td>佣金提点回款约定：</td>
					<td><input id='rule_commission_td_remark' name="rule_commission_td_remark"
						class="easyui-validatebox projectSettleRule_text" data-options="required:true" /></td>
				</tr>
				<tr>
					<td>其他备注：</td>
					<td colspan="3"><input id='rule_remark' name="rule_remark" style="width: 100%;" class="projectSettleRule_text" /></td>
				</tr>

				<tr>
					<td>上传附件：<input type="button" id="add_attachment_button" value="添加一项" /></td>
					<td id="upload_attatchment_div"><input id="uploadFile" type="file" name="file" /></td>
				</tr>
			</table>
		</form>
		<div id="projectSettleRuleForm_bb">
			<a href="#" class="easyui-linkbutton">确定</a> <a href="#" class="easyui-linkbutton">取消</a>
		</div>
	</div>

	<div id="projectSettlePeriodForm" class="easyui-dialog" closed="true" style="padding: 10px 20px;"
		data-options="iconCls:'icon-save',resizable:true,modal:true,buttons:'#projectSettlePeriodForm_bb'" iconCls="icon-edit">
		<form id="addModifySettlePeriodForm" method="post" style="padding: 18px; margin-left: 7px;">
			<table class="apollo-form">
				<tr style="height: 40px;">
					<td><span style="color: red;">*</span>结算账期：</td>
					<td><input id='settleYear' name="settleYear" class="easyui-validatebox" />&nbsp;<input id='settlePeriod'
						name="settlePeriod" class="easyui-validatebox" /></td>
				</tr>
				<tr style="height: 40px;">
					<td><span style="color: red;">*</span>起始时间：</td>
					<td><input id='settleBeginDt' name="settleBeginDt" class="easyui-datebox" style="width: 180px;" /></td>
				</tr>
				<tr style="height: 40px;">
					<td><span style="color: red;">*</span>结束时间：</td>
					<td><input id='settleEndDt' name="settleEndDt" class="easyui-datebox" style="width: 180px;" /></td>
				</tr>
			</table>
		</form>
		<div id="projectSettlePeriodForm_bb">
			<a href="#" class="easyui-linkbutton">确定</a> <a href="#" class="easyui-linkbutton">取消</a>
		</div>
	</div>

	<SCRIPT LANGUAGE="JavaScript">
    $("input[type=button]").click(function(){
        var br = $("<br>");
        var input = $("<input type='file' name='file'/>");
        var button = $("<input type='button' value='删除'/>");
        $("#upload_attatchment_div").append(br).append(input).append(button);

        button.click(function(){
            br.remove();
            input.remove();
            button.remove();
        })
    })

    var areaSelect;
    var signCompanySelect;
    var projectStatusSelect =[{ TEXT:"运营中",  VALUE:"1"},{ TEXT:"清算中",  VALUE:"2"},{ TEXT:"已结束",  VALUE:"3"}];
    var projectRuleSelect = [{ TEXT:"我方",  VALUE:"1"},{ TEXT:"品方",  VALUE:"2"}];
    var projectTypeSelect;
    var RXProjectInfoSelect;
    var RXProjectShopSelect;
    var projectOperateSelect;
    var projectSettleRuleSelect;
    var projectRuleCurrencyType;
    var projectSettlePeriodSelect;
    var platSelect = null;
    var AppendUser = new Array(); //添加的项目关联人员


    var ProjectDetailTabs = {
        proj_id:"",
        proj_name:"",
        erp_proj_code:"",
        projectRuleInit:function(){
            $('#project_rule_grid').easyGrid({
                isDownResult:false,
                pagination : false,
                isSearchOpen:true,
                method:"post",
                isDownResult:false,
                onRowContextMenu:[],
                data:{index:'findProjectSettleRule',"projectId":ProjectDetailTabs.proj_id},
                columns:[[
                    {field:'ID',title:'编号',hidden:true,sortable:false,width:100}
                    ,{field:'PROJECT_NAME',title:'项目名称',sortable:false,width:100}
                    ,{field:'BRAND_BIZ_NAME',title:'品牌商名称',sortable:false,width:100}
                    ,{field:'CONTACT_TYPE',title:'合作方式',sortable:false,width:100,formatter:function(value, row,index){
                        return formatterByData(value,projectTypeSelect);
                    }}
                    ,{field:'CURRENCY_TYPE',title:'币种',sortable:false,width:100,formatter:function(value, row,index){
                        return formatterByData(value,projectRuleCurrencyType);
                    }}
                    ,{field:'SERVICE_FEE',title:'基础服务费',sortable:false,width:100}
                    ,{field:'COMMISSION_TD',title:'佣金提点',hidden:true,sortable:false,width:100}
                    ,{field:'SPARE_CURRENCY',title:'备用金',sortable:false,width:100}
                    ,{field:'CONTRACT_BEGIN_DT',title:'合同开始日期',sortable:false,width:100}
                    ,{field:'CONTRACT_END_DT',title:'合同截至日期',sortable:false,width:100}
                    ,{field:'WE_SETTLE_PERSON',title:'我司结算负责人',sortable:false,width:100}
                    ,{field:'CREATE_DT',title:'创建时间',hidden:true,sortable:false,width:100}
                    ,{field:'1',title:'操作',width:180,formatter:projSettleRuleFormatter}
                ]],
                buttons:[{
                    noSelected:true,
                    text:'新增',
                    handler:function(data){
                       $("#upload_attatchment_div").html("<input id=uploadFile name=file type=file><a href='javascript:void(0)' onclick='cleanFile()'>清除</a>");
                       $("#rule_contract_begin_dt").datetimebox('setValue','');
                       $("#rule_contract_end_dt").datetimebox('setValue','');
                       ProjectRuleControl.clearProjectRuleInput();

                        $("#rule_wms_charge").combobox({editable:false,panelHeight:'auto',width:155}).combobox('loadData',jsonToArrayForSelected(projectRuleSelect));
                        $("#rule_wms_fee_charge").combobox({editable:false,panelHeight:'auto',width:155}).combobox('loadData',jsonToArrayForSelected(projectRuleSelect));
                        $("#rule_tms_charge").combobox({editable:false,panelHeight:'auto',width:155}).combobox('loadData',jsonToArrayForSelected(projectRuleSelect));
                        $("#rule_tms_fee_charge").combobox({editable:false,panelHeight:'auto',width:155}).combobox('loadData',jsonToArrayForSelected(projectRuleSelect));
                        $("#rule_custorm_charge").combobox({editable:false,panelHeight:'auto',width:155}).combobox('loadData',jsonToArrayForSelected(projectRuleSelect));
                        $("#rule_refund_charge").combobox({editable:false,panelHeight:'auto',width:155}).combobox('loadData',jsonToArrayForSelected(projectRuleSelect));
                        $("#rule_sign_company").combobox({editable:false,panelHeight:'auto',width:155}).combobox('loadData',jsonToArrayForSelected(signCompanySelect));
                        $("#rule_contact_type").combobox({editable:false,panelHeight:'auto',width:155}).combobox('loadData',jsonToArrayForSelected(projectTypeSelect));
                        $("#rule_service_fee_period").combobox({editable:false,panelHeight:'auto',width:155}).combobox('loadData',jsonToArrayForSelected(projectSettleRuleSelect));
                        $("#rule_commission_fee_period").combobox({editable:false,panelHeight:'auto',width:155}).combobox('loadData',jsonToArrayForSelected(projectSettleRuleSelect));
                        $("#rule_currency_type").combobox({editable:false,panelHeight:'auto',width:155}).combobox('loadData',jsonToArrayForSelected(projectRuleCurrencyType));
                        $("#rule_proj_name").val(ProjectDetailTabs.proj_name);

                        $('#projectSettleRuleForm').dialog({
                            title: '结算规则',
                            iconCls:"icon-edit",
                            collapsible: true,
                            maximizable: true,
                            resizable: true,
                            width: 800,
                            height: 450,
                            //left: 150,
                            top:50,
                            modal: true,
                            buttons: [{
                                text: '提交',
                                iconCls: 'icon-ok',
                                handler: function () {
                                	checkSettlement('','add');
                                   /*  $.messager.progress({
                                        title : '请稍后',
                                        msg : '文件上传中...'
                                    }); */
                                   /*  $("#fm").form("submit",{
                                                url: "/project/rule/addProjectRule.action",
                                                onSubmit: function () {
                                                	var isValid = $(this).form('validate');
                                                    alert(isValid);
													return isValid; // 返回false将阻止表单提交
                                                },
                                                success: function (ss) {
                                                    $.messager.progress('close');
                                                    var result = eval('(' + ss + ')');
                                                    if (result.resultId == "1") {
                                                        $.messager.alert('系统提示', "<font color=red>"
                                                                + result.errorMsg + "</font>");
                                                        return;
                                                    } else {
                                                        $.messager.alert('系统提示', '保存成功');
                                                        $("#fm").form('clear');
                                                        $("#dg").datagrid("reload");
                                                    }
                                                }
                                            }); */

                                    /*var projectShopFormParams = {};

                                     $.each($(".projectSettleRule_text"),function (key,value){
                                     projectShopFormParams[$(this).attr("id")] = $(this).val();
                                     });

                                     $.each($(".projectSettleRule_combo"),function (key,value){
                                     projectShopFormParams[$(this).attr("id")] = $(this).combobox("getValue");
                                     });

                                     $.each($(".projectSettleRule_date"),function (key,value){
                                     projectShopFormParams[$(this).attr("id")] = $(this).datetimebox('getValue');
                                     });
                                     projectShopFormParams.rule_status=1;
                                     projectShopFormParams.rule_currency_type = 1;
                                     projectShopFormParams.rule_project_id = ProjectDetailTabs.proj_id;
                                     projectShopFormParams.rule_project_name = ProjectDetailTabs.proj_name;
                                     projectShopFormParams.url="/project/rule/addProjectRule.action";
                                     apolloAjax(projectShopFormParams,function(retData){
                                     if(retData && retData.resultId == 1){
                                     $('#projectSettleRuleForm').dialog('close');
                                     $("#project_rule_grid").datagrid("reload");
                                     }
                                     },{async:false,type:"post"});
                                    var projectShopFormParams = {};
                                    projectShopFormParams.index="insertProjSettleRule";
                                    projectShopFormParams.rule_status=1;
                                    projectShopFormParams.rule_currency_type = 1;
                                    projectShopFormParams.rule_project_id = ProjectDetailTabs.proj_id;
                                    projectShopFormParams.rule_project_name = ProjectDetailTabs.proj_name;
                                    projectShopFormParams.url="/project/rule/addProjectRule.action";
                                    apolloAjax(projectShopFormParams,function(retData){
                                        if(retData && retData.resultId == 1){
                                            $('#projectSettleRuleForm').dialog('close');
                                            $("#project_rule_grid").datagrid("reload");
                                        }
                                    },{async:false,type:"post"});*/

                                }
                            }, {
                                text: '取消',
                                iconCls: 'icon-cancel',
                                handler: function () {
                                    $('#projectSettleRuleForm').dialog('close');
                                }
                            }]
                        }).dialog('open');
                    }
                }]
            });
        },

        projectUserIsExist:function(userName,existList){
            var flag = false;
            $.each(existList,function (key,value){
                if(value.USER_NAME == userName){
                    flag = true;
                }
            });
            return flag;
        },
        projectUserInit:function(){
            if(ProjectDetailTabs.proj_id){
                $('#project_user_grid').easyGrid({
                    isDownResult:false,
                    pagination : false,
                    isSearchOpen:true,
                    method:"post",
                    isDownResult:false,
                    onRowContextMenu:[],
                    data:{index:'findProjectUser',"projectId":ProjectDetailTabs.proj_id},
                    columns:[[
                        {field:'ID',title:'编号',hidden:true,sortable:false,width:200}
                        ,{field:'USER_NAME',title:'用户名',sortable:false,width:300}
                        ,{field:'USER_ID',title:'用户ID',hidden:true,sortable:false,width:200}
                        ,{field:'USER_POSITION',title:'岗位',sortable:false,width:300}
                        ,{field:'DEPT_ID',title:'部门ID',hidden:true,sortable:false,width:400}
                        ,{field:'DEPT_NAME',title:'部门',sortable:false,width:300}
                        ,{field:'PROJECT_ID',title:'项目ID',hidden:true,sortable:false,width:300}
                        ,{field:'1',title:'操作',width:120,formatter:projUserFormatter}
                    ]],
                    buttons:[{
                        noSelected:true,
                        text:'新增',
                        handler:function(data){
                            //==人员新增操作
                            $('#projectUserForm_grid').easyGrid({
                                isDownResult:false,
                                pagination:true,
                                isSearchOpen:true,
                                method:"post",
                                onRowContextMenu:[],
                                singleSelect:false,
                                data:{index:'queryOAUser',"type":1,"platformId":1},
                                url:"/project/user/queryOAUser.action",
                                columns:[[
                                     {field:'ck',checkbox:true}
                                    ,{field:'userName',title:'用户名',sortable:false,width:250}
                                    ,{field:'userId',title:'用户id',hidden:true,width:300}
                                    ,{field:'deptName',title:'部门名称',width:250}
                                    ,{field:'deptId',title:'部门id',hidden:true,width:300}
                                    ,{field:'postName',title:'岗位',hidden:true,width:300}
                                ]],
                                buttons:[{
                                    text:'添加',
                                    handler:function(data){
                                        var selRows =$('#projectUserForm_grid').datagrid("getChecked");
                                        var all_row = $("#projectUserForm_grid_checked").datagrid("getData"); //获取加载的用户数据
                                        AppendUser=[];
                                        $.each(selRows,function(key,value){ //循环选中的行
                                        	//对比去重
                                            if(!ProjectDetailTabs.projectUserIsExist(value.userName,all_row.rows)){
                                                $("#projectUserForm_grid_checked").datagrid('insertRow', {   //在指定行添加数据，appendRow是在最后一行添加数据
                                                    index: 0,    // 行数从0开始计算
                                                    row: {
                                                        USER_NAME:value.userName
                                                    }
                                                });
                                                //AppendUser=[];
                                                AppendUser.push({"appendUserName":value.userName,"projectId":ProjectDetailTabs.proj_id,"userId":value.userId,"postName":value.postName,"deptId":value.deptId,"deptName":value.deptName});
                                            }
                                        });
                                    }
                                }],
                                search:{
                                    'projectUserForm_userName':{title:'用户名称',equals:true},
                                    'projectUserForm_deptName':{title:'所在部门',equals:true}
                                    //'projectUserForm_stationame':{title:'岗位名称',equals:true}
                                }
                            });
								
                            $('#projectUserForm_grid_checked').easyGrid({
                                isDownResult:false,
                                pagination : false,
                                isSearchOpen:true,
                                method:"post",
                                isDownResult:false,
                                onRowContextMenu:[],
                                data:{index:'findProjectUser',"projectId":ProjectDetailTabs.proj_id},
                                columns:[[
                                    {field:'USER_NAME',title:'用户名',sortable:false,width:300}
                                ]]
                            });


                            $('#projectUserForm').dialog({
                                title: '新增',
                                iconCls:"icon-edit",
                                collapsible: true,
                                maximizable: true,
                                resizable: true,
                                modal: true,
                                buttons: [{
                                    text: '提交',
                                    iconCls: 'icon-ok',
                                    handler: function () {
                                        $.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
                                            if (data) {
                                                var projectShopFormParams = {
                                                    "index":"inserProjectUserBatch",
                                                    "url":"/project/user/addProjectUser.action",
                                                    "userList":JSON.stringify(AppendUser)
                                                };
                                                apolloAjax(projectShopFormParams,function(retData){
                                                    if(retData && retData.resultId == 1){
                                                        $('#projectUserForm').dialog('close');
                                                        $("#project_user_grid").datagrid("reload");
                                                    }
                                                },{async:false,type:"post"});
                                            }
                                        });


                                    }
                                }, {
                                    text: '取消',
                                    iconCls: 'icon-cancel',
                                    handler: function () {
                                        $('#projectUserForm').dialog('close');
                                    }
                                }]
                            }).dialog('open');
                        }
                    }]
                });
            }
        },
        projectShopInt:function(){

            $('#project_shop_grid').easyGrid({
                isDownResult:false,
                pagination : false,
                isSearchOpen:true,
                method:"post",
                isDownResult:false,
                height:"50%",
                onRowContextMenu:[],
                data:{index:'findProjectShop',"projectId":ProjectDetailTabs.proj_id},
                columns:[[
                    {field:'ID',title:'编号',hidden:true,sortable:false,width:200}
                    ,{field:'SHOP_NAME',title:'店铺名称',sortable:false,width:200}
                    ,{field:'SHOP_CODE',title:'店铺编码',hidden:true,sortable:false,width:200}
                    ,{field:'ERP_SHOP_NAME',title:'ERP店铺名称',sortable:false,width:200}
                    ,{field:'ERP_SHOP_CODE',title:'ERP店铺编码',hidden:true,sortable:false,width:200}
                    ,{field:'PLAT_ID',title:'平台ID',hidden:true,sortable:false,width:200}
                    ,{field:'PLAT_NAME',title:'平台名称',sortable:false,width:200}
                    ,{field:'PROJECT_ID',title:'项目ID',hidden:true,sortable:false,width:200}
                    ,{field:'1',title:'操作',width:120,formatter:projShopFormatter}
                ]],
                buttons:[{
                    noSelected:true,
                    text:'新增',
                    handler:function(data){
                    	if(null != ProjectDetailTabs.erp_proj_code && "" != ProjectDetailTabs.erp_proj_code){
                        var params = new Object();
                        params.index = "findRXProjShop";
                        params.nopage = 1;
                        params.ruixueCustGuid = ProjectDetailTabs.erp_proj_code;
                        apolloAjax(params,function(data){
                            if(data){
                                RXProjectShopSelect = data;
                                $("#ERP_SHOP_NAME_FORM").combobox({editable:false,panelHeight: 'auto',width:155}).combobox('loadData',jsonToArrayForSelected(RXProjectShopSelect));
                            }
                        },{async:false});
                    	}
                        //重新加载平台
                         $("#PLAT_NAME_FORM").combobox({editable:false,panelHeight: 'auto',width:155}).combobox('loadData',jsonToArrayForSelected(platSelect));
                        //等于0表示未关联erp项目赋予置灰状态
                        if("0" == ProjectDetailTabs.is_relate_erp){
                        	$("#ERP_SHOP_NAME_FORM").combobox('disable');
                        	$("#ERP_SHOP_NAME_FORM").combobox('clear');
                        }else{
                        	$("#ERP_SHOP_NAME_FORM").combobox('enable'); 
                        }
                        $("#SHOP_NAME_FORM").val("");
                        $('#projectShopForm').dialog({
                            title: '新增店铺',
                            iconCls:"icon-edit",
                            collapsible: true,
                            maximizable: true,
                            resizable: true,
                            width: 600,
                            height: 300,
                            modal: true,
                            buttons: [{
                                text: '提交',
                                iconCls: 'icon-ok',
                                handler: function () {
                                    if(!ValidateControl.projectShopFormCheck()){
                                        return false;
                                    };
                                    var projectShopFormParams = {
                                        "index":"addProjectShop",
                                        "url":"/project/shop/addProjectShop.action",
                                        "projectId":ProjectDetailTabs.proj_id,
                                        "projectName":ProjectDetailTabs.proj_name,
                                        "shopName":$("#SHOP_NAME_FORM").val(),
                                        "erpShopName":$("#ERP_SHOP_NAME_FORM").combobox("getText"),
                                        "erpShopCode":$("#ERP_SHOP_NAME_FORM").combobox("getValue"),
                                        "platName":$("#PLAT_NAME_FORM").combobox("getText"),
                                        "platId":$("#PLAT_NAME_FORM").combobox("getValue"),
                                        "shopStatus":1
                                    };
                                    apolloAjax(projectShopFormParams,function(retData){
                                        if(retData && retData.resultId == 1){
                                            $('#projectShopForm').dialog('close');
                                            $("#project_shop_grid").datagrid("reload");
                                        }
                                    },{async:false,type:"post"});
                                }
                            }, {
                                text: '取消',
                                iconCls: 'icon-cancel',
                                handler: function () {
                                    $('#projectShopForm').dialog('close');
                                }
                            }]
                        }).dialog('open');

                    }
                }],
            });
        },
        projectSettlePeriodInit:function(){
            if(ProjectDetailTabs.proj_id){
                $('#project_settle_grid').easyGrid({
                    isDownResult:false,
                    pagination : false,
                    isSearchOpen:true,
                    method:"post",
                    isDownResult:false,
                    onRowContextMenu:[],
                    data:{index:'findProjectSettlePeriod',"projectId":ProjectDetailTabs.proj_id},
                    columns:[[
                        {field:'ID',title:'结算账期ID',hidden:true,sortable:false,width:200}
                        ,{field:'SETTLE_PERIOD',title:'结算账期',sortable:false,width:300,formatter:function(value, row,index){
                            return settlePeriodformat(row.SETTLE_YEAR,row.SETTLE_PERIOD);
                        }}
                        ,{field:'SETTLE_BEGIN_DT',title:'本期起始时间',sortable:false,width:200}
                        ,{field:'SETTLE_END_DT',title:'本期结束时间',sortable:false,width:300}
                        ,{field:'1',title:'操作',width:120,formatter:projSettlePeriodFormatter}
                    ]],
                    buttons:[{
                        noSelected:true,
                        text:'新增',
                        handler:function(data){
                        	//初始化页面数据
                        	$("#settleBeginDt").datebox("setValue", '');
             				$("#settleEndDt").datebox("setValue",'');
                        	var date = new Date();
                            var settleYear =[{ TEXT:date.getFullYear()-2,  VALUE:date.getFullYear()-2},{ TEXT:date.getFullYear()-1,  VALUE:date.getFullYear()-1},{ TEXT:date.getFullYear(),  VALUE:date.getFullYear()},{ TEXT:date.getFullYear()+1,  VALUE:date.getFullYear()+1},{ TEXT:date.getFullYear()+2,  VALUE:date.getFullYear()+2}];
                        	$("#settleYear").combobox({editable:false,panelHeight: '95',width:80}).combobox('loadData',jsonToArrayForSelected(settleYear));
                        	$("#settleYear").combobox({editable:false,panelHeight: '95',width:80}).combobox('select',date.getFullYear());
                        	$("#settlePeriod").combobox({editable:false,panelHeight: '95',width:98}).combobox('loadData',jsonToArrayForSelected(projectSettlePeriodSelect));
							//绑定新增对话框
                        	$('#projectSettlePeriodForm').dialog({
                                title: '新增账期',
                                iconCls:"icon-edit",
                                width:410,
                                collapsible: false,
                                maximizable: false,
                                resizable: true,
                                modal: true,
                                buttons: [{
                                    text: '保存',
                                    iconCls: 'icon-ok',
                                    handler: function () {
                                    	saveModifySettlePeriod('','add');
                                    }
                                }, {
                                    text: '取消',
                                    iconCls: 'icon-cancel',
                                    handler: function () {
                                        $('#projectSettlePeriodForm').dialog('close');
                                    }
                                }]
                            }).dialog('open');
                        }
                    }]
                });
            }
        }
    }

    function projSettleRuleFormatter(value,row,index){
        var retStr ="";
        if(row.RULE_STATUS == 1){
            retStr += "<a href='#' onclick='ProjectRuleControl.updateProjSetttleRule(\""+row.ID+"\","+row.PROJECT_ID+")'>修改</a>";
            retStr += "&nbsp;&nbsp;<a href='#' onclick='ProjectRuleControl.deleteProjSetttleRule(\""+row.ID+"\","+row.PROJECT_ID+")'>删除</a>";
            retStr += "&nbsp;&nbsp;<a href='#' onclick='ProjectRuleControl.downLoadProjSetttleRule(\""+row.ID+"\","+row.PROJECT_ID+")'>下载附件</a>";
        }
        return retStr;
    }
	
    //格式化结算账期一列
    function settlePeriodformat(settleYear,settlePeriod){
    	var periodName = "";
     	$.each(jsonToArrayForSelected(projectSettlePeriodSelect),function(key,value){
    		if(settlePeriod == value.value){
    			periodName = value.text
    			return false;
    		}
    	});
    	return settleYear + "年"+periodName;
    }
    
    //账期管理列表操作
    function projSettlePeriodFormatter(value,row,index){
        var retStr ="";
        if(row.STATUS == 0){
            retStr += "<a href='#' onclick='updateSettlePeriodControl.updateSettlePeriod(\""+row.ID+"\",\""+row.SETTLE_YEAR+"\",\""+row.SETTLE_PERIOD+"\")'>修改</a>";
        }
        return retStr;
    }
    

	
    var ProjectRuleControl ={
    		//清空结算股则表单
        clearProjectRuleInput:function(){
            $(".projectSettleRule_text").val("");
        },
        initProjectRuleInfo:function(uid,projectId){

            $("#rule_proj_name").val(ProjectDetailTabs.proj_name);
            ProjectRuleControl.clearProjectRuleInput();

            var params ={
                "index":"findProjectSettleRule",
                "uid":uid,
                "nopage":1,
                "projectId":projectId
            };
            apolloAjax(params,function(retData){
                if(retData && retData[0]){
                	//初始化下拉框数据
                	$("#rule_wms_charge").combobox({editable:false,panelHeight: '95',width:155}).combobox('loadData',jsonToArrayForSelected(projectRuleSelect));
                    $("#rule_wms_fee_charge").combobox({editable:false,panelHeight: '95',width:155}).combobox('loadData',jsonToArrayForSelected(projectRuleSelect));
                    $("#rule_tms_charge").combobox({editable:false,panelHeight: '95',width:155}).combobox('loadData',jsonToArrayForSelected(projectRuleSelect));
                    $("#rule_tms_fee_charge").combobox({editable:false,panelHeight: '95',width:155}).combobox('loadData',jsonToArrayForSelected(projectRuleSelect));
                    $("#rule_custorm_charge").combobox({editable:false,panelHeight: '95',width:155}).combobox('loadData',jsonToArrayForSelected(projectRuleSelect));
                    $("#rule_refund_charge").combobox({editable:false,panelHeight: '95',width:155}).combobox('loadData',jsonToArrayForSelected(projectRuleSelect));
                    $("#rule_sign_company").combobox({editable:false,panelHeight: '95',width:155}).combobox('loadData',jsonToArrayForSelected(signCompanySelect));
                    $("#rule_contact_type").combobox({editable:false,panelHeight: '95',width:155}).combobox('loadData',jsonToArrayForSelected(projectTypeSelect));
                    $("#rule_service_fee_period").combobox({editable:false,panelHeight: '95',width:155}).combobox('loadData',jsonToArrayForSelected(projectSettleRuleSelect));
                    $("#rule_commission_fee_period").combobox({editable:false,panelHeight: '95',width:155}).combobox('loadData',jsonToArrayForSelected(projectSettleRuleSelect));
                    $("#rule_currency_type").combobox({editable:false,panelHeight: '95',width:155}).combobox('loadData',jsonToArrayForSelected(projectRuleCurrencyType));
                    $("#rule_proj_name").val(ProjectDetailTabs.proj_name);
					//异步                	
                    var projectRuleInfo = retData[0];
                    $.each(projectRuleInfo,function (key,value){
                        if(key){
                            var loeKey = key.toLowerCase();
                            if($("#rule_"+loeKey) && $("#rule_"+loeKey).length>0){ //根据查询的数据默认选中下拉框的值
                            	if($("#rule_"+loeKey).hasClass("projectSettleRule_combo")){
                            		$("#rule_"+loeKey).combobox({editable:false,panelHeight: '95',width:155}).combobox('select',value);
                            	}else if($("#rule_"+loeKey).hasClass("projectSettleRule_date")){
                            		$("#rule_"+loeKey).datetimebox('setValue',value);
                            	}else{
                            		$("#rule_"+loeKey).val(value);
                            	}
                            	
                            } 
                        }
                    });

                }
            },{async:false,type:"post"});
            //获取已经上传的附件
             var findParams ={
                    "index":"findPorjectRuleAttach",
                    "ruleId":uid,
                    "nopage":1,
                    "projectId":projectId
                };
            apolloAjax(findParams,function(retData){
                if(retData){
                var htmlFile="";
                	 $.each(retData,function (key,value){
                		 htmlFile +='<p id="'+value.ID+'">'+value. FILE_NAME+'&nbsp;&nbsp;<input type="button" value="删除" onclick="delPorjectRuleAttach(\''+value.ID+'\')"/></p>';
                	 });
                	 $("td>p").remove(); 
                	 $("#uploadFile").before(htmlFile);
                }
            },{async:false,type:"post"});
        },

        updateProjSetttleRule:function(uid,projectId){
        	$("#upload_attatchment_div").html("<input id=uploadFile name=file type=file><a href='javascript:void(0)' onclick='cleanFile()'>清除</a>");
            ProjectRuleControl.initProjectRuleInfo(uid,projectId);
            $('#projectSettleRuleForm').dialog({
                title: '对话框',
                iconCls:"icon-edit",
                collapsible: true,
                maximizable: true,
                resizable: true,
                width: 600,
                height: 300,
                modal: true,
                buttons: [{
                    text: '提交',
                    iconCls: 'icon-ok',
                    handler: function () {
                    	checkSettlement(uid,'modify');
                  /*       var projectShopFormParams = {};

                        $.each($(".projectSettleRule_text"),function (key,value){
                            projectShopFormParams[$(this).attr("id")] = $(this).val();
                        });

                        $.each($(".projectSettleRule_combo"),function (key,value){
                            projectShopFormParams[$(this).attr("id")] = $(this).combobox("getValue");
                        });

                        $.each($(".projectSettleRule_date"),function (key,value){
                            projectShopFormParams[$(this).attr("id")] = $(this).datetimebox('getValue');
                        });
                        projectShopFormParams.rule_status=1;
                        projectShopFormParams.rule_currency_type = 1;
                        projectShopFormParams.rule_project_id = ProjectDetailTabs.proj_id;
                        projectShopFormParams.rule_project_name = ProjectDetailTabs.proj_name;
                        projectShopFormParams.url="/project/rule/addProjectRule.action";
                        apolloAjax(projectShopFormParams,function(retData){
                            if(retData && retData.resultId == 1){
                                $('#projectSettleRuleForm').dialog('close');
                                $("#project_rule_grid").datagrid("reload");
                            }
                        },{async:false,type:"post"});
                        var projectShopFormParams = {};
                        projectShopFormParams.index="insertProjSettleRule";
                        projectShopFormParams.rule_status=1;
                        projectShopFormParams.rule_currency_type = 1;
                        projectShopFormParams.rule_project_id = ProjectDetailTabs.proj_id;
                        projectShopFormParams.rule_project_name = ProjectDetailTabs.proj_name;
                        projectShopFormParams.url="/project/rule/addProjectRule.action";
                        apolloAjax(projectShopFormParams,function(retData){
                            if(retData && retData.resultId == 1){
                                $('#projectSettleRuleForm').dialog('close');
                                $("#project_rule_grid").datagrid("reload");
                            }
                        },{async:false,type:"post"}); */

                    }
                }, {
                    text: '取消',
                    iconCls: 'icon-cancel',
                    handler: function () {
                        $('#projectSettleRuleForm').dialog('close');
                    }
                }]
            }).dialog('open');
        },
        deleteProjSetttleRule:function(uid,projectId){
            $.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
                if (data) {
                    var params ={
                        "url":"/project/rule/updateProjectRuleStatus.action",
                        "uid":uid,
                        "projectId":projectId
                    };
                    apolloAjax(params,function(retData){
                        if(retData && retData.resultId == 1){
                            $("#project_rule_grid").datagrid("reload");
                        }
                    },{async:false,type:"post"});
                }
            });
        },
        downLoadProjSetttleRule:function(uid,projectId){
        	  $.messager.confirm("操作提示", "您确定要下载文件吗？", function (data) {
                  if (data) {
                	  var params ={
                              "url":"/project/rule/projectRuleFilesExist.action",
                              "ruleId":uid,
                              "projectId":projectId
                          };
                          apolloAjax(params,function(retData){
                        	  //存在下载的文件就去下载
                              if(retData && retData.resultId == 1){
                            	  window.location.href="/project/rule/projectRuleFilesDownload.action?ruleId="+uid+"&projectId="+projectId;
                              }else{
                            	  $.messager.alert('系统提示', retData.resultDescription);
                              }
                          },{async:false,type:"post"});
                  }
              });
        }
    }

    function projUserFormatter(value,row,index){
        var retStr ="";
        if(row.USER_STATUS == 1){
            retStr += "<a href='#' onclick='ProjectUserControl.delProjUser("+row.ID+",\""+row.USER_ID+"\","+row.PROJECT_ID+")'>删除</a>";
        }
        return retStr;
    }

    var ProjectUserControl = {
        delProjUser:function(uid,userId,projectId){

            $.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
                if (data) {
                    var params ={
                        "url":"/project/user/updateProjectUserStatus.action",
                        "uid":uid,
                        "userId":userId,
                        "projectId":projectId
                    };
                    apolloAjax(params,function(retData){
                        if(retData && retData.resultId == 1){
                            $("#project_user_grid").datagrid("reload");
                        }
                    },{async:false,type:"post"});
                }
            });

        }
    };

    var ProjectShopControl ={
        shopFormInit:function(){
            $("#PROJECT_NAME_FORM").val(ProjectDetailTabs.proj_name).attr("disabled",true) ;
        },
        delProjShop:function(shopId,projectId){
            var params ={
                "url":"/project/shop/updateProjectShop.action",
                "shopId":shopId,
                "projectId":projectId
            };
            apolloAjax(params,function(retData){
                if(retData && retData.resultId == 1){
                    $("#project_shop_grid").datagrid("reload");
                }
            },{async:false,type:"post"});
        },
        modifyProjShop:function(rowIndex,rowId,projectId){
            var all_row = $("#project_shop_grid").datagrid("getData");
            var selectRow = all_row.rows[rowIndex];
            $("#SHOP_NAME_FORM").val(selectRow.SHOP_NAME);
            $("#ERP_SHOP_NAME_FORM").combobox('setText',selectRow.ERP_SHOP_CODE).combobox('setValue',selectRow.ERP_SHOP_NAME);
            $("#PLAT_NAME_FORM").combobox('setText',selectRow.PLAT_NAME).combobox('setValue',selectRow.PLAT_ID);
            $("#projectShopFormShopId").val(selectRow.ID);
            if("1" == ProjectDetailTabs.is_relate_erp){
            	if($("#ERP_SHOP_NAME_FORM").combobox("getValue") != ""){
            		 $("#ERP_SHOP_NAME_FORM").combobox('disable');
            	}else{
            		$("#ERP_SHOP_NAME_FORM").combobox('enable');
            		if(null != ProjectDetailTabs.erp_proj_code && "" != ProjectDetailTabs.erp_proj_code){
                        var params = new Object();
                        params.index = "findRXProjShop";
                        params.nopage = 1;
                        params.ruixueCustGuid = ProjectDetailTabs.erp_proj_code;
                        apolloAjax(params,function(data){
                            if(data){
                                RXProjectShopSelect = data;
                                $("#ERP_SHOP_NAME_FORM").combobox({editable:false,panelHeight: 'auto',width:155}).combobox('loadData',jsonToArrayForSelected(RXProjectShopSelect));
                            }
                        },{async:false});
                    	}
            	}
            }else{
            	$("#ERP_SHOP_NAME_FORM").combobox('disable');
            }
           
            
            $('#projectShopForm').dialog({
                title: '修改店铺',
                iconCls:"icon-edit",
                collapsible: true,
                maximizable: true,
                resizable: true,
                width: 600,
                height: 300,
                modal: true,
                buttons: [{
                    text: '提交',
                    iconCls: 'icon-ok',
                    handler: function () {
                        var projectShopFormParams = {
                            "index":"updateProjectShop",
                            "url":"/project/shop/updateProjectShop.action",
                            "shopId":$("#projectShopFormShopId").val(),
                            "projectId":ProjectDetailTabs.proj_id,
                            "projectName":ProjectDetailTabs.proj_name,
                            "shopName":$("#SHOP_NAME_FORM").val(),
                            "erpShopName":$("#ERP_SHOP_NAME_FORM").combobox("getText"),
                            "erpShopCode":$("#ERP_SHOP_NAME_FORM").combobox("getValue"),
                            "platName":$("#PLAT_NAME_FORM").combobox("getText"),
                            "platId":$("#PLAT_NAME_FORM").combobox("getValue"),
                            "shopStatus":1
                        };
                        apolloAjax(projectShopFormParams,function(retData){
                            if(retData && retData.resultId == 1){
                                $('#projectShopForm').dialog('close');
                                $("#project_shop_grid").datagrid("reload");
                            }
                        },{async:false,type:"post"});
                    }
                }, {
                    text: '取消',
                    iconCls: 'icon-cancel',
                    handler: function () {
                        $('#projectShopForm').dialog('close');
                    }
                }]
            }).dialog('open');
        },
        platSelectInit:function(){
            /*
             初始化平台信息
             */
            if(!platSelect){
                var params = new Object();
                params.index = "findPlat";
                params.nopage = 1;
                apolloAjax(params,function(data){
                    if(data){
                        platSelect = data;
                        $("#PLAT_NAME_FORM").combobox({editable:false,panelHeight: '255',width:155}).combobox('loadData',jsonToArrayForSelected(platSelect));
                    }
                },{async:false});
            }
        }
    }


    function projShopFormatter(value,row,index){
        var retStr = "";
        retStr += "<a href='#' onclick='ProjectShopControl.modifyProjShop("+index+","+row.ID+","+row.PROJECT_ID+")'>修改</a>";
        //retStr += "&nbsp;&nbsp;&nbsp;<a href='#' onclick='ProjectShopControl.delProjShop("+row.ID+","+row.PROJECT_ID+")'>删除</a>";
        return retStr;
    }
    
    //账期修改
    var updateSettlePeriodControl = {
    		//根据账期ID查询账期信息
    		findProjectSettlePeriod:function(id){
    			var selectYear = "";
    			var selectPeriod = "";
    			var selectBeginDt = "";
    			var selectendDt = "";
    			 var params ={
    		                "index":"findProjectSettlePeriod",
    		                "id":id,
    		                "nopage":1
    		            };
    		            apolloAjax(params,function(retData){
    		                if(retData && retData[0]){
    		                	var settlePeriodInfo = retData[0];
    		                	selectYear = settlePeriodInfo.SETTLE_YEAR;
    		                	selectPeriod = settlePeriodInfo.SETTLE_PERIOD;
    		                	selectBeginDt = settlePeriodInfo.SETTLE_BEGIN_DT;
    		                	selectendDt = settlePeriodInfo.SETTLE_END_DT;
    		                }
    		            },{async:false,type:"post"}); //改成同步否则页面中看不到加载的数据
    		 	//修改账期初始化页面数据
            	var date = new Date();
                var settleYears =[{ TEXT:date.getFullYear()-2,  VALUE:date.getFullYear()-2},{ TEXT:date.getFullYear()-1,  VALUE:date.getFullYear()-1},{ TEXT:date.getFullYear(),  VALUE:date.getFullYear()},{ TEXT:date.getFullYear()+1,  VALUE:date.getFullYear()+1},{ TEXT:date.getFullYear()+2,  VALUE:date.getFullYear()+2}];
            	$("#settleYear").combobox({editable:false,panelHeight: '95',width:80}).combobox('loadData',jsonToArrayForSelected(settleYears));
            	$("#settleYear").combobox({editable:false,panelHeight: '95',width:80}).combobox('select',selectYear);
            	$("#settlePeriod").combobox({editable:false,panelHeight: '95',width:98}).combobox('loadData',jsonToArrayForSelected(projectSettlePeriodSelect));
            	var periodName = "";
             	$.each(jsonToArrayForSelected(projectSettlePeriodSelect),function(key,value){
            		if(selectPeriod == value.value){
            			periodName = value.text
            			return false;
            		}
            	});
             	$("#settlePeriod").combobox('setText',periodName).combobox('setValue',selectPeriod);
             	$("#settleBeginDt").datebox("setValue", selectBeginDt);
             	$("#settleEndDt").datebox("setValue",selectendDt);
             	
    		},
    		
    		//修改账期
    		updateSettlePeriod:function(id){
    			updateSettlePeriodControl.findProjectSettlePeriod(id);
				//绑定新增对话框
            	$('#projectSettlePeriodForm').dialog({
                    title: '修改账期',
                    iconCls:"icon-edit",
                    width:410,
                    collapsible: false,
                    maximizable: false,
                    resizable: true,
                    modal: true,
                    buttons: [{
                        text: '保存',
                        iconCls: 'icon-ok',
                        handler: function () {
                        	saveModifySettlePeriod(id,'modify');
                        }
                    }, {
                        text: '取消',
                        iconCls: 'icon-cancel',
                        handler: function () {
                            $('#projectSettlePeriodForm').dialog('close');
                        }
                    }]
                }).dialog('open');
    			
    		}
    }


    /*

    * tabs 切换
    *
    * */
    $("#project_detail_tabs").tabs({
        border:false,
        onSelect:function(title){
            if("店铺列表" == title){
                if(ProjectDetailTabs.proj_id){
                    ProjectDetailTabs.projectShopInt();
                }
            }
            if("人员列表" == title){
                ProjectDetailTabs.projectUserInit();
            }
            if("结算规则" == title){
                ProjectDetailTabs.projectRuleInit();
            }
            if("账期管理" == title){
            	ProjectDetailTabs.projectSettlePeriodInit();
            }
        }
    });


	//页面初始化加载信息
    $(function(){
        if(!areaSelect)initAjaxCenter("fm_project_manage","area");
        if(!signCompanySelect)initAjaxCenter("fm_project_manage","sign_company");
        if(!projectTypeSelect)initAjaxCenter("fm_project_manage","project_type");
        if(!projectOperateSelect)initAjaxCenter("fm_project_manage","operate_genre");
        if(!projectSettleRuleSelect)initAjaxCenter("fm_project_settle_rule","service_fee_period");
        if(!projectRuleCurrencyType)initAjaxCenter("fm_project_settle_rule","currency_type");
        if(!projectSettlePeriodSelect)initAjaxCenter("fm_project_settle_period","settle_period");
        initRXProjectInfo();
        initFormSelect();
        $('#projectGrid').easyGrid({
            isDownResult:true,
            pagination : true,
            isSearchOpen:true,
            method:"post",
            height:"50%",
            singleSelect:true,
            downloadUrl:'project/exportProjectExcel.action',
            onRowContextMenu:[],
            onLoadSuccess:function(){
                var all_row = $("#projectGrid").datagrid("getData");
                var selectRow = all_row.rows[0];
                $("#project_detail_tabs").slideDown();
                ProjectDetailTabs.proj_id = selectRow.ID;
                ProjectDetailTabs.proj_name = selectRow.PROJECT_NAME;
                ProjectDetailTabs.is_relate_erp = selectRow.IS_RELATE_ERP;
                ProjectDetailTabs.erp_proj_code = selectRow.ERP_PROJ_CODE;
                var title = $('.tabs-selected').text();
                if(!title){
                    ProjectDetailTabs.projectShopInt();
                }
                if("店铺列表" == title){
                    ProjectDetailTabs.projectShopInt();
                }
                if("人员列表" == title){
                    ProjectDetailTabs.projectUserInit();
                }
                if("结算规则" == title){

                }
                var current_tab = $('#project_detail_tabs').tabs('getSelected');
                $('#project_detail_tabs').tabs('update',{
                    tab:current_tab,
                    options : {
                        content : ProjectDetailTabs.projectShopInt(),
                    }
                });

                ProjectShopControl.platSelectInit();
                ProjectShopControl.shopFormInit();
            },
            data:{index:'findProject'},
            columns:[[
                 {field:'PROJECT_CODE',title:'项目编号',sortable:false,width:200}
                ,{field:'PROJECT_NAME',title:'项目名称',sortable:false,width:200}
                ,{field:'PROJECT_TYPE',title:'项目类型',sortable:false,width:200,formatter:function(value, row,index){
                    return formatterByData(value,projectTypeSelect);
                }}
                ,{field:'OPERATE_GENRE',title:'经营类目',sortable:false,width:200,formatter:function(value, row,index){
                    return formatterByData(value,projectOperateSelect);
                }}
                ,{field:'PROJECT_STATUS',title:'项目状态',sortable:false,width:200,formatter:function(value, row,index){
                    return formatterByData(value,projectStatusSelect);
                }}
                ,{field:'SIGN_COMPANY',title:'签约公司',sortable:false,width:400,formatter:function(value, row,index){
                    return formatterByData(value,signCompanySelect);
                }}
                ,{field:'AREA',title:'所属地区',sortable:false,width:200,formatter:function(value, row,index){
                    return formatterByData(value,areaSelect);
                }}
                ,{field:'ERP_PROJ_CODE',title:'ERP项目编码',sortable:false,width:200,hidden:true}
                /* ,{field:'1',title:'操作',sortable:true,width:120,formatter:function(value, row,index){
                 return OptFormatter(row);
                 }}*/
            ]] ,
            buttons:[{
                noSelected:true,
                text:'新增',
                pri_id:'100',
                handler:function(data){
                	$('#projectForm').easyForm('openData',{index:'insertProject'});
                	initFormSelect();
                   /*  var params = new Object();
                    params.url = "/project/getMysqlProjectSeq.action";
                    params.nopage = 1;
                    apolloAjax(params,function(data){
                        if(data){
                            $('#projectForm').easyForm('openData',{index:'insertProject',PROJECT_CODE:"xm-"+data.seqProject});
                            $('#PROJECT_CODE').attr("disabled","disabled");
                            initFormSelect();
                        }
                    },{async:false});*/

                } 
            },{
                noSelected:false,
                text:'修改',
                pri_id:'101',
                handler:function(params){
                    if(params.PROJECT_STATUS == 3){
                        alert("该项目不可修改！");
                        return false;
                    }
                    params.INDEX = 'updateProject';
                    params.projectId = params.ID;
                    $('#projectForm').easyForm('openData',params);
                    if(!areaSelect)initAjaxCenter("fm_project_manage","area");
                    if(!signCompanySelect)initAjaxCenter("fm_project_manage","sign_company");
                    if(!projectTypeSelect)initAjaxCenter("fm_project_manage","project_type");
                    if(!projectOperateSelect)initAjaxCenter("fm_project_manage","operate_genre");
                    $("#ERP_PROJ_NAME").combobox("disable");
                	$('#PROJECT_CODE').attr("disabled","disabled");
                    if(params.IS_RELATE_ERP == 1){
                        //如果关联了erp 修改的时候不让改变
                        $("#IS_RELATE_ERP").attr("disabled",true);
                    }
                }
            }],
            search:{
                'projectName':{title:'项目名称',equals:true},
                'projectStatus':{title:'项目状态',equals:true,type:'select',option:projectStatusSelect},
                'signCompany':{title:'签约公司',equals:true,type:'select',option:signCompanySelect},
                'projectType':{title:'项目类型',equals:true,type:'select',option:projectTypeSelect},
                'area':{title:'所属地区',equals:true,type:'select',option:areaSelect},
                'operateGenre':{title:'经营类目',equals:true,type:'select',option:projectOperateSelect}
            },
            onClickRow:function(index, row){
                $("#project_detail_tabs").slideDown();
                ProjectDetailTabs.proj_id = row.ID;
                ProjectDetailTabs.proj_name = row.PROJECT_NAME;
                ProjectDetailTabs.is_relate_erp = row.IS_RELATE_ERP;
                ProjectDetailTabs.erp_proj_code = row.ERP_PROJ_CODE;
                var title = $('.tabs-selected').text();
                if(!title){
                    ProjectDetailTabs.projectShopInt();
                }
                if("店铺列表" == title){
                    ProjectDetailTabs.projectShopInt();
                }
                if("人员列表" == title){
                    ProjectDetailTabs.projectUserInit();
                }
                if("结算规则" == title){
                    ProjectDetailTabs.projectRuleInit();
                }
                if("账期管理" == title){
                	ProjectDetailTabs.projectSettlePeriodInit();
                }

                var current_tab = $('#project_detail_tabs').tabs('getSelected');
                $('#project_detail_tabs').tabs('update',{
                    tab:current_tab,
                    options : {
                        content : ProjectDetailTabs.projectShopInt(),
                    }
                });

                ProjectShopControl.platSelectInit();
                ProjectShopControl.shopFormInit();

            }
        });

        $('#projectForm').easyForm({
            title:'新增',
            width:600,
            height:330,
            submit:function(params){
                if(!ValidateControl.projectFormCheck()){
                    return false;
                };
                params.ERP_PROJ_NAME = $("#ERP_PROJ_NAME").combobox("getText") != '请选择' ? $("#ERP_PROJ_NAME").combobox("getText") :'';
                params.ERP_PROJ_CODE = $("#ERP_PROJ_NAME").combobox("getValue");
                params.PROJECT_STATUS = $("#PROJECT_STATUS").combobox("getValue");
                if($("#IS_RELATE_ERP").attr("checked")==true){
                    params.IS_RELATE_ERP=1;
                }else{
                    params.IS_RELATE_ERP=0;
                }
                if("insertProject" == params.index){
                    params.url="/project/insertProject.action"
                }
                if("updateProject" == params.index){
                    params.url="/project/modifyProject.action"
                }
				//提交项目
                apolloAjax(params,function(data){
                    if("1" == data.resultId){
                    	$.messager.alert("操作提示", data.resultDescription);
                        window.location.reload();
                    }else{
                    	$.messager.alert("操作提示", data.resultDescription,"error");
                    }
                },{async:false,type:"post"});
            }
        });

    });


    /**
     * 业务验证
     * @type {{projectShopFormCheck: ValidateControl.projectShopFormCheck, projectFormCheck: ValidateControl.projectFormCheck}}
     */
    var ValidateControl = {
        projectShopFormCheck:function(){
            var SHOP_NAME_FORM_value = $("#SHOP_NAME_FORM").val();
            var ERP_SHOP_NAME_FORM_value = $("#ERP_SHOP_NAME_FORM").combobox("getValue");
            var PLAT_NAME_FORM_value = $("#PLAT_NAME_FORM").combobox("getValue");
            if(!SHOP_NAME_FORM_value){
                $.messager.alert("操作提示", "请填写店铺名称！","error");
                return false;
            }
            if(!ERP_SHOP_NAME_FORM_value && "1" == ProjectDetailTabs.is_relate_erp){
                $.messager.alert("操作提示", "请选择关联ERP店铺！","error");
                return false;
            }
            if(!PLAT_NAME_FORM_value){
                $.messager.alert("操作提示", "请选择平台！","error");
                return false;
            }
            return true;
        },
		
        //新增项目验证
        projectFormCheck:function(){
            var PROJECT_TYPE_value = $("#PROJECT_TYPE").combobox("getValue");
            var SIGN_COMPANY_value = $("#SIGN_COMPANY").combobox("getValue");
            var PROJECT_NAME_value = $("#PROJECT_NAME").val();
            var OPERATE_GENRE_value = $("#OPERATE_GENRE").combobox("getValue");
            var PROJECT_STATUS_value = $("#PROJECT_STATUS").combobox("getValue");
            var PROJECT_AREA_value = $("#AREA").combobox("getValue");
            if(!PROJECT_NAME_value){
                $.messager.alert("操作提示", "请填写项目名称！","error");
                return false;
            }
            if(!PROJECT_TYPE_value){
                $.messager.alert("操作提示", "请选择项目类型！","error");
                return false;
            }
            if(!SIGN_COMPANY_value){
                $.messager.alert("操作提示", "请选择签约公司！","error");
                return false;
            }
            if(!PROJECT_STATUS_value){
            	$.messager.alert("操作提示", "请选择项目状态！","error");
                return false;
            }
            if(!PROJECT_AREA_value){
            	$.messager.alert("操作提示", "请选择所属地区！","error");
                return false;
            }
            if($("#IS_RELATE_ERP").attr("checked")==true){
                var ERP_PROJ_NAME_value = $("#ERP_PROJ_NAME").combobox("getValue");
                if(!ERP_PROJ_NAME_value){
                    $.messager.alert("操作提示", "请选择ERP项目名称！","error");
                    return false;
                }
            }
            if(!OPERATE_GENRE_value){
            	 $.messager.alert("操作提示", "请选择经营类目","error");
                 return false;
            }
            return true;
        }
    };


    function initRXProjectInfo(){
        var params = new Object();
        params.index = "findRXProject";
        params.nopage = 1;
        apolloAjax(params,function(data){
            if(data){
                RXProjectInfoSelect = data;
            }
        },{async:false});
    }

    function initFormSelect(){
        $("#PROJECT_TYPE").combobox({editable:false,panelHeight: 'auto',width:155}).combobox('loadData',jsonToArrayForSelected(projectTypeSelect));
        $("#SIGN_COMPANY").combobox({editable:false,panelHeight: 'auto',width:155}).combobox('loadData',jsonToArrayForSelected(signCompanySelect));
        $("#PROJECT_STATUS").combobox({editable:false,panelHeight: 'auto',width:155}).combobox('loadData',jsonToArrayForSelected(projectStatusSelect));
        $("#AREA").combobox({editable:false,panelHeight: 'auto',width:155}).combobox('loadData',jsonToArrayForSelected(areaSelect));
        $("#ERP_PROJ_NAME").combobox({editable:false,panelHeight: '255',width:155}).combobox('loadData',jsonToArrayForSelected(RXProjectInfoSelect));
        $("#OPERATE_GENRE").combobox({editable:false,panelHeight:'auto',width:155}).combobox('loadData',jsonToArrayForSelected(projectOperateSelect));
    }

    //初始化查询条件下拉列表回填数据
    function initAjaxCenter(tableName,columnName){
        var params = new Object();
        params.index = "findDicByKey";
        params.nopage = 1;
        params.tableName=tableName;
        params.columnName=columnName;

        apolloAjax(params,function(data){
            if(data){
                if(columnName == "area"){
                    areaSelect = data;
                }
                if(columnName == "sign_company"){
                    signCompanySelect = data;
                }

                if(columnName == "project_type"){
                    projectTypeSelect = data;
                }
                if(columnName == "operate_genre"){
                	projectOperateSelect = data;
                }
                if(columnName == "service_fee_period"){
           		 	projectSettleRuleSelect = data;
                }
           	 	if(columnName == "currency_type"){
           			projectRuleCurrencyType = data;
           	 	}
           	 	if(columnName == "settle_period"){
           	 		projectSettlePeriodSelect = data;
           	 	}
            }
        },{async:false});
    }
    
   /*  //查询下拉列表
    function findAjaxFeePeriod(columnName){
    	 var params = new Object();
        params.index = "findDicByKey";
        params.nopage = 1;
        params.tableName = "fm_project_settle_rule";
        params.columnName = columnName;
        apolloAjax(params,function(data){
            if(data){
            	 if(columnName == "service_fee_period"){
            		 projectSettleRuleSelect = data;
                 }
            	 if(columnName == "currency_type"){
            		 projectRuleCurrencyType = data;
            	 }
            }
        },{async:false});
    }
     */


    function checkRelate(){
        if($("#IS_RELATE_ERP").attr("checked")==true){
            $("#ERP_PROJ_NAME").combobox({editable:true,panelHeight: '255',width:155}).combobox('loadData',jsonToArrayForSelected(RXProjectInfoSelect)).combobox("enable");
        }else{
            $("#ERP_PROJ_NAME").combobox("disable").combobox('setValue','');
        }
    }
    
    //结算规则保存&修改
    function checkSettlement(ruleId,action){
    	   $("#fm").form("submit",{
               url: action == 'add' ? "/project/rule/addProjectRule.action" : "/project/rule/updateProjectRule.action",
               onSubmit: function (param) {
            	   var ruleContactType = $("#rule_contact_type").combobox("getValue");
            	   var singCompany = $("#rule_sign_company").combobox("getValue");
            	   var ruleWmsCharge = $("#rule_wms_charge").combobox("getValue");
            	   var ruleWmsFeeCharge = $("#rule_wms_fee_charge").combobox("getValue");
            	   var ruleTmsCharge = $("#rule_tms_charge").combobox("getValue");
            	   var ruleTmsFeeCharge = $("#rule_tms_fee_charge").combobox("getValue");
            	   var ruleCustormCharge = $("#rule_custorm_charge").combobox("getValue");
            	   var ruleRefundCharge = $("#rule_refund_charge").combobox("getValue");
            	   var ruleContractBeginDt = $("#rule_contract_begin_dt").datetimebox('getValue');
            	   var ruleContractEndDt = $("#rule_contract_end_dt").datetimebox('getValue');
            	   var ruleServiceFeePeriod = $("#rule_service_fee_period").combobox("getValue");
            	   var ruleCommissionFeePeriod = $("#rule_commission_fee_period").combobox("getValue");
            	   var ruleCurrencyType = $("#rule_currency_type").combobox("getValue");
            	   var ruleSpareCurrency = $("#rule_spare_currency").val();
            	   param.rule_project_id = ProjectDetailTabs.proj_id;
            	   param.rule_project_name = ProjectDetailTabs.proj_name;
            	   param.rule_status = 1;
            	   param.rule_id = ruleId;
            	   if(ruleSpareCurrency != ""){
            	   	param.rule_spare_currency = ruleSpareCurrency;
            	   }
            	   if(singCompany == ""){
            		   $.messager.alert("操作提示", "请选择签约公司！","error");
            		   return false;
            	   }else if(ruleContactType == ""){
            		   $.messager.alert("操作提示", "请选择品牌合作方！","error");
            		   return false;
            	   }else if(ruleWmsCharge == ""){
            		   $.messager.alert("操作提示", "请选择仓库负责方！","error");
            		   return false;
            	   }else if(ruleWmsFeeCharge == ""){
            		   $.messager.alert("操作提示", "请选择仓储费承担方！","error");
            		   return false;
            	   }else if(ruleTmsCharge == ""){
            		   $.messager.alert("操作提示", "请选择快递负责方！","error");
            		   return false;
            	   }else if(ruleTmsFeeCharge == ""){
            		   $.messager.alert("操作提示", "请选择快递费承担方！","error");
            		   return false;
            	   }else if(ruleCustormCharge == ""){
            		   $.messager.alert("操作提示", "请选择客服负责方！","error");
            		   return false;
            	   }else if(ruleRefundCharge == ""){
            		   $.messager.alert("操作提示", "请选择退款操作方！","error");
            		   return false;
            	   }else if(ruleContractBeginDt == ""){
            		   $.messager.alert("操作提示", "请选择合同开始日期！","error");
            		   return false;
            	   }else if(ruleContractEndDt == ""){
            		   $.messager.alert("操作提示", "请选择合同截止日期！","error");
            		   return false;
            	   }else if(ruleServiceFeePeriod == ""){
            		   $.messager.alert("操作提示", "请选择基础服务费计费周期！","error");
            		   return false;
            	   }else if(ruleCommissionFeePeriod == ""){
            		   $.messager.alert("操作提示", "请选择佣金计费周期！","error");
            		   return false;
            	   }else if(ruleCurrencyType == ""){
            		   $.messager.alert("操作提示", "请选择币种！","error");
            		   return false;
            	   }
               	var isValid = $(this).form('validate');
               		if(isValid){
               			if(!isDecimal('rule_service_fee')){
               			 	$.messager.alert("操作提示", "基础服务费请输入金额！","error");
              		  	 	isValid = false;
               			}else if($("#checkCurrency").is(":checked")) { //如果勾选了就需要验证备用金
               				if(!isDecimal('rule_spare_currency')){
               				$.messager.alert("操作提示", "备用金请输入金额！","error");
              		  	 	isValid = false;
               			}
               		  }
               		}
					return isValid; // 返回false将阻止表单提交
               },
               success: function (data) {
                   $.messager.progress('close');
                   var result = eval('(' + data + ')');
                   if (result.resultId != "1") {
                       $.messager.alert('系统提示', "<font color=red>"
                               + result.errorMsg + "</font>");
                       return;
                   } else {
                       $.messager.alert('系统提示', result.resultDescription);
                       $("#fm").form('clear');
                       $("td>p").remove(); //清除p标签
                       $("#project_rule_grid").datagrid("reload");
                       $('#projectSettleRuleForm').dialog('close');
                   }
               }
           });
    }

    
    
	//验证结算规则符合 Decimal 类型
	function isDecimal(item) {
		var decimalVal = $("#" + item).val();
		if (decimalVal != "") {
			if (decimalVal != "") {
				var pattern = '^-?[1-9]\\d*$|^-?0\\.\\d*$|^-?[1-9]\\d*\\.\\d*$';
				var reg = new RegExp(pattern, 'g');
				if (reg.test(decimalVal)) {
					return true;
				} else {
					if (decimalVal.match(/[^0-9\.-]/g) != null) {
						if (decimalVal.match(/[^0-9\.-]/g).length > 0) {
							decimalVal = decimalVal.replace(/[^0-9\.-]/g, '');
							$(item).val(decimalVal);
						}
					}
				}
			}
		}
		return false;
	}

//备用金是否勾选
function selectCurrency(){	
	var currencyCheckBox = $("#checkCurrency").is(":checked");
	if(currencyCheckBox){
		$("#rule_spare_currency").attr("disabled",false);
	}else{
		$("#rule_spare_currency").attr("disabled",true);
	}
}

//禁用结算规则文件关系表状态
function delPorjectRuleAttach(porjectRuleAttachId){
	 $.messager.confirm("操作提示", "您确定要删除文件吗？", function (data) {
         if (data) {
             var params ={
                 "url":"/project/rule/updateProjectRuleAttach.action",
                 "id":porjectRuleAttachId
             };
             apolloAjax(params,function(retData){
                 if(retData && retData.resultId == 1){
                     $("#"+porjectRuleAttachId).empty();
                 }
             },{async:false,type:"post"});
         }
     });
	
}

//账期保存&修改
function saveModifySettlePeriod(periodId,action){
	 $("#addModifySettlePeriodForm").form("submit",{
         url: action == 'add' ? "/project/settlePeriod/addProjectSettlePeriod.action" : "/project/settlePeriod/modifyProjectSettlePeriod.action",
         onSubmit: function (param) {
        	var settleYear = $("#settleYear").combobox("getValue");
        	var settlePeriod = $("#settlePeriod").combobox("getValue");
        	var settlePeriodName = $("#settlePeriod").combobox("getText");
        	var settleBeginDt = $("#settleBeginDt").datetimebox('getValue');
        	var settleEndDt = $("#settleEndDt").datetimebox('getValue');
        	param.projectId = ProjectDetailTabs.proj_id;
        	param.id = periodId;
      	  	param.status = 0;
      	  	param.settleYearPeriod = settlePeriodName;
      	  	if(settleYear == ""){
      	  		$.messager.alert("操作提示", "结算账期不能为空！","error");
      	  		return false;
      	  	}else if(settlePeriod == ""){
      	  		$.messager.alert("操作提示", "结算账期不能为空！","error");
      	  		return false;
      	  	}else if(settleBeginDt == ""){
      	  		$.messager.alert("操作提示", "起始时间不能为空！","error");
      	  		return false;
      	  	}else if(settleEndDt == ""){
      	  		$.messager.alert("操作提示", "结束时间不能为空！","error");
      	  		return false;
      	  	}else{
      	  		if(settleBeginDt >= settleEndDt){
      	  			$.messager.alert("操作提示", "起始时间不能大于或等于结束时间！","error");
      	  			return false;
      	  		}
      	  	}
      	  	
         },
         success: function (data) {
             $.messager.progress('close');
             var result = eval('(' + data + ')');
             if (result.resultId != "1") {
                 $.messager.alert('系统提示', "<font color=red>"
                         + result.errorMsg + "</font>");
                 return;
             } else {
                 $.messager.alert('系统提示', result.resultDescription);
                 $("#addModifySettlePeriodForm").form('clear');
                 $("#project_settle_grid").datagrid("reload");
                 $('#projectSettlePeriodForm').dialog('close'); 
             }
         }
		});
}

//清除第一个默认的附件
function cleanFile(){
	$("#upload_attatchment_div").html("<input id=uploadFile name=file type=file><a href='javascript:void(0)' onclick='cleanFile()'>清除</a>");
}
</SCRIPT>

</body>
</html>
