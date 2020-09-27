jQuery.csBlExpressComList={
    moduler : "BlExpressCom",
    /**
	 * 绑定事件
	 */
	bindEvent: function() {
		$("#btnSearch").click(function() {$.csBlExpressComList.list(0);});
		$("#btnAdd").click(function() {$.csBlExpressComList.openPost(null);});
		$("#btnRemove").click($.csBlExpressComList.remove);
	},
	
	/**
	 * 查看快递公司
	 * @param id 待查看的快递公司ID
	 */
	openView: function(id) {
		$.csCore.loadModal('../blexpresscom/view.htm',500,300,function(){$.csBlExpressView.init(id);});
	},
	
	/**
	 * 新增\修改快递公司
	 */
	openPost: function(id) {
		$.csCore.loadModal('../blexpresscom/post.htm',800,500,function(){$.csBlExpressPost.init(id);});
	},
	/**
	 * 移除快递公司
	 */
	remove: function() {
		var removeIDs = $.csControl.getCheckedValue('chkRow');
		var url = $.csCore.buildServicePath('/service/blexpresscom/removeexpresscoms');
		$.csCore.removeData(url, removeIDs);
	},
	
	list:function (pageIndex){
		var url = $.csCore.buildServicePath('/service/blexpresscom/getexpresscoms');
		var param =  $.csControl.getFormData("BlExpressComSearch");
		param = $.csControl.appendKeyValue(param,"pageindex",pageIndex);
		var datas = $.csCore.invoke(url,param);
	    $.csCore.processList($.csBlExpressComList.moduler, datas);
	    if (pageIndex == 0) {
	        $.csCore.initPagination($.csBlExpressComList.moduler + "Pagination", datas.count, PAGE_SIZE, $.csBlExpressComList.list);
	    }
	    $.csBlExpressComCommon.bindLabel();
	},
	init:function(){
		$.csBlExpressComList.bindEvent();
		$.csBlExpressComList.list(0);
	}
};