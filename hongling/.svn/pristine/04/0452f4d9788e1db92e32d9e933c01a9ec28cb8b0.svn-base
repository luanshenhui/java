jQuery.csBlDealList={
    moduler : "BlDealList",
	bindEvent:function (){
		$.csDate.datePickerNull("blFromDate");
		$.csDate.datePickerNull("blToDate");
		$.csCore.pressEnterToSubmit('blKeyword','blBtnSearch');
		$("#blBtnExportCash").click($.csBlDealList.exportCash);
		$("#blBtnSearch").click(function(){$.csBlDealList.list(0);});
		$("#blBtnDuizhangdan").click($.csBlDealList.duizhangdan);
		$("#blBtnAdd").click($.csBlDealList.add);
	},
	list:function (pageIndex){
		var url = $.csCore.buildServicePath('/service/blcash/GetDeals');
		var param =  $.csControl.getFormData("BlDealListSearch");
		param = $.csControl.appendKeyValue(param,"pageindex",pageIndex);
		var datas = $.csCore.invoke(url,param);
	    $.csCore.processList($.csBlDealList.moduler, datas);
	    if (pageIndex == 0) {
	        $.csCore.initPagination($.csBlDealList.moduler + "Pagination", datas.count, PAGE_SIZE, $.csBlDealList.list);
	    }
	    $.csBlDealListCommon.bindLabel();
	},
	exportCash:function(){
		var param =  $.csControl.getFormData("BlDealListSearch");
		var url = $.csCore.buildServicePath("/servlet/blcash/BlExportDealList?formData=");
		window.open(url+param);
	},
	/**
	 * 导出对账单
	 */
	duizhangdan:function(){
		var param =  $.csControl.getFormData("BlDealListSearch");
		var url = $.csCore.buildServicePath("/servlet/blcash/BlExportStatement?formData=");
		
		window.open(url+param);
	},
	/**
	 * 新增页面
	 */
	add:function(){
		$.csCore.loadModal('../blcash/BlAddDeal.htm',500,300,function(){$.csBlAddDeal.init($("#blcashid").val(),$("#blmemberid").val());});
	},
	init:function(from,blcashid,blmemberid){
		if(!$.csValidator.isNull(from) && from=='front'){
			$("#blBtnAdd").hide();
		}
		$("#from").val(from);
		if (!$.csValidator.isNull(blcashid)){
			$("#blcashid").val(blcashid);
		}
		if (!$.csValidator.isNull(blmemberid)){
			$("#blmemberid").val(blmemberid);
		}
		$.csBlDealListCommon.bindLabel();
		$.csBlDealList.bindEvent();
		$.csBlDealList.list(0);
	}
};