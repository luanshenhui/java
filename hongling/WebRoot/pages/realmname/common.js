jQuery.csRealmNameCommon={
	bindLabel:function (){
		$.csCore.getValue("Common_Keyword",null,".lblKeyword");
		$.csCore.getValue("Common_Title",null,".lblTitle");
		$.csCore.getValue("Common_Client",null,".lblCustomerName");
		$.csCore.getValue("Realm_Name",null,".lblRealmName");
		$.csCore.getValue("Button_Edit",null,".lblEdit");
		$.csCore.getValue("Button_Edit",null,".edit");
		
		$.csCore.getValue("Button_Search",null,"#btnSearch");
		$.csCore.getValue("Button_Remove",null,"#btnRemoveRealm");
		$.csCore.getValue("Button_Add",null,"#btnCreateRealm");
		$.csCore.getValue("Button_Submit",null,"#btnSaveRealm");
		$.csCore.getValue("Button_Cancel",null,"#btnCancelRealm");
	},
	getRealmNameByID:function(id){
		var param = $.csControl.appendKeyValue("","id",id);
		return  $.csCore.invoke($.csCore.buildServicePath('/service/realmname/getrealmnamebyid'),param);
	}
};