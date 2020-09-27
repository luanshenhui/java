jQuery.csRealmNamePost={
	bindEvent:function (){
		$("#btnSaveRealm").click($.csRealmNamePost.save);
		$("#btnCancelRealm").click($.csCore.close);
	},
	save:function (){
	    if($.csCore.postData($.csCore.buildServicePath('/service/realmname/saverealmname'), 'form')){
	    	$.csRealmNameList.list(0);
	    	$.csCore.close();
	    }
	},
	init:function(id){
		$.csRealmNameCommon.bindLabel();
		$.csRealmNamePost.bindEvent();
		$('#form').resetForm();
		if($.csValidator.isNull(id)){
			$.csCore.getValue("Common_Add","RealmName_Moduler","#form h1");
		}else{
			$.csCore.getValue("Common_Edit","RealmName_Moduler","#form h1");
			var realmname = $.csRealmNameCommon.getRealmNameByID(id);
			$.updateWithJSON(realmname);
		}
	}
};