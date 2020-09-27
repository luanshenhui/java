jQuery(document)
		.ready(
				function() {
					// 加载流程列表
					var url = webpath
							+ "/view/workflow/wfprocess/WfProcessList.jsp";
					jQuery("iframe").attr("src", url);
					var setting = {
						data : {
							key : {
								title : "name"
							},
							simpleData : {
								enable : true,
								idKey : "bizCateId",
								pIdKey : "bizCateParentId",
								rootPId : '-1'
							}
						},
						callback : {
							beforeClick : beforeClick,
							onClick : onClick
						}
					};
					var className = "dark";
					function beforeClick(treeId, treeNode, clickFlag) {
						className = (className === "dark" ? "" : "dark");
						return (treeNode.click != false);
					}
					function onClick(event, treeId, treeNode, clickFlag) {
						jQuery("#bizCateId").val(treeNode.bizCateId);
						jQuery("#bizCateParentId")
								.val(treeNode.bizCateParentId);
						jQuery("#bizCateName").val(treeNode.name);
						var bizCateId = treeNode.bizCateId;
						// 选择流程分类
						if (bizCateId == 0) {
							bizCateId = null;
							return;
						}
						var bizCateName = treeNode.name;
						// 选择流程分类
						if (bizCateName == 0) {
							bizCateName = null;
							return;
						}
						url = webpath
								+ "/view/workflow/wfprocess/WfProcessList.jsp?bizCateId="
								+ bizCateId + "&bizCateName=" + bizCateName;
						jQuery("iframe").attr("src", url);
					}
					var zNodes = "";
					var sURL = webpath
							+ "/WfBizCategoryAction.do?method=getWfBizCategory";
					jQuery.ajax({
						url : sURL,
						async : false,
						type : "post",
						contentType : 'application/json; charset=UTF-8',
						data : {
							bizCateIds : 0
						},
						success : function(returnValue) {
							zNodes = returnValue;
							jQuery.fn.zTree.init($("#treeDemo"), setting,
									zNodes);
						},
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							alert("网络错误");
						}
					});
					var obj = document.getElementById('processFrame');
					obj.src = url;
					setWinHeight(obj);

				});
function setWinHeight(obj) {
	if (navigator.userAgent.indexOf("MSIE") > 0
			|| navigator.userAgent.indexOf("Trident") > 0) {

		var win = obj;
		if (document.getElementById) {
			if (win && !window.opera) {
				if (win.contentDocument
						&& win.contentDocument.body.offsetHeight)
					win.height = win.contentDocument.body.offsetHeight;
				else if (win.Document && win.Document.body.scrollHeight)
					win.height = win.Document.body.scrollHeight;
			}
		}

	} else {
		var ifm = obj;
		var subWeb = document.frames ? document.frames[down].document
				: ifm.contentDocument;
		if (ifm != null && subWeb != null) {
			ifm.height = subWeb.body.scrollHeight;
		}
	}
}

function doReloadFrame() {
	var obj = document.getElementById('personFrame');
	setWinHeight(obj);
}
function convertBizCateIdToBizCateParentId() {
	document.getElementById(elementId);
}
function doQuery(queryFormName, listFormName) {
	var queryPara = {
		/*
		 * bizCateId : jQuery("#txtBizCateId").val() , bizCateParentId :
		 * jQuery("#txtBizCateParentId").val() ,
		 */
		bizCateName : jQuery("#txtBizCateName").val(),
		bizCateDesc : jQuery("#txtBizCateDesc").val(),
		bizCateParentName : jQuery("#txtBizCateParentName").val()
	};
	ECSideUtil.queryECForm(listFormName, queryPara, true);
}

function addWfBizCategory() {
	var bizCateId = jQuery("#bizCateId").val();
	var bizCateParentId = jQuery("#bizCateParentId").val();
	var bizCateName = jQuery("#bizCateName").val();
	if (bizCateParentId == "" || bizCateName == "") {
		bizCateParentId = "-1";
		bizCateName = "流程分类";
	}
	var sURL = webpath
			+ "/view/workflow/wfbizcategory/WfBizCategoryDetail.jsp?opFlag=0&bizCateName="
			+ bizCateName + "&bizCateId=" + bizCateId;
	var browser = navigator.appName;
	if (browser == 'Microsoft Internet Explorer') {
		style = "help:no;status:no;dialogWidth:260px;dialogHeight:200px";
	} else {
		style = "help:no;status:no;dialogWidth:260px;dialogHeight:200px";
	}
	window.showModalDialog(encodeURI(sURL), window, style);
}

