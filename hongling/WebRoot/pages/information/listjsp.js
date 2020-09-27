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
	// js获取项目根路径，如： http://localhost:8080/hongling
	getPath : function getRootPath() {
		// 获取当前网址，如：  http://localhost:8080/hongling/orden/meun.jsp
		var curWwwPath = window.document.location.href;
		// 获取主机地址之后的目录，如： uimcardprj/share/meun.jsp
		var pathName = window.document.location.pathname;
		var pos = curWwwPath.indexOf(pathName);
		// 获取主机地址，如： http://localhost:8080
		var localhostPaht = curWwwPath.substring(0, pos);
		// 获取带"/"的项目名，如：/hongling
		var projectName = pathName.substring(0,
				pathName.substr(1).indexOf('/') + 1);
		return (localhostPaht + projectName);
	},
	openPost:function (id){
		$.csCore.loadModal('../information/post.jsp',980,500,function(){$.csInformationPost.init(id);});
	},
	openView:function (id){
		$.csCore.loadModal($.csInformationList.getPath()+'/pages/information/view.jsp',800,500,function(){$.csInformationView.init(id);});
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
		$.csInformationList.bindEvent();
		$.csInformationList.list(0);
	}
};