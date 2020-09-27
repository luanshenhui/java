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
		$('#blshougongduizhang').click(function(){$.csBlDealList.shougongduizhang();});
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
	shougongduizhang:function(){
		var param=$.csBlDealList.buildSearchParam();
		//alert(param);
		var url = $.csCore.buildServicePath('/servlet/blcash/ShougongBlExportDealList?formData='+param);
		window.open(url);
		
	}
	,
	buildSearchParam:function(){
		var param = $.csControl.appendKeyValue("","keyword",$('#blKeyword').val());
		param = $.csControl.appendKeyValue(param,"fromDate",$('#blFromDate').val());
		param = $.csControl.appendKeyValue(param,"toDate",$('#blToDate').val());
		return param;
	}
	,
	/**
	 * 导出对账单
	 */
	duizhangdan:function(){
		var param =  $.csControl.getFormData("BlDealListSearch");
//		alert(param);
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