jQuery.csInformationPost={
	bindEvent:function (){
		$("#btnSaveInformation").click($.csInformationPost.save);
		$("#btnCancelInformation").click($.csCore.close);
	},
	fillCategory:function (){
	    $.csControl.fillOptions('categoryID',$.csCore.getDicts(DICT_CATEGORY_INFORMATION_CATEGORY), "ID" , "name", $.csCore.getValue("Common_Required","Common_Category"));
	},
	fillGroup:function (initValue){
		$.csControl.fillChecks('divGroup',$.csCore.getDicts(DICT_CATEGORY_MEMBER_GROUP), "accessGroupIDs", "ID" , "name", initValue);
	},
	validate:function (){
		if($.csValidator.checkNull("title",$.csCore.getValue("Common_Required","Common_Title"))){
			return false;
		}
		return true;
	},
	save:function (){
		if($.csInformationPost.validate()){
		    if($.csCore.postData($.csCore.buildServicePath('/service/information/saveinformation'), 'form')){
		    	$.csInformationList.list(0);
		    	$.csCore.close();
		    }
		}
	},
	init:function(id){
		$.csInformationPost.bindEvent();
		$('#form').resetForm();
		$.csInformationPost.fillCategory();
		$.csInformationPost.fillGroup("");
		
		if($.csValidator.isNull(id)){
			$.csCore.getValue("Common_Add","Information_Moduler","#form h1");
		}else{
			$.csCore.getValue("Common_Edit","Information_Moduler","#form h1");
			var information = $.csInformationCommon.getInformationByID(id);
			$.updateWithJSON(information);
			$.csInformationPost.fillGroup(information.accessGroupIDs);
		}
		$.csCore.loadEditor('content');
		$.csCore.loadUpload("attachmentIDs");
	}
};