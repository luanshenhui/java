jQuery.csFabricConsumePost={
	bindEvent:function (username){
		$("#btnConsumeSubmit").click(function(){$.csFabricConsumePost.saveConsume(username);});
		$("#btnConsumeCancel").click($.csCore.close);
	},
	saveConsume:function (username){
		if($.csFabricConsumePost.validate()){
		    if($.csCore.postData($.csCore.buildServicePath('/service/member/savefabricconsume'), 'form_consume')){
		    	$.csCore.close();
		    }
	    }
		// 刷新列表页面
		$.csFabricConsume.list(0,username);
	},
	
	validate:function (){
		if($.csValidator.checkNull("sort",$.csCore.getValue("Common_Required","Common_Category"))){
			return false;
		}
		if($.csValidator.checkNull("fabricsize",$.csCore.getValue("Common_Required","Common_FabricSize"))){
			return false;
		}
		return true;
	},
	fillClothing:function (){
		var datas = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getclothing'));
	    $.csControl.fillOptions('sort',datas , "ecode" , "name", $.csCore.getValue("Common_All"));
	},
	init:function(username){
		$("#username").val(username);
		$.csFabricConsumePost.bindEvent(username);
		$.csFabricConsumePost.fillClothing();
	},
};