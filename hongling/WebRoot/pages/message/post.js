jQuery.csMessagePost={
	bindEvent:function (){
		$("#btnSubmit").click($.csMessagePost.save);
		$("#btnCancel").click($.csCore.close);
		$("#receiverTexts").click($.csMessagePost.pickUser);
	},
	save:function (){
	    if($.csCore.postData($.csCore.buildServicePath('/service/message/savemessage'), 'form')){
	    	$.csMessageList.list(0);
	    	$.csCore.close();
	    }
	},
	pickUser: function () {
        $.csCore.pickUser('receiverID', 'receiverTexts', true);
    },
	init:function(id){
		$.csMessageCommon.bindLabel();
		$.csMessagePost.bindEvent();
		//$.csCore.autoCompleteUsername("username",true);
	}
};