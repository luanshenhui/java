jQuery.csInformationList={
    moduler : "Information",
	checkAccsss:function(){
		if($.csCore.isAdmin() == false){
			$("#btnCreateInformation,#btnRemoveInformation,.edit,.lblEdit,.list_result .check").hide();
			$(".edit").parent().hide();
		}
	},
	bindEvent:function (){
		$.csCore.pressEnterToSubmit('keyword','btnSearch');
		$("#btnSearch").click(function(){$.csInformationList.list(0);});
		$("#btnRemoveInformation").click($.csInformationList.remove);
		$("#btnCreateInformation").click(function(){$.csInformationList.openPost(null);});
	},
	openPost:function (id){
		$.csCore.loadModal('../information/post.htm',980,500,function(){$.csInformationPost.init(id);});
	},
	openView:function (id){
		$.csCore.loadModal('../information/view.htm',800,500,function(){$.csInformationView.init(id);});
	},
	remove:function (){
		var removedIDs = $.csControl.getCheckedValue('chkRow');
		var url = $.csCore.buildServicePath('/service/information/removeinformations');
		$.csCore.removeData(url,removedIDs);
	},
	list:function (pageIndex){
		var param = $.csControl.appendKeyValue("","pageindex",pageIndex);
		param = $.csControl.appendKeyValue(param,"keyword",$('#keyword').val());
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/information/getinformations'),param);
	    $.csCore.processList($.csInformationList.moduler, data);
	    if (pageIndex == 0) {
	        $.csCore.initPagination($.csInformationList.moduler + "Pagination", data.count, PAGE_SIZE, $.csInformationList.list);
	    }
	    $.csInformationCommon.bindLabel();
	    $.csInformationList.checkAccsss();
	},
	init:function(){
		$.csInformationCommon.bindLabel();
		$.csInformationList.bindEvent();
		$.csInformationList.list(0);
	}
};