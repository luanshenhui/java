jQuery.csBlMemberPriceList={
    moduler : "BlMemberPriceList",
	bindEvent:function (from){
		$("#blBtnSearchMemberPrice").click(function(){$.csBlMemberPriceList.list(0);});
	},
	list:function (pageIndex){
		var url = $.csCore.buildServicePath('/service/member/getmembers');
		var param =  $.csControl.getFormData("BlMemberPriceListSearch");
		param = $.csControl.appendKeyValue(param,"pageindex",pageIndex);
		param = $.csControl.appendKeyValue(param,"from","caiwu");
		var datas = $.csCore.invoke(url,param);
	    $.csCore.processList($.csBlMemberPriceList.moduler, datas);
	    if (pageIndex == 0) {
	        $.csCore.initPagination($.csBlMemberPriceList.moduler + "Pagination", datas.count, PAGE_SIZE, $.csBlMemberPriceList.list);
	    }
	    $.csBlMemberPriceListCommon.bindLabel();
	},
	init:function(){
		$.csBlMemberPriceListCommon.bindLabel();
		$.csBlMemberPriceList.bindEvent();
		$.csBlMemberPriceList.list(0);
	}
};