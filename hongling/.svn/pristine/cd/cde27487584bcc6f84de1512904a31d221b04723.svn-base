jQuery.csFabricPrice={
	bindEvent:function (code){
		$("#btnPriceFabric").click(function(){$.csFabricPrice.price(code);});
		$("#btnPriceCancel").click($.csCore.close);
	},
	/**
	 * 保存面料价格
	 */
	price:function (code){
		if($.csFabricPrice.validate()){
		    if($.csCore.postData($.csCore.buildServicePath('/service/fabric/pricefabric'), 'form_price')){
		    	alert($.csCore.getValue("Fabric_PriceOk"));
		    	$.csCore.close();
		    }
	    }
		// 刷新列表页面
		$.csFabricPirceList.list(0,code);
	},
	validate:function (){
		if($.csValidator.checkNull("rmbPrice",$.csCore.getValue("Common_Required","Fabric_RMBPrice"))){
			return false;
		}
		if($.csValidator.checkNull("dollarPrice",$.csCore.getValue("Common_Required","Fabric_DollarPrice"))){
			return false;
		}
		return true;
	},
	/**
	 * 填充经营单位
	 */
	fillAreaId: function(code) {
		$.csControl.fillOptions('areaId',$.csCore.invoke($.csCore.buildServicePath('/service/dict/getareanoprice'), $.csControl.appendKeyValue("", "code", code)), "ID" , "name", $.csCore.getValue("Common_PleaseSelect","Member_BusinessUnit"));
	},
	/**
	 * 根据面料编号，查询面料价格
	 * @param code
	 */
	initPrice: function(code) {
		var param = $.csControl.appendKeyValue("","code",code);
		var retValue = $.csCore.invoke($.csCore.buildServicePath("/service/fabric/getpricefabric"),param);
		if (retValue.suitRmbPrice != null) {
			$('#rmbPrice').val(retValue.suitRmbPrice);
		}
		if (retValue.suitDollarPrice != null) {
			$('#dollarPrice').val(retValue.suitDollarPrice);
		}
	},
	init:function(code){
		$.csFabricCommon.bindLabel();
		$.csFabricPrice.bindEvent(code);
		$.csFabricPrice.fillAreaId(code);
//		$.csFabricPrice.initPrice(code);
		$('#priceCode').html(code);
		$('#fabricCode').val(code);
	},
	/**
	 * 打开编辑页面
	 * @param id
	 */
	openEdit: function(id) {
		$.csCore.loadModal('../fabric/price.jsp', 600, 300, function(){$.csFabricPrice.initEdit(id);});
	},
	initEdit: function(id) {
		var fabricPrice = $.csFabricPrice.getFabricPriceById(id);
		$.csFabricCommon.bindLabel();
		$.csFabricPrice.bindEvent(fabricPrice.fabricCode);
		$.csFabricPrice.fillAreaId(fabricPrice.fabricCode);
		$.updateWithJSON(fabricPrice);
		$('#areaId').hide();
		$('#areaName').val(fabricPrice.areaName);
		$('#priceCode').html(fabricPrice.fabricCode);
		$('#fabricCode').val(fabricPrice.fabricCode);
		$('#oriAreaId').val(fabricPrice.areaId);
	},
	/**
	 * 根据ID得到面料价格
	 * @param id
	 */
	getFabricPriceById: function(id) {
		var url = $.csCore.buildServicePath('/service/fabric/getfabricpricebyid');
		var param = $.csControl.appendKeyValue("","id",id);
		return $.csCore.invoke(url,param);
	}
};