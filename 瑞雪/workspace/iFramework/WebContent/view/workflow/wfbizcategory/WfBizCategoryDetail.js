jQuery(function($) {
	jQuery(document).ready(function() {
		if (opFlag == 1 || opFlag == "1") {
			showDetail(bizCateId);
		}

		//页面控件输入有效性验证
		jQuery("#detailForm").validate({
			errorClass : "error2",
			errorElement : "div",
			highlight : function(element, errorClass) {
							jQuery(element).addClass(errorClass);
							jQuery("#error_" + element.id).show();
			},
			unhighlight : function(element, errorClass) {
				jQuery(element).removeClass(errorClass);
				jQuery("#img_" + element.id).remove();
				jQuery("#error_" + element.id).remove();
			},
			showErrors : function(error, element) {
				var _this = this;
				showErrorsWithPosition(error, element, _this, webpath);
			},
			rules: {
			/*txtBizCateParentId: {
				byteRangeLength: [0,64],
				specialCharCheck:true
			} ,*/
			txtBizCateName: {
				required: true,
				byteRangeLength: [0,64],
				specialCharCheck:true
			} ,
			txtBizCateDesc: {
				byteRangeLength: [0,128],
				specialCharCheck:true
			} 
			},
			messages: {
				txtBizCateParentId: "父分类id校验错误" ,
				txtBizCateName: "分类名称校验错误" ,
				txtBizCateDesc: "分类描述校验错误" 
			}
		});

		});
	});
//验证-1,0,正整数
jQuery.validator.addMethod("integerValidate",
	function(value, element) {
	var regx = /^[0-9]\d*$/; 
	return (regx.test(value) || value=="-1");
});
//显示业务分类的详细信息
function showDetail(bizCateId) {
	jQuery("#hidBizCateId").val(bizCateId);
	//根据bizCateId取wF_BIZ_CATEGORY的明细
	var sURL1 = webpath + "/WfBizCategoryAction.do?method=getWfBizCategoryDetail";
	jQuery.ajax( {
		url : sURL1,
		type : "post",
		dataType : "json",
		data : {
			bizCateId : bizCateId
		},
		success : function(data) {
			if(data.errorMessage == undefined){
				//使用返回的wfBizCategory明细画页面
				jQuery("#txtBizCateId").val(data.wfbizcategoryDetail.bizCateId);
				jQuery("#txtBizCateParentName").val(data.wfbizcategoryDetail.bizCateParentName);
				jQuery("#txtBizCateParentId").val(data.wfbizcategoryDetail.bizCateParentId);
				jQuery("#txtBizCateName").val(data.wfbizcategoryDetail.bizCateName);
				jQuery("#txtBizCateDesc").val(data.wfbizcategoryDetail.bizCateDesc);
			} else {
				if (data.errorMessage == "session timeout")
					window.location.href = webpath + "/login.jsp";
				else
					alert(data.errorMessage);
			}
		},
		error : function(XMLHttpRequest,textStatus,errorThrown){
			alert("网络错误");
			// 通常 textStatus 和 errorThrown 之中 
			// 只有一个会包含信息 
			//this;  调用本次AJAX请求时传递的options参数
		}
	});
}

//输入有效性校验
function checkValidate(){
	if(!jQuery("#detailForm").valid())return false;
	return true;
}

