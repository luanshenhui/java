jQuery.csMessageView={
	view:function (id){
		var message = $.csMessageCommon.getMessageByID(id);
		$.csCore.viewWithJSON('view_message',message);
		$("#_view_pubDate").html($.csDate.formatMillisecondDate(message.pubDate));
		$("#_view_readDate").html($.csDate.formatMillisecondDate(message.readDate));
	},
	close:function(){
		
	},
	init:function(id){
		$.csMessageCommon.bindLabel();
		$.csMessageView.view(id);
		$.csCore.addValueLine('view_message');
	}
};