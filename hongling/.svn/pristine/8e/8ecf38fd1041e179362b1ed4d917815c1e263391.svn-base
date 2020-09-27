jQuery.csBlDeliveryFList={
	moduler : "BlDeliveryF",
	bindEvent:function (){
		$.csDate.datePicker("blFromDate", $.csDate.getLastYear());
		$.csDate.datePicker("blToDate");
		$.csDate.datePickerNull("blDealDate");
		$.csDate.datePickerNull("blDealToDate");
		$.csCore.pressEnterToSubmit('blKeyword','blBtnSearch');
		$("#blBtnSearch").click(function(){$.csBlDeliveryFList.list(0);});
		
		// 判断用户的发货类型
		var current = $.csCore.getCurrentMember();
		var member = $.csCore.getMemberByID(current.ID);
		// 如果是自动发货，则将申请发货按钮隐藏
		if (member.applyDeliveryTypeID == DICT_APPLY_DELIVERY_TYPE_AUTO) {
			$("#blBtnDelivery").hide();
		// 绑定事件
		} else {
			$("#blBtnDelivery").click(function(){$.csCore.loadModal('../bldelivery/delivery.htm',760,440,function(){$.csOrdenDelivery.init();});});
		}
		
		$("#blBtnDeliverySetting").click(function(){$.csCore.loadModal('../bldelivery/setting.htm',760,440,function(){$.csDeliverySetting.init();});});
		$("#blBtnDeliveryDetail").click(function(){$.csCore.loadModal('../bldelivery/BlDeliveryDetailF.htm',760,440,function(){$.csBlDeliveryDetailFList.init();});});
		$("#blBtnExportOrdens").click($.csBlDeliveryFList.exportOrdens);
	},
	/**
	 * 填充客户
	 */
	fillClient:function (){
		var param = $.csControl.appendKeyValue("","from","BlDeliveryFList");
		var datas = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getblordensclient'),param);
	    $.csControl.fillOptions('blSearchClientID',datas , "ID" , "name", $.csCore.getValue("Common_All"));
	},
	fillClothing:function (){
		var datas = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getclothing'));
	    $.csControl.fillOptions('blSearchClothingID',datas , "ID" , "name", $.csCore.getValue("Common_All"));
	},
	/**
	 * 填充订单状态
	 */
	fillStatus:function (blSearchStatusID){
		var param =  $.csControl.getFormData('BlDeliveryFSearch');
		var datas = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getblstatusstatistic'), param);
	    $.csControl.fillOptions('blSearchStatusID',datas , "ID" , "name", $.csCore.getValue("Common_All"));
	    $("#blSearchStatusID").val(blSearchStatusID);
	},
	list:function (pageIndex){
		var param =  $.csControl.getFormData('BlDeliveryFSearch');
		param = $.csControl.appendKeyValue(param,'pageindex',pageIndex);
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getblordens'),param);
		$.csCore.processList($.csBlDeliveryFList.moduler, data);
		if (pageIndex == 0) {
			$.csCore.initPagination($.csBlDeliveryFList.moduler + "Pagination", data.count, PAGE_SIZE, $.csBlDeliveryFList.list);
		}
		$.csBlDeliveryFCommon.bindLabel();
		var blSearchStatusID = $("#blSearchStatusID").val();
		$.csBlDeliveryFList.fillStatus(blSearchStatusID);
	},
	
	/**
	 * 导出订单
	 */
	exportOrdens: function() {
		var url = $.csCore.buildServicePath('/service/delivery/exportordens?formData=');
		url += $.csControl.getFormData('BlDeliveryFSearch');
		window.open(url);
	},
	
	/**
	 * 根据发货类型设置申请发货按钮是否可用
	 * @param deliveryType 发货类型
	 */
	initDelivery: function(deliveryType) {
		// 自动发货
		if (deliveryType==DICT_APPLY_DELIVERY_TYPE_AUTO) {
			// 移除绑定事件
			$("#blBtnDelivery").unbind("click");
			$("#blBtnDelivery").hide();
		} else {
			$("#blBtnDelivery").show();
			// 移除绑定事件
			$("#blBtnDelivery").unbind("click");
			// 绑定事件
			$("#blBtnDelivery").click(function(){$.csCore.loadModal('../bldelivery/delivery.htm',760,440,function(){$.csOrdenDelivery.init();});});
		}
	},
	init:function(){
		$.csBlDeliveryFCommon.bindLabel();
		$.csBlDeliveryFList.bindEvent();
		$.csBlDeliveryFList.fillClothing();
		$.csBlDeliveryFList.fillClient();
		$.csBlDeliveryFList.fillStatus(-1);
		$.csBlDeliveryFList.list(0);
	}
};