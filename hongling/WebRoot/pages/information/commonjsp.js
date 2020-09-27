jQuery.csInformationCommon={
	bindLabel:function (){
		$.csCore.getValue($.csCore.getDictResourceName(DICT_BACKEND_MENU_INFORMATION_MANAGER),null,".list_search h1");
//		$.csCore.getValue("Common_Keyword",null,".lblKeyword");
//		$.csCore.getValue("Common_Title",null,".lblTitle");
//		$.csCore.getValue("Member_Group",null,".lblGroup");
//		$.csCore.getValue("Common_Category",null,".lblCategory");
//		$.csCore.getValue("Common_Content",null,".lblContent");
//		$.csCore.getValue("Common_Attachment",null,".lblAttachment");
//		$.csCore.getValue("Common_PubDate",null,".lblPubDate");
//		$.csCore.getValue("Button_Edit",null,".lblEdit");
//		$.csCore.getValue("Button_Edit",null,".edit");
//		$.csCore.getValue("Button_Search",null,"#btnSearch");
//		$.csCore.getValue("Button_Remove",null,"#btnRemoveInformation");
//		$.csCore.getValue("Button_Add",null,"#btnCreateInformation");
//		$.csCore.getValue("Button_Submit",null,"#btnSaveInformation");
//		$.csCore.getValue("Button_Cancel",null,"#btnCancelInformation");
	},
	getInformationByID:function(id){
		var param = $.csControl.appendKeyValue("","id",id);
		return  $.csCore.invoke($.csCore.buildServicePath('/service/information/getinformationbyid'),param);
	}
};