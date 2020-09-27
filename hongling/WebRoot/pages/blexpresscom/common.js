jQuery.csBlExpressComCommon={
	bindLabel: function() {
		// 列表页面
		$.csCore.getValue("Common_Keyword",null,".lblKeyword");
		$.csCore.getValue("Common_Index",null,".lblNumber");
		$.csCore.getValue("Delivery_ComName",null,".lblComName");
		$.csCore.getValue("Delivery_ComShortName",null,".lblShortName");
		$.csCore.getValue("Member_Contact",null,".lblLinkMan");
		$.csCore.getValue("Common_Tel",null,".lblTel");
		$.csCore.getValue("Delivery_Mobile",null,".lblMobile");
		$.csCore.getValue("Customer_Address",null,".lblAddr");
		$.csCore.getValue("Common_Memo",null,".lblMemo");
		$.csCore.getValue("Button_Do",null,".lblOperate");
		$.csCore.getValue("Button_Edit",null,".edit");
		$.csCore.getValue("Label_Seq",null,".lblSeq");
		
		$.csCore.getValue("Member_Express",null,"#expressCom");
		$.csCore.getValue("Button_Search",null,"#btnSearch");
		$.csCore.getValue("Button_Add",null,"#btnAdd");
		$.csCore.getValue("Button_Remove",null,"#btnRemove");
		
		// 新增、修改页面
		$.csCore.getValue("Button_Submit",null,"#btnSaveExpress");
		$.csCore.getValue("Button_Cancel",null,"#btnCancelExpress");
	},

	/**
	 * 根据ID检索快递公司
	 * @param id 待检索的快递公司ID
	 */
	getExpressComById: function(id) {
		var url = $.csCore.buildServicePath('/service/blexpresscom/getexpresscombyid');
		var param = $.csControl.appendKeyValue("","id",id);
		return $.csCore.invoke(url,param);
	},

	/**
	 * 检索所有的快递公司
	 */
	queryAll: function() {
		var url = $.csCore.buildServicePath('/service/blexpresscom/getAllexpresscoms');
		var data = $.csCore.invoke(url);
		return data;
	}
};