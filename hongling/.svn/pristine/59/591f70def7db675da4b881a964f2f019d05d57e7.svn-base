jQuery.csFabricDiscountView={
	view:function (id){
		var discount = $.csFabricDiscountView.getDiscountById(id);
		$.csCore.viewWithJSON('view_fabricdiscount',discount);
		$("#_view_startDate").html($.csDate.formatMillisecondDate(discount.startDate));
		$("#_view_endDate").html($.csDate.formatMillisecondDate(discount.endDate));
	},
	init:function(id){
		$.csFabricCommon.bindLabel();
		$.csFabricDiscountView.view(id);
		$.csCore.addValueLine('view_fabricdiscount');
	},
	/**
	 * 根据ID查询折扣信息
	 * @param id
	 */
	getDiscountById: function (id) {
		var param = $.csControl.appendKeyValue("","id",id);
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/fabric/getabricdiscountbyid'), param);
		return data;
	}
};