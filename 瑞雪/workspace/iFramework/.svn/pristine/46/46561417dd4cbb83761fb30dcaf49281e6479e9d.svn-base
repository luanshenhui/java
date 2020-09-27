var WFCommon = {};

// copy the content of components to the clipboard
WFCommon.CopyContent2Clipboard = function(comId) {
	var d = jQuery("#" + comId).val();
	// window.clipboardData.setData("text",d);
	alert("ID为：" + d + "\n点击Ctrl+C复制到剪贴板!");
};

WFCommon.editExtendProperty = function(getComId, setComId) {
	var extendProp = jQuery("#" + getComId).val();
	windowId = 'extendProp';
	openUrl = webpath + "/view/workflow/common/jsp/WfExtendProp.jsp?setComId="
			+ setComId + "&extendProp="
			+ encodeURIComponent(encodeURIComponent(extendProp));
	var left = (window.screen.availWidth - 635) / 2 + 20;
	var top = (window.screen.availHeight - 420) / 2;
	if (document.all) {
		parameter = 'height=380, width=570, top=' + top + ', left=' + left
				+ ', toolbar=no, menubar=no, location=no, status=no';
	} else {
		parameter = 'height=380, width=570,  top=' + top + ', left=' + left
				+ ', toolbar=no, menubar=no, location=no, status=no';
	}
	newWin = window.open(openUrl, windowId, parameter);
};

WFCommon.HTMLEnCode = function(str) {
	var s = "";
	if (str.length == 0)
		return "";
	s = str.replace(/&/g, "&gt;");
	s = s.replace(/</g, "&lt;");
	s = s.replace(/>/g, "&gt;");
	s = s.replace(/    /g, "&nbsp;");
	s = s.replace(/\'/g, "&#39;");
	s = s.replace(/\"/g, "&quot;");
	s = s.replace(/\n/g, "<br>");
	return s;
};
WFCommon.HTMLDeCode = function(str) {
	var s = "";
	if (str.length == 0)
		return "";
	s = str.replace(/&amp;/g, "&");
	s = s.replace(/&lt;/g, "<");
	s = s.replace(/&gt;/g, ">");
	s = s.replace(/&nbsp;/g, "    ");
	s = s.replace(/&#39;/g, "\'");
	s = s.replace(/&quot;/g, "\"");
	s = s.replace(/<br>/g, "\n");
	return s;
};
