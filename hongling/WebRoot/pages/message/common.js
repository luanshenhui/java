jQuery.csMessageCommon={
	bindLabel:function (){		
		$.csCore.getValue($.csCore.getDictResourceName(DICT_BACKEND_MENU_MY_MESSAGE),null,".list_search h1");
		$.csCore.getValue("Common_Keyword",null,".lblKeyword");
		$.csCore.getValue("Message_Title",null,".lblTitle");
		$.csCore.getValue("Message_PubDate",null,".lblPubDate");
		$.csCore.getValue("Message_PubMember",null,".lblPubMember");
		$.csCore.getValue("Message_Receiver",null,".lblReceiver");
		$.csCore.getValue("Message_ReadDate",null,".lblReadDate");
		$.csCore.getValue("Message_Content",null,".lblContent");
		$.csCore.getValue("Button_Search",null,"#btnSearch");
		$.csCore.getValue("Message_SendMessage",null,"#btnSendMessage");
		$.csCore.getValue("Button_Remove",null,"#btnRemove");
		$.csCore.getValue("Button_Cancel",null,"#btnCancel");
		$.csCore.getValue("Button_Submit",null,"#btnSubmit");
		$.csCore.getValue("Button_InboxMessage",null,"#btnInbox");
		$.csCore.getValue("Button_SentMessge",null,"#btnSentbox");
		},
	getMessageByID:function(id){
		var param = $.csControl.appendKeyValue("","id",id);
		return $.csCore.invoke($.csCore.buildServicePath('/service/message/getmessagebyid'),param);
	}
};