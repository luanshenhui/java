jQuery.ReceivingCommon = {
	bindLabel : function() {
		$.csCore.getValue("Orden_Code",null,".lblCode");
		$.csCore.getValue("Orden_ClothingCategory",null,".lblListClothingCategory");
		$.csCore.getValue("Common_Tel",null,".lblTel");
		$.csCore.getValue("Orden_Memo",null,".lblMemo");
		$.csCore.getValue("Orden_PubDate",null,".lblPubDate");
		$.csCore.getValue("Orden_DealDate",null,".lblDealDate");
		$.csCore.getValue("Member_OwnedStore",null,".lblOwnedStore");
		$.csCore.getValue("Member_Name",null,".lblName");
		$.csCore.getValue("Common_Memo",null,".blLblMemo");
		$.csCore.getValue("Cash_LastDealDate",null,".lblPubDate");
		$.csCore.getValue("Button_Add",null,"#btnAdd");
		$.csCore.getValue("Button_Search",null,"#btnSearch");
		$.csCore.getValue("Button_Remove",null,"#btnRemove");
		$.csCore.getValue("Button_Export",null,"#btnExportOrdens");
		$.csCore.getValue($.csCore.getDictResourceName(DICT_BACKEND_MENU_RECEIVING_MANAGE),null,".list_search h1");
		$.csCore.getValue("Orden_Number",null,".lblNumber");
	},
	bindEvent:function (){
		$.csCore.pressEnterToSubmit('keyword','btnSearch');
		$("#btnSearch").click(function(){$.csReceivingList.list(0);});
		$("#btnAdd").click($.csReceivingList.Add);
		$("#btnRemove").click($.csReceivingList.remove);
		$("#btnExportOrdens").click($.csReceivingList.exportExcel);
		$.csDate.datePicker("fromDate");
		$.csDate.datePicker("toDate");
	}
};