jQuery.csDictPrice={
	divDictPrice:"DictPrice",
	// 绑定事件
	bindEvent: function(code) {
		$("#btnSearchDictPrice").click(function(){$.csDictPrice.list(0, code);});
		$("#btnAdd").click(function(){$.csDictPrice.openPost(code);});
	},
	list:function (pageIndex, username){
		var url = $.csCore.buildServicePath('/service/member/getdictprice');
	    var param =  $.csControl.getFormData('dict_price_result');
	    param = $.csControl.appendKeyValue(param,"pageindex",pageIndex);
	    param = $.csControl.appendKeyValue(param,"pagesize",PAGE_SIZE);
	    param = $.csControl.appendKeyValue(param, "username", username);
	    var data = $.csCore.invoke(url,param);
	    $.csCore.processList($.csDictPrice.divDictPrice, data);
	},
	init:function(id,name){
		$.csDictPrice.list(0, name);
		$.csDictPrice.bindEvent(name);
	},
	// 打开新增页面
	openPost: function(code) {
		$.csCore.loadModal('../member/addDictPrice.jsp', 350, 150, function(){$.csAddDictPrice.init(code);});
	},
	/**
	 * 删除
	 * @param id
	 */
	deleteDictPrice: function(id) {
		$.csCore.confirm($.csCore.getValue('Common_RemoveConfirm'), "$.csDictPrice.confirmDeleteDictPrice('" + id + "')");
	},
	/**
	 * 确认删除
	 * @param id
	 */
	confirmDeleteDictPrice: function(id) {
		var param = $.csControl.appendKeyValue("","id",id);
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/member/removedictprices'), param);
		if (data == "OK") {
			$("#dict_"+id).remove();
		}
	}
};