//保存业务分类修改
function saveWfBizCategory() {
	var blnReturn = "false";
	//有效性检查没有通过不能保存
//	if(!checkValidate())
//		return "false";
	if (opFlag == 0 || opFlag == "0") {
		
		var bizCateId = jQuery("#txtBizCateId").val();
		//该业务类的父类ID对应父类的分类ID
		var bizCateParentId = jQuery("#txtBizCateParentId").val();
		var bizCateName = jQuery("#txtBizCateName").val();
		var bizCateDesc = jQuery("#txtBizCateDesc").val();

		var sURL = webpath + "/WfBizCategoryAction.do?method=saveWfBizCategory";
	
		// 调用AJAX请求函数
		jQuery.ajax( {
			url : sURL,
			async : false,
			type : "post",
			dataType : "text",
			data : {
				bizCateId:bizCateId,
				bizCateParentId : bizCateParentId,
				bizCateName : bizCateName,
				bizCateDesc : bizCateDesc,
				opFlag : "0"
			},
			success : function(data) {
				if (data.indexOf("session timeout") != -1)
					top.location.href = webpath + "/login.jsp";
				var obj = eval('(' + data + ')');  //转换json
				if(obj.errorMessage==undefined){
					//window.returnValue = data;
					alert("保存成功");
					window.returnValue="true";
					window.close();
				} else {
					alert(obj.errorMessage);
					blnReturn = "false";
				}
			},
			error : function(XMLHttpRequest,textStatus,errorThrown){
				alert("网络错误");
				blnReturn = "false";
			}
		});
	} else if (opFlag == 1 || opFlag == "1") {
		//保存对业务分类的修改
		var sURL1 = webpath + "/WfBizCategoryAction.do?method=saveWfBizCategory";
		var bizCateId = jQuery("#txtBizCateId").val();
		var bizCateParentId = jQuery("#txtBizCateParentId").val();
		var bizCateName = jQuery("#txtBizCateName").val();
		var bizCateDesc = jQuery("#txtBizCateDesc").val();
		//一对多要修改的地方var roleUsers = jQuery("#txtRoleUsersValue").val();
		var sURL = webpath + "/WfBizCategoryAction.do?method=saveWfBizCategory";
		jQuery.ajax( {
			url : sURL1,
			async : false,
			type : "post",
			dataType : "text",
			data : {
				bizCateId : bizCateId,
				bizCateParentId : bizCateParentId,
				bizCateName : bizCateName,
				bizCateDesc : bizCateDesc,
				opFlag : "1"
			},
			success : function(data) {
				if (data.indexOf("session timeout") != -1)
					top.location.href = webpath + "/login.jsp";
				var obj = eval('(' + data + ')');  //转换json
				if(obj.errorMessage==null || obj.errorMessage==undefined){
					alert("修改成功");
					//window.close();
					blnReturn = "true";
				} else {
					alert(obj.errorMessage);
					blnReturn = "false";
				}
			},
			error : function(XMLHttpRequest,textStatus,errorThrown){
				alert("网络错误");
				blnReturn = "false";
				// 通常 textStatus 和 errorThrown 之中 
							// 只有一个会包含信息 
							//this;  调用本次AJAX请求时传递的options参数
			}
		});
	}
	return blnReturn;
}

//关闭窗体
function closeWin() {
	window.close();
}

//以下外键n:1单选 代码

//wf_biz_categorySelect 的回调函数
function wf_biz_categorySelectCallback(returnValue){
	if (returnValue){
		var itemIds = returnValue.itemIds;
		var itemTexts = returnValue.itemTexts;
		jQuery("#txtBizCateParentName").val(itemTexts);
		jQuery("#txtBizCateId").val(itemIds);
	}
}
//wf_biz_categoryParentSelect 的回调函数
function wf_biz_category_parentSelectCallback(returnValue){
	if (returnValue){
		var itemIds = returnValue.itemIds;
		var itemTexts = returnValue.itemTexts;
		jQuery("#txtBizCateParentName").val(itemTexts);
		jQuery("#txtBizCateParentId").val(itemIds);
	}
}
//选择业务分类
function wf_biz_categorySelect(){
	
	var sURL = webpath + "/WfBizCategoryAction.do?method=getWfBizCategory&forward=wfbizcategorySelect&displayColumnName=bizCateName";
	window.parent.dialogPopup_L3(sURL,"业务分类选择列表",400,570,true,"confirmWfBizCategorySelect",null,wf_biz_categorySelectCallback);
	
}
function wf_biz_category_parentSelect(){
	var sURL = webpath + "/WfBizCategoryAction.do?method=getWfBizCategory&forward=wfbizcategoryparentSelect&displayColumnName=bizCateName";
//	window.parent.dialogPopup_L3(sURL,"业务分类选择列表",400,570,true,"confirmWfBizCategoryParentSelect",null,wf_biz_category_parentSelectCallback);
	var browser = navigator.appName;
	if(browser == 'Microsoft Internet Explorer')
	{
		style="help:no;status:no;dialogWidth:40;dialogHeight:30";
	}
	else
	{
		style="help:no;status:no;dialogWidth:600px;dialogHeight:600px";
	}
	window.showModalDialog(sURL,window,style);
}


