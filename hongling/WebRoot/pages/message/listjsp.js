jQuery.csMessageList={
    moduler : "Message",
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
	bindEvent:function (){
		$("#btnRemove").click($.csMessageList.remove);
		$("#btnInbox").click(function(){$("#inOrSent").val(0); $.csMessageList.list(0);});
		$("#btnSentbox").click(function(){$("#inOrSent").val(1); $.csMessageList.list(0);});
		$("#btnSendMessage").click($.csMessageList.openPost);
		$("#btnSearch").click(function(){$("#inOrSent").val(0);$.csMessageList.list(0);});
	},
	openPost:function (id){
		$.csCore.loadModal($.csMessageList.getPath()+'/pages/message/post.jsp',800,500,function(){$.csMessagePost.init(id);});
	},
	openView:function (id){
		$.csCore.loadModal($.csMessageList.getPath()+'/pages/message/view.jsp',800,500,function(){$.csMessageView.init(id);},function(){$.csMessageList.list(0);});
	},
	remove:function (){
		var removedIDs = $.csControl.getCheckedValue('chkRow');
		var url = $.csCore.buildServicePath('/service/message/removemessages');
		$.csCore.confirm($.csCore.getValue('Common_RemoveConfirm'), "$.csMessageList.confirmRemove('" + url + "','" + removedIDs + "')");
	},
	confirmRemove: function(url, removedIDs) {
	 var param = $.csControl.appendKeyValue("", "removedIDs", removedIDs);
	    var data = $.csCore.invoke(url, param);
	    if (data != null) {
	        if (data == "OK") {
	            removedIDs = removedIDs.split(',');
	            for (var i = 0; i <= removedIDs.length - 1; i++) {
	                $('#row' + removedIDs[i]).remove();
	            }
	            $.csMessageList.list(0);
	        }
	        else {
	            $.csCore.alert(data);
	        }
	    }
	},
	
	list:function (pageIndex){
		var param = $.csControl.getFormData("MessageSearch");
		param = $.csControl.appendKeyValue(param,"pageindex",pageIndex);
	    var data = $.csCore.invoke($.csCore.buildServicePath('/service/message/getmessages'),param);
	    $.csCore.processList($.csMessageList.moduler, data);
	    if (pageIndex == 0) {
	        $.csCore.initPagination($.csMessageList.moduler + "Pagination", data.count, PAGE_SIZE, $.csMessageList.list);
	    }
	    $.csMessageCommon.bindLabel();
	},
	init:function(){
		// 设置inOrSent的值
		$("#inOrSent").val(0);
		
		$.csMessageList.bindEvent();
		$.csMessageList.list(0);
	}
};