jQuery.csMessageList={
    moduler : "Message",
	bindEvent:function (){
		$("#btnRemove").click($.csMessageList.remove);
		$("#btnInbox").click(function(){$("#inOrSent").val(0); $.csMessageList.list(0);});
		$("#btnSentbox").click(function(){$("#inOrSent").val(1); $.csMessageList.list(0);});
		$("#btnSendMessage").click($.csMessageList.openPost);
		$("#btnSearch").click(function(){$("#inOrSent").val(0);$.csMessageList.list(0);});
	},
	openPost:function (id){
		$.csCore.loadModal('../message/post.htm',800,500,function(){$.csMessagePost.init(id);});
	},
	openView:function (id){
		$.csCore.loadModal('../message/view.htm',800,500,function(){$.csMessageView.init(id);},function(){$.csMessageList.list(0);});
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