jQuery.csBlDiscountList={
    moduler : "BlDiscountList",
	bindEvent:function (memberid){
		$("#blBtnSearchMemberDiscount").click(function(){$.csBlDiscountList.list(id,0);});
		$("#blBtnAddMemberDiscount").click(function(){$.csBlDiscountList.openPost(memberid);});
	},
	openPost:function(memberid,id){
		$.csCore.loadModal('../bldiscount/BlDiscount.jsp',400,240,function(){$.csBlDiscount.init(memberid,id);});
	},
	remove:function (memberid,id){
		var url = $.csCore.buildServicePath('/service/bldiscount/RemoveDiscount');
		var param = $.csControl.appendKeyValue("","ID",id);
		var data = $.csCore.invoke(url,param);
		if (data.toUpperCase() == "OK"){
			$.csBlDiscountList.list(memberid,0);
		}
	},
	list:function (id,pageIndex){
		var url = $.csCore.buildServicePath('/service/bldiscount/GetDiscounts');
		var param =  $.csControl.getFormData("BlDiscountListSearch");
		param = $.csControl.appendKeyValue(param,"pageindex",pageIndex);
		param = $.csControl.appendKeyValue(param,"memberid",id);
		//alert(JSON.stringify(param));
		var datas = $.csCore.invoke(url,param);
	    $.csCore.processList($.csBlDiscountList.moduler, datas);
	    if (pageIndex == 0) {
	        $.csCore.initPagination($.csBlDiscountList.moduler + "Pagination", datas.count, PAGE_SIZE, $.csBlDiscountList.list);
	    }
	    $.csBlDiscountListCommon.bindLabel();
	},
	init:function(memberid){
		$.csBlDiscountListCommon.bindLabel();
		$.csBlDiscountList.bindEvent(memberid);
		$.csBlDiscountList.list(memberid,0);
	}
};