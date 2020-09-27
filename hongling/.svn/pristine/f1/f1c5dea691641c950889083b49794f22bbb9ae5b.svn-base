jQuery.csRealmNameList={
    moduler : "RealmName",
	checkAccsss:function(){
		if($.csCore.isAdmin() == false){
			$("#btnCreateRealm,#btnRemoveRealm,.edit,.lblEdit,.list_result .check").hide();
			$(".edit").parent().hide();
		}
	},
	bindEvent:function (){
		$.csCore.pressEnterToSubmit('keyword','btnSearch');
		$("#btnSearch").click(function(){$.csRealmNameList.list(0);});
		$("#btnRemoveRealm").click($.csRealmNameList.remove);
		$("#btnCreateRealm").click(function(){$.csRealmNameList.openPost(null);});
	},
	openPost:function (id){
		$.csCore.loadModal('../realmname/post.htm',450,200,function(){$.csRealmNamePost.init(id);});
	},
	openView:function (id){
		$.csCore.loadModal('../realmname/view.htm',450,200,function(){$.csRealmNameView.init(id);});
	},
	remove:function (){
		var removedIDs = $.csControl.getCheckedValue('chkRow');
		var url = $.csCore.buildServicePath('/service/realmname/removerealmnames');
		$.csCore.removeData(url,removedIDs);
	},
	list:function (pageIndex){
		var param = $.csControl.appendKeyValue("","pageindex",pageIndex);
		param = $.csControl.appendKeyValue(param,"keyword",$('#keyword').val());
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/realmname/getrealmnames'),param);
	    $.csCore.processList($.csRealmNameList.moduler, data);
	    if (pageIndex == 0) {
	        $.csCore.initPagination($.csRealmNameList.moduler + "Pagination", data.count, PAGE_SIZE, $.csRealmNameList.list);
	    }
	    $.csRealmNameCommon.bindLabel();
	    $.csRealmNameList.checkAccsss();
	},
	init:function(){
		$.csRealmNameCommon.bindLabel();
		$.csRealmNameList.bindEvent();
		$.csRealmNameList.list(0);
	}
};