jQuery.csBlExpressView={
	view:function (id){
		var expressCom = $.csBlExpressComCommon.getExpressComById(id);
		$.csCore.viewWithJSON('view_expressCom',expressCom);
	},
	init:function(id){
		$.csBlExpressComCommon.bindLabel();
		$.csBlExpressView.view(id);
		$.csCore.addValueLine('view_expressCom');
	}
};