jQuery.csBlViewOrdenListCommon={
		bindLabel:function (){
			$.csCore.getValue($.csCore.getDictResourceName(DICT_BACKEND_MENU_VIEWORDEN_MANAGE),null,".list_search h1");
			$.csCore.getValue("Common_Keyword",null,".blLblKeyword");
			$.csCore.getValue("Orden_PubDate",null,".lblPubDate");
			$.csCore.getValue("Delivery_Date",null,".lblDeliveryDate");
			$.csCore.getValue("Orden_DealDate",null,".lblDealDate");
			$.csCore.getValue("Orden_Number",null,".lblNumber");
			$.csCore.getValue("Orden_Code",null,".lblCode");
			$.csCore.getValue("Orden_ClothingCategory",null,".lblClothingCategory");
			$.csCore.getValue("Customer_Name",null,".lblName");
			$.csCore.getValue("Fabric_Moduler",null,".lblFabric");
			$.csCore.getValue("Orden_PubDate",null,".lblPubDate");
			$.csCore.getValue("Delivery_Date",null,".lblDeliveryDate");
			$.csCore.getValue("Orden_DealDate",null,".lblDealDate");
			$.csCore.getValue("Delivery_OutStore",null,".lblChukudanId");
			$.csCore.getValue("Button_Search",null,"#blBtnSearchOrdens");
			$.csCore.getValue("Common_Status",null,".lblStatus");
			$.csCore.getValue("Customer_No",null,".lblUserNo");
		}
};