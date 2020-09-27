var WfExtendProp = {};

// 设置表格属性值列表
function getExtPropString(comId) {
	var contentString = jQuery("td", jQuery("#" + comId)).map(function() {
		return this.innerHTML;
	}).get().join("&");
	if (contentString.indexOf(",") > 0 || contentString.indexOf(";") > 0) {
		alert("扩展属性中包含特殊字符','或';'，请修正后重新提交！");
		return null;
	}
	var resultStringArray = jQuery("tr", jQuery("#" + comId)).map(function() {
		var key = jQuery("td:eq(1)", this).html();
		var val = jQuery("td:eq(2)", this).html();
		if (key) {
			return key + "," + val;
		} else {
			return;
		}
		;
	});

	var resultString = resultStringArray.get().join(";");
	return resultString;
};

// 2增加属性
WfExtendProp.appendProperty = function() {
	var txt = "<tr><td align='center' title><input type='checkbox' ></td><td ondblclick='WfExtendProp.editTd_key(this)'></td><td ondblclick='WfExtendProp.editTd_val(this)'></td></tr>";
	jQuery("#tbody").append(jQuery(txt));
};
// 3删除属性
WfExtendProp.removeProperty = function(msg) {
	var checkedData = jQuery("input:checked", jQuery("#tbody"));
	if (checkedData.length == 0) {
		alert("请选择数据！");
	} else if (confirm(msg)) {
		jQuery("input:checked", jQuery("#tbody")).each(function() {
			jQuery(this).parents(":eq(1)").remove();
		});
	}
	;
};
// 4修改属性
WfExtendProp.editTd_key = function(obj) {
	var txt = jQuery(obj).html();
	jQuery(obj).html("");
	jQuery(obj).append(jQuery("#editTxt_key").val(txt));
	jQuery("#editTxt_key").focus();
};
// 4修改属性
WfExtendProp.editTd_val = function(obj) {
	var txt = jQuery(obj).html();
	jQuery(obj).html("");
	jQuery(obj).append(jQuery("#editTxt_val").val(txt));
	jQuery("#editTxt_val").focus();
};

WfExtendProp.blurTxt_key = function(obj) {
	var txt = jQuery(obj).val();
	var tdObj = jQuery(obj).parent();
	tdObj.html(txt);
	jQuery("#editTxtHolder").append(obj);
	jQuery(obj).val("");
};
WfExtendProp.blurTxt_val = function(obj) {
	var txt = jQuery(obj).val();
	var tdObj = jQuery(obj).parent();
	tdObj.html(txt);
	jQuery("#editTxtHolder").append(obj);
	jQuery(obj).val("");
};

WfExtendProp.addRow = function() {
	WfExtendProp.appendProperty();
};

WfExtendProp.deleteRow = function() {
	WfExtendProp.removeProperty("是否确认删除？");
};

WfExtendProp.submitData = function() {
	var returnString = getExtPropString("tbody");
	if (returnString!=null) {
		window.opener.document.getElementById(setComId).value = returnString;
		window.opener = null;
		window.close();
	}
};