function updateWfBizCategory() {

	var bizCateId = jQuery("#bizCateId").val();
	if (bizCateId == null || bizCateId == "") {
		alert("请选择要修改的业务分类");
		return;
	}
	var bizCateName = jQuery("#bizCateName").val();
	var sURL = webpath
			+ "/view/workflow/wfbizcategory/WfBizCategoryDetail.jsp?opFlag=1&bizCateId="
			+ bizCateId + "&bizCateName=" + bizCateName;
	var browser = navigator.appName;
	if (browser == 'Microsoft Internet Explorer') {
		style = "help:no;status:no;dialogWidth:260px;dialogHeight:200px";
	} else {
		style = "help:no;status:no;dialogWidth:260px;dialogHeight:200px";
	}
	window.showModalDialog(encodeURI(sURL), window, style);

}

function deleteWfBizCategory() {
	var bizCateId = jQuery("#bizCateId").val();

	// 删除所选的业务分类id
	if (bizCateId == null || bizCateId == "" || bizCateId == "0") {
		alert("请选择要修改的业务分类");
		return;
	}
	var wfbizcategoryIds = bizCateId;
	// confirm("确认删除吗？",function(){

	var sURL = webpath + "/WfBizCategoryAction.do?method=deleteWfBizCategory";
	jQuery.ajax({
		url : sURL,
		async : false,
		type : "post",
		dataType : "json",
		data : {
			bizCateIds : wfbizcategoryIds
		},
		success : function(data) {

			if (data.errorMessage == null || data.errorMessage == undefined) {
				if (!data.delFlag) {
					alert("该分类含有子节点，请先删除子节点后再删除该节点！");
				} else {
					alert("删除成功");
					window.location.href = window.location.href;
				}
			} else {
				if (data.errorMessage == "session timeout")
					window.location.href = webpath + "/login.jsp";
				else
					alert(data.errorMessage);
			}

		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			alert("网络错误");
			// 通常 textStatus 和 errorThrown 之中
			// 只有一个会包含信息
			// this; 调用本次AJAX请求时传递的options参数
		}
	});
	// });
}

// 以下外键n:1单选 代码

// wf_biz_categorySelect 的回调函数
function wf_biz_categorySelectCallback(returnValue) {
	if (returnValue) {
		var itemIds = returnValue.itemIds;
		var itemTexts = returnValue.itemTexts;
		jQuery("#txtWf_biz_categoryName").val(itemTexts);
		jQuery("#txtBizCateId").val(itemIds);
	}
}
// wf_biz_categoryParentSelect 的回调函数
function wf_biz_category_parentSelectCallback(returnValue) {
	if (returnValue) {
		var itemIds = returnValue.itemIds;
		var itemTexts = returnValue.itemTexts;
		jQuery("#txtWf_biz_category_parentName").val(itemTexts);
		jQuery("#txtBizCateParentId").val(itemIds);
	}
}
// 选择业务分类
function wf_biz_categorySelect() {
	var sURL = webpath
			+ "/WfBizCategoryAction.do?method=getWfBizCategory&forward=wfbizcategorySelect&displayColumnName=bizCateName";
	window.parent.dialogPopup_L3(sURL, "业务分类选择列表", 400, 570, true,
			"confirmWfBizCategorySelect", null, wf_biz_categorySelectCallback);
}
function wf_biz_category_parentSelect() {
	var sURL = webpath
			+ "/WfBizCategoryAction.do?method=getWfBizCategory&forward=wfbizcategoryparentSelect&displayColumnName=bizCateName";
	window.parent.dialogPopup_L3(sURL, "业务分类选择列表", 400, 570, true,
			"confirmWfBizCategoryParentSelect", null,
			wf_biz_category_parentSelectCallback);
}
