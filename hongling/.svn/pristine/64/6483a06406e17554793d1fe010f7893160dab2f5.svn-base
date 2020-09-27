jQuery.csReceivingList={
	moduler : "Orden",
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
	fillClothing:function (){
		var datas = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getclothing'));
	    $.csControl.fillOptions('searchClothingID',datas , "ID" , "name", $.csCore.getValue("Common_All"));
	},
	Add:function (){
		$.csCore.loadModal($.csReceivingList.getPath()+'/pages/receiving/post.jsp',600,350,function(){$.csReceivingPost.init();});
	},
	list:function (pageIndex){
		var param =  $.csControl.getFormData('OrdenSearch');
		param = $.csControl.appendKeyValue(param,'pageindex',pageIndex);
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/receiving/getreceivings'),param);
		$.csCore.processList($.csReceivingList.moduler, data);
		if (pageIndex == 0) {
			$.csCore.initPagination($.csReceivingList.moduler + "Pagination", data.count, PAGE_SIZE, $.csReceivingList.list);
		}
		$.ReceivingCommon.bindLabel();
	},
	remove:function(){
		var removedIDs = $.csControl.getCheckedValue('chkRow');
		var url = $.csCore.buildServicePath('/service/receiving/removereceivings');
		$.csCore.removeData(url,removedIDs);
	},
	exportExcel:function(){
		var url = $.csCore.buildServicePath('/service/receiving/exportreceivings?formData=');
		url += $.csControl.getFormData('OrdenSearch');
		window.open(url);
	},
	openView:function (id){
		$.csCore.loadModal($.csReceivingList.getPath()+'/pages/orden/view.jsp',964,540,function(){$.csOrdenView.init(id);});
	},
	init:function(){
		$.ReceivingCommon.bindLabel();
		$.ReceivingCommon.bindEvent();
		$.csReceivingList.fillClothing();
		$.csReceivingList.list(0);
	}
};