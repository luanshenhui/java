jQuery.csBlDeliveryFCommon={
	bindLabel:function (){
		$.csCore.getValue($.csCore.getDictResourceName(DICT_BACKEND_MENU_DELIVERY_MANAGER),null,".list_search h1");
		$.csCore.getValue("Orden_ClothingCategory",null,".blLblClothingCategory");
		$.csCore.getValue("Common_Status",null,".blLblStatus");
		$.csCore.getValue("Customer_Name",null,".blLblName");
		$.csCore.getValue("Common_Keyword",null,".blLblKeyword");
		
		$.csCore.getValue("Button_Delivery",null,"#blBtnDelivery");
		$.csCore.getValue("Button_DeliverySetting",null,"#blBtnDeliverySetting");
		$.csCore.getValue("Delivery_Details",null,"#blBtnDeliveryDetail");
		$.csCore.getValue("Button_Export",null,"#blBtnExportOrdens");
		$.csCore.getValue("Button_Search",null,"#blBtnSearch");
		
		$.csCore.getValue("Orden_PubDate",null,".blLblPubDate");
		$.csCore.getValue("Orden_DealDate",null,".blLblDealDate");
		$.csCore.getValue("Orden_Number",null,".blLblNumber");
		$.csCore.getValue("Orden_Code",null,".blLblCode");
		$.csCore.getValue("Fabric_Moduler",null,".blLblFabric");
		$.csCore.getValue("Delivery_Date",null,".blLblDeliveryDate");
		$.csCore.getValue("Delivery_Status",null,".blLblDeliveryStatus");
		$.csCore.getValue("Orden_StopCause",null,".blLblStopCause");
		$.csCore.getValue("Delivery_OutStore",null,".blLblOutStore");
		$.csCore.getValue("Delivery_Address",null,".lblDeliveryAddress");
		$.csCore.getValue("Delivery_Date",null,".lblDeliveryDate");
		$.csCore.getValue("Delivery_Status",null,".lblDeliveryStatus");
		$.csCore.getValue("Member_Express",null,".lblDeliveryExpressCom");
		
		
		$.csCore.getValue("Delivery_Info",null,"#delivery_form h1");
		$.csCore.getValue("Button_Submit",null,"#btnSaveDelivery");
		$.csCore.getValue("Button_Cancel",null,"#btnCancelDelivery");
		$.csCore.getValue("Delivery_Details",null,"#DeliveryDetails");
		
		$.csCore.getValue("Orden_Code",null,".lblCodeFront");
		$.csCore.getValue("Orden_ClothingCategory",null,".lblClothingCategoryFront");
		$.csCore.getValue("Customer_Name",null,".lblNameFront");
		$.csCore.getValue("Common_Tel",null,".lblTelFront");
		$.csCore.getValue("Fabric_Moduler",null,".lblFabricFront");
	},
	getOrdenByID:function(id){
		var param = $.csControl.appendKeyValue("","id",id);
		return $.csCore.invoke($.csCore.buildServicePath('/service/orden/getordenbyid'),param);
	}
};

jQuery.csBlDeliveryHCommon={
		bindLabel:function (){
			$.csCore.getValue($.csCore.getDictResourceName(DICT_BACKEND_MENU_DELIVERY_MANAGER),null,".list_search h1");
			$.csCore.getValue("Common_Keyword",null,".blLblKeyword");
			$.csCore.getValue("Orden_DeliveryDate",null,".blLblDeliverDate");
			$.csCore.getValue("Button_Export",null,"#blExport,.blExportDelivery");
			
			$.csCore.getValue("Delivery_CreateCJD",null,"#blCreateChangjiandanju");
			$.csCore.getValue("Delivery_CreateSJD",null,"#blCreateShangjiandanju");
			$.csCore.getValue("Delivery_CreateBGD",null,"#blCreateBaoguandanju");
			$.csCore.getValue("Member_Express",null,"#blExpressCom");
			$.csCore.getValue("Button_Search",null,"#blSearch");
			
			$.csCore.getValue("Orden_Number",null,".blLblNumber");
			$.csCore.getValue("Member_Username",null,".blLblUserName");
			$.csCore.getValue("Delivery_UserCode",null,".blLblUserCode");
			$.csCore.getValue("Delivery_Address",null,".blLblDeliveryAddr");
			$.csCore.getValue("Delivery_CreateDate",null,".blLblCreateDate");
			$.csCore.getValue("Delivery_Date",null,".blLblDeliveryDate");
			$.csCore.getValue("Delivery_Stu",null,".blLblDeliveryStu");
			$.csCore.getValue("Dict_20130",null,".blLblyishenqing");
			$.csCore.getValue("Dict_20131",null,".blLblyitihuo");
			$.csCore.getValue("Dict_10033",null,".blLblyifahuo");
			$.csCore.getValue("Delivery_TrackingNO",null,".blLblTrackingNumber");
			$.csCore.getValue("Button_Export",null,".blLblExportDelivery");
			$.csCore.getValue("Button_Edit",null,".edit");
			$.csCore.getValue("Button_Do",null,".blLblEdit");
			$.csCore.getValue("Delivery_View",null,".view");
		},
		getDeliveryByID:function(id){
			var url = $.csCore.buildServicePath('/service/delivery/getdeliverybyid');
			var param = $.csControl.appendKeyValue("","id",id);
			return $.csCore.invoke(url,param);
		}
};

