jQuery.csBlDiscountCommon={
		bindLabel:function (){
			$.csCore.getValue("Cash_AddDiscount",null,".form_template h1");
			$.csCore.getValue("Cash_AccountName",null,".blLblUsername");
			$.csCore.getValue("Orden_ClothingCategory",null,".blLblClothing");
			$.csCore.getValue("Cash_FromNum",null,".blLblFromNum");
			$.csCore.getValue("Cash_ToNum",null,".blLblToNum");
			$.csCore.getValue("Cash_DiscountNumOfHundred",null,".blLblDiscountNum");
			$.csCore.getValue("Common_Memo",null,".blLblMemo");
			
			$.csCore.getValue("Button_Submit",null,"#blBtnSaveDiscount");
			$.csCore.getValue("Button_Cancel",null,"#blBtnCancelDiscount");
		}
};

jQuery.csBlDiscountListCommon={
		bindLabel:function (){
			$.csCore.getValue("Button_Search",null,"#blBtnSearchMemberDiscount");
			$.csCore.getValue("Button_Add",null,"#blBtnAddMemberDiscount");
			
			$.csCore.getValue("Common_Keyword",null,".blLblKeyword");
			$.csCore.getValue("Member_Name",null,".blLblName");
			$.csCore.getValue("Orden_ClothingCategory",null,".blLblDisClothingName");
			$.csCore.getValue("Cash_FromNum",null,".blLblFromNum");
			$.csCore.getValue("Cash_ToNum",null,".blLblToNum");
			$.csCore.getValue("Cash_DiscountNum",null,".blLblDiscountNum");
			$.csCore.getValue("Common_Memo",null,".blLblMemo");
			$.csCore.getValue("Button_Edit",null,".blLbledit,.edit");
			$.csCore.getValue("Button_Remove",null,".blLbldelete,.delete");
			
		//	$.csCore.confirm($.csCore.getValue('Common_RemoveConfirm'), "$.csBlDeliveryDetailHList.confirmDeleteDeliveryDetail('" + deliveryId + "','"+ordenId+"','"+type+"')");
		}
};