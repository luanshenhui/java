jQuery.csFabricConsume={
	divFabricConsume:"FabricConsume",
	// 绑定事件
	bindEvent: function(username) {
		$("#btnAdd").click(function(){$.csFabricConsume.openPost(username);});
	},
	list:function (pageIndex,username){
		var url = $.csCore.buildServicePath('/service/member/getfabricconsume');
		var param =  $.csControl.getFormData('fabric_consume_result');
	    param = $.csControl.appendKeyValue(param,"pageindex",pageIndex);
	    param = $.csControl.appendKeyValue(param,"pagesize",PAGE_SIZE);
	    param = $.csControl.appendKeyValue(param, "username", username);
	    var data = $.csCore.invoke(url,param);
	    $.csCore.processList($.csFabricConsume.divFabricConsume, data);
	},
	init:function(username){
		$.csFabricConsume.list(0,username);
		$.csFabricConsume.bindEvent(username);
	},
	// 打开新增页面
	openPost: function(username) {
		$.csCore.loadModal('../member/fabricConsumePost.jsp', 600, 300, function(){$.csFabricConsumePost.init(username);});
	},
	/**
	 * 删除
	 * @param id
	 */
	deleteFabricConsume: function(id,username) {
		$.csCore.confirm($.csCore.getValue('Common_RemoveConfirm'), "$.csFabricConsume.confirmDeleteFabricConsume('" + id + "','"+username+"')");
	},
	/**
	 * 确认删除
	 * @param id
	 */
	confirmDeleteFabricConsume: function(id,username) {
		var param = $.csControl.appendKeyValue("","id",id);
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/member/removefabricconsume'), param);
		$.csFabricConsume.list(0,username);
	}
};