jQuery.csBlDeliveryDetailFCommon={
		bindLabel:function (){
			$.csCore.getValue("Button_Export",null,"#blDetailBtnExportDelivery");
			$.csCore.getValue("Delivery_List",null,".list_search h2");
			$.csCore.getValue("Common_Keyword",null,"blDetailLblKeyword");
			$.csCore.getValue("Orden_DeliveryDate",null,".blDetailLblDeliverDate");
			
			$.csCore.getValue("Button_Search",null,"#blDetailBtnSearch");
			
			$.csCore.getValue("Orden_Number",null,".blLblNumber");
			$.csCore.getValue("Member_Username",null,".blLblUserName");
			$.csCore.getValue("Delivery_UserCode",null,".blLblUserCode");
			$.csCore.getValue("Delivery_Address",null,".blLblDeliveryAddr");
			$.csCore.getValue("Delivery_CreateDate",null,".blLblCreateDate");
			$.csCore.getValue("Delivery_Date",null,".blLblDeliveryDate");
			$.csCore.getValue("Delivery_TrackingNO",null,".blLblTrackingNumber");
			$.csCore.getValue("Button_Export",null,".blLblExportDelivery,.blExportDelivery");
			$.csCore.getValue("Delivery_Cancel",null,".blLblCancel,.blCancel");
			$.csCore.getValue("Button_Do",null,".blLblOperate");
			$.csCore.getValue("Delivery_View",null,".view");
		},
		getDeliveryByID:function(id){
			var url = $.csCore.buildServicePath('/service/delivery/getdeliverybyid');
			var param = $.csControl.appendKeyValue("","id",id);
			return $.csCore.invoke(url,param);
		}
};

jQuery.csBlDeliveryDetailHCommon={
		bindLabel: function() {
			$.csCore.getValue("Delivery_Details",null,"h1");
			$.csCore.getValue("Button_Add",null,"#blAddDeliveryDetail");
			$.csCore.getValue("Delivery_Storage",null,"#blLblStorage");
			
			$.csCore.getValue("Common_Index",null,".blLblNumber");
			$.csCore.getValue("Fabric_ysddh",null,".blLblOrdenID");
			$.csCore.getValue("Common_Count",null,".blLblAmount");
			$.csCore.getValue("Delivery_CompositionName",null,".blLblCompositionName");
			$.csCore.getValue("Delivery_ClosingType",null,".blLblClosingType");
			$.csCore.getValue("Button_Do",null,".blLblOperate");
			$.csCore.getValue("Button_Remove",null,".delete");
			
			$.csCore.getValue("Button_Submit",null,"#btnSaveDeliveryDetail");
			$.csCore.getValue("Button_Cancel",null,"#btnCancelDeliveryDetail");
			$.csCore.getValue("Delivery_Lade",null,"#btnLadeDelivery");
			$.csCore.getValue("Common_Save",null,"#btnSaveDelivery");
			
			$.csCore.getValue("Member_Username",null,".blLblUserName");
			$.csCore.getValue("Delivery_Address",null,".blLblDeliveryAddr");
			$.csCore.getValue("Delivery_Date",null,".blLblDeliveryDate");
			
			$.csCore.getValue("Button_Submit",null,"#btnSaveAddDeliveryDetail");
			$.csCore.getValue("Button_Cancel",null,"#btnCancelAddDeliveryDetail");
			
			$.csCore.getValue("Orden_Code",null,".lblCode");
			$.csCore.getValue("Orden_ClothingCategory",null,".lblClothingCategory");
			$.csCore.getValue("Customer_Name",null,".lblName");
			$.csCore.getValue("Common_Tel",null,".lblTel");
			$.csCore.getValue("Fabric_Moduler",null,".lblFabric");
			$.csCore.getValue("Common_Memo",null,".blLblMemo");
			$.csCore.getValue("Common_Status",null,".blLblOrdenStatus");
			$.csCore.getValue("Common_Amount",null,".blLblAmount");
		}
};