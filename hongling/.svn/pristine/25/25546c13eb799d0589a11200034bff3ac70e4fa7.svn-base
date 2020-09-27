jQuery.csBlDealItemList={
    moduler : "BlDealItemList",
	bindEvent:function (){
		$.csCore.pressEnterToSubmit('blKeyword','blBtnSearch');
		$("#blBtnSearchDealItem").click(function(){$.csBlDealItemList.list(0);});
		$("#blBtnAddDealItem").click($.csBlDealItemList.openPost);
	},
	openPost:function(id){
		$.csCore.loadModal('../blcash/BlDealItem.htm',400,200,function(){$.csBlDealItem.init(id);});
	},
	list:function (pageIndex){
		var url = $.csCore.buildServicePath('/service/blcash/GetDealItems');
		var param =  $.csControl.getFormData("BlDealItemListSearch");
		param = $.csControl.appendKeyValue(param,"pageindex",pageIndex);
		param = $.csControl.appendKeyValue(param,"from","BlDealItemList.js");
		//alert(JSON.stringify(param));
		var datas = $.csCore.invoke(url,param);
	    $.csCore.processList($.csBlDealItemList.moduler, datas);
	    if (pageIndex == 0) {
	        $.csCore.initPagination($.csBlDealItemList.moduler + "Pagination", datas.count, PAGE_SIZE, $.csBlDealItemList.list);
	    }
	    $.csBlDealItemListCommon.bindLabel();
	},
	init:function(){
		$.csBlDealItemListCommon.bindLabel();
		$.csBlDealItemList.bindEvent();
		$.csBlDealItemList.list(0);
	}
};