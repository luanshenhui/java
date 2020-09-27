jQuery.csFabricPirceList={
	divFabricPrice:"FabricPrice",
	// 绑定事件
	bindEvent: function(code) {
		$("#btnAdd").click(function(){$.csFabricPirceList.openPost(code);});
		$("#btnRemove").click($.csFabricPirceList.remove);
	},
	list:function (pageIndex, code){
		var url = $.csCore.buildServicePath('/service/fabric/getfabricprices');
	    var param = "";
	    param = $.csControl.appendKeyValue(param,"pageindex",pageIndex);
	    param = $.csControl.appendKeyValue(param,"pagesize",PAGE_SIZE);
	    param = $.csControl.appendKeyValue(param, "code", code);
	    
	    var data = $.csCore.invoke(url,param);
	    $.csCore.processList($.csFabricPirceList.divFabricPrice, data);
	    $.csFabricCommon.bindLabel();
	},
	init:function(code){
		 $.csFabricPirceList.list(0, code);
		 $.csFabricPirceList.bindEvent(code);
		 $('#code').val(code);
	},
	// 打开新增页面
	openPost: function(code) {
		$.csCore.loadModal('../fabric/price.jsp', 600, 300, function(){$.csFabricPrice.init(code);});
	},
	/**
	 * 删除面料价格
	 */
	remove: function() {
		var removeIDs = $.csControl.getCheckedValue('price_chkRow');
		$.csCore.confirm($.csCore.getValue('Common_RemoveConfirm'), "$.csFabricPirceList.confirmDeleteFabricPrice('" + removeIDs + "')");
	},
	confirmDeleteFabricPrice : function (removeIDs) {
		var param = $.csControl.appendKeyValue("","removedIDs",removeIDs);
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/fabric/removefabricprice'), param);
		if (data == "OK") {
			$.csFabricPirceList.list(0, $('#code').val());
		}
	}
};