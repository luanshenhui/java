jQuery.csBlViewOrdenList={
    moduler : "BlViewOrdenList",
	bindEvent:function (from){
		$.csDate.datePickerNull("pubDate");
		$.csDate.datePickerNull("pubToDate");
		$.csDate.datePickerNull("deliveryDate");
		$.csDate.datePickerNull("deliveryToDate");
		$.csDate.datePickerNull("dealDate");
		$.csDate.datePickerNull("dealToDate");
		$("#blBtnSearchOrdens").click(function(){$.csBlViewOrdenList.list(0);});
	},
	fillClothing:function(){
		var datas = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getclothing'));
	    $.csControl.fillOptions('searchClothingID',datas , "ID" , "name", $.csCore.getValue("Common_All"));
	},
	fillClient:function(){
		var param = $.csControl.appendKeyValue("","from","BlViewOrdenList");
		var datas = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getblordensclient'),param);
	    $.csControl.fillOptions('searchClientID',datas , "ID" , "name", $.csCore.getValue("Common_All"));
	},
	fillStatus:function (){
		var param =  $.csControl.getFormData('BlViewOrdenListSearch');
		var datas = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getstatusstatistic'), param);
	    $.csControl.fillOptions('searchStatus',datas , "ID" , "name", $.csCore.getValue("Common_All"));
	},
	list:function (pageIndex){
		var url = $.csCore.buildServicePath('/service/blorden/GetViewOrdens');
		var param =  $.csControl.getFormData("BlViewOrdenListSearch");
		param = $.csControl.appendKeyValue(param,"pageindex",pageIndex);
		var datas = $.csCore.invoke(url,param);
//		alert(JSON.stringify(datas));
	    $.csCore.processList($.csBlViewOrdenList.moduler, datas);
	    if (pageIndex == 0) {
	        $.csCore.initPagination($.csBlViewOrdenList.moduler + "Pagination", datas.count, PAGE_SIZE, $.csBlViewOrdenList.list);
	    }
	    $.csBlViewOrdenListCommon.bindLabel();
	},
	init:function(){
		$.csBlViewOrdenListCommon.bindLabel();
		$.csBlViewOrdenList.bindEvent();
		$.csBlViewOrdenList.fillClothing();
		$.csBlViewOrdenList.fillClient();
		$.csBlViewOrdenList.fillStatus();
		$.csBlViewOrdenList.list(0);
		
	}
};