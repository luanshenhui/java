jQuery.csMessagePost={
	bindEvent:function (){
		$("#btnSubmit").click($.csMessagePost.save);
		$("#btnCancel").click($.csCore.close);
		$("#receiverTexts").click($.csMessagePost.pickUser);
	},
	// js获取项目根路径，如： http://localhost:8080/hongling
	getPath : function getRootPath() {
		// 获取当前网址，如：  http://localhost:8080/hongling/orden/meun.jsp
		var curWwwPath = window.document.location.href;
		// 获取主机地址之后的目录，如： uimcardprj/share/meun.jsp
		var pathName = window.document.location.pathname;
		var pos = curWwwPath.indexOf(pathName);
		// 获取主机地址，如： http://localhost:8080
		var localhostPaht = curWwwPath.substring(0, pos);
		// 获取带"/"的项目名，如：/hongling
		var projectName = pathName.substring(0,
				pathName.substr(1).indexOf('/') + 1);
		return (localhostPaht + projectName);
	},
	save:function (){
	    if($.csCore.postData($.csCore.buildServicePath('/service/message/savemessage'), 'form')){
	    	$.csMessageList.list(0);
	    	$.csCore.close();
	    }
	},
	pickUser: function () {
        $.csMessagePost.csCore_pickUser('receiverID', 'receiverTexts', true);
    },
    csCore_pickUser: function (controlID, controlText, isMultiple, groupID) {
        $.csCore.loadModal($.csMessagePost.getPath()+'/pages/member/pick.jsp', 600, 370, function () { $.csMemberPick.init(controlID, controlText, isMultiple, groupID); });
    },
	init:function(id){
		$.csMessageCommon.bindLabel();
		$.csMessagePost.bindEvent();
		//$.csCore.autoCompleteUsername("username",true);
	}
};