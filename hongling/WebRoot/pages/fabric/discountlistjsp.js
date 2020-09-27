jQuery.csFabricDiscountList={
	divFabricDiscount:"FabricDiscount",
	// 绑定事件
	bindEvent: function(code) {
		$.csDate.datePickerNull("startDate");
		$.csDate.datePickerNull("endDate");
		$("#btnSearchFabricDiscount").click(function(){$.csFabricDiscountList.list(0, code);});
		$("#btnAdd").click(function(){$.csFabricDiscountList.openPost(code);});
	},
	list:function (pageIndex, code){
		var url = $.csCore.buildServicePath('/service/fabric/getfabricdiscounts');
	    var param =  $.csControl.getFormData('fabric_discount_result');
	    param = $.csControl.appendKeyValue(param,"pageindex",pageIndex);
	    param = $.csControl.appendKeyValue(param,"pagesize",PAGE_SIZE);
	    param = $.csControl.appendKeyValue(param, "code", code);
	    var data = $.csCore.invoke(url,param);
	    $.csCore.processList($.csFabricDiscountList.divFabricDiscount, data);
	    $.csFabricCommon.bindLabel();
	},
	init:function(code){
		$.csFabricDiscountList.list(0, code);
		$.csFabricDiscountList.bindEvent(code);
	},
	// 打开新增页面
	openPost: function(code) {
		$.csCore.loadModal('../fabric/discount.jsp', 600, 300, function(){$.csFabricDiscount.init(code);});
	},
	/**
	 * 查看详情
	 * @param id
	 */
	openView: function(id) {
		$.csCore.loadModal('../fabric/discountview.jsp',600,300,function(){$.csFabricDiscountView.init(id);});
	},
	/**
	 * 删除促销活动
	 * @param id
	 */
	deleteDiscount: function(id,code) {
		$.csCore.confirm($.csCore.getValue('Common_RemoveConfirm'), "$.csFabricDiscountList.confirmDeleteFabricDiscount('" + id + "','"+code+"')");
	},
	/**
	 * 确认删除促销活动
	 * @param id
	 */
	confirmDeleteFabricDiscount: function(id,code) {
		var param = $.csControl.appendKeyValue("","id",id);
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/fabric/removefabricdiscount'), param);
		if (data == "OK") {
			$.csFabricDiscountList.list(0, code);
		}
	}
};