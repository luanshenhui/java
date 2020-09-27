jQuery.csDeliveryList={
	divDelivery : "Delivery",
	bindEvent:function (){
		$("#btnSearch").click(function(){$.csDeliveryList.list(0);});
		$("#btnCreateDelivery").click($.csDeliveryList.openCreateDelivery);
		$("#btnSaveDelivery").click($.csDeliveryList.saveDelivery);
		$("#btnCancel").click($.csCore.close);
	},
	openExport:function (id){
		var url = $.csCore.buildServicePath('/service/delivery/exportdelivery?id=' + id);
		window.open(url);
	},
	openView:function (id){
		$.csCore.loadModal('../delivery/view.htm',800,500,function(){$.csDeliveryView.init(id);});
	},
	list:function (pageIndex){
		var url = $.csCore.buildServicePath('/service/delivery/getdeliverys');
		var param = $.csControl.appendKeyValue("","pageindex",pageIndex);
		var data = $.csCore.invoke(url,param);
	    $.csCore.processList($.csDeliveryList.divDelivery, data);
	    if (pageIndex == 0) {
	        $.csCore.initPagination($.csDeliveryList.divDelivery + "Pagination", data.count, PAGE_SIZE, $.csDeliveryList.list);
	    }
	    $.csDeliveryCommon.bindLabel();
	},
	init:function(){
		$.csDeliveryList.bindEvent();
		$.csDeliveryList.list(0);
	}
};

jQuery.csDeliveryCommon={
		bindLabel:function (){
			$.csCore.getValue($.csCore.getDictResourceName(DICT_BACKEND_MENU_DELIVERY_MANAGER),null,".list_search h1");
			$.csCore.getValue("Member_Moduler",null,".lblMember_Info");
			$.csCore.getValue("Delivery_Date",null,".lblDeliveryDate");
			$.csCore.getValue("Delivery_Address",null,".lblDeliveryAddress");
			$.csCore.getValue("Common_Status",null,".lblStatus");
			$.csCore.getValue("Orden_Code",null,".lblCode");
			$.csCore.getValue("Orden_ClothingCategory",null,".lblClothingCategory");
			$.csCore.getValue("Customer_Name",null,".lblName");
			$.csCore.getValue("Common_Tel",null,".lblTel");
			$.csCore.getValue("Fabric_Moduler",null,".lblFabric");
			$.csCore.getValue("Button_Export",null,".lblExport");
			$.csCore.getValue("Button_Export",null,".edit");
			$.csCore.getValue("Button_Browse",null,".lblBrowse");
			$.csCore.getValue("Button_Browse",null,".browse");
		},
		getDeliveryByID:function(id){
			var url = $.csCore.buildServicePath('/service/delivery/getdeliverybyid');
			var param = $.csControl.appendKeyValue("","id",id);
			return $.csCore.invoke(url,param);
		}
	};