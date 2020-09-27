$(".expressComId2").change(function(){
	var selvalue = $(".expressComId2").find("option:selected").text();
	if(selvalue!='DHL'){
		document.getElementById("countryName").value='';
		document.getElementById("division").value='';
		document.getElementById("city").value='';
	}else{
		document.getElementById("countryName").value='United States Of America';
		document.getElementById("division").value='ARKANSAS';
		document.getElementById("city").value='JOHNSON';
	}

});
jQuery.csDeliverySetting={
	bindLabel:function (){
		$.csCore.getValue("Button_DeliverySetting",null,"#formSetting h1");
		$.csCore.getValue("Member_ApplyDeliveryType",null,".lblApplyDeliveryType");
		$.csCore.getValue("Member_ApplyDeliveryDays",null,".lblApplyDeliveryDays");
		$.csCore.getValue("Member_Express",null,".lblExpressCom");
		$.csCore.getValue("Delivery_Country",null,".lblApplyDeliveryCountry");
		$.csCore.getValue("Delivery_City",null,".lblApplyDeliveryCity");
		$.csCore.getValue("Delivery_AddressLine1",null,".lblApplyAddressLine1");
		$.csCore.getValue("Delivery_AddressLine2",null,".lblApplyAddressLine2");
		$.csCore.getValue("Delivery_PostalCode",null,".lblApplyPostalCode");
		$.csCore.getValue("Delivery_Division",null,".lblApplyDeliveryDivision");
		$.csCore.getValue("Common_Prompt",null,".lblHint");
		
		$.csCore.getValue("Button_Submit",null,"#btnSubmitSetting");
		$.csCore.getValue("Button_Cancel",null,"#btnCancelSetting");
	},
	bindEvent:function (){
		$("#btnSubmitSetting").click($.csDeliverySetting.submitSetting);
		$("#btnCancelSetting").click($.csCore.close);
	},
	loadSetting:function(){
		var current = $.csCore.getCurrentMember();
		var member = $.csCore.getMemberByID(current.ID);
		if(member.countryCode=="US") {
			$(".state").show();
		} else {
			$(".state").hide();
		}
		$.csDeliverySetting.fillApplyDeliveryExpressCom($.csCore.getValue("Common_PleaseSelect","Member_Express"));
	//	$.updateWithJSON(member);
		$.csDeliverySetting.fillApplyDeliveryDays(member.applyDeliveryDays);
		$.csDeliverySetting.changeDeliveryType();
	},
	/**
	 * 自动填充国家
	 */
	autoCompleteCountry: function() {
		var url = $.csCore.buildServicePath('/service/bldeliver/getcountriesbykeyword');
		$("#countryName").autocomplete(url, {
			multiple: false,
			dataType: "json",
			mustMatch: true, 
			parse: function(data) {
				return $.map(data,
				function(row) {
					return {
						data: row,
						value: row.en,
						result: row.en
					};
				});
			},
			formatItem: function(item) {
				return item.en + "(" + item.countryCode + ")";
			}
		}).result(function(e, data) {
			if(data.countryCode == "US") {
				$(".state").show();
			} else {
				$(".state").hide();
			}
			// 设置国家编码
			$("#countryCode").val(data.countryCode);
			// 设置国家名称
			$("#countryName").val(data.en);
		});
	},
	
	/**
	 * 自动填充州
	 */
	autoCompleteState: function() {
		var url = $.csCore.buildServicePath('/service/bldeliver/getstatesbykeyword');
		$("#division").autocomplete(url, {
			multiple: false,
			dataType: "json",
			mustMatch: true, 
			parse: function(data) {
				return $.map(data,
				function(row) {
					return {
						data: row,
						value: row.stateName,
						result: row.stateName
					};
				});
			}
			,
			formatItem: function(item) {
				return item.stateName + "(" + item.stateCode + ")";
			}
		}).result(function(e, data) {
			// 设置州编码
			$("#divisionCode").val(data.stateCode);
			// 设置州名称
			$("#division").val(data.stateName);
		});
	},
	
	/**
	 * 自动填充城市
	 */
	autoCompleteCity: function() {
		var url = $.csCore.buildServicePath('/service/bldeliver/getcitysbykeyword');
		$("#city").autocomplete(url, {
			multiple: false,
			dataType: "json",
			mustMatch: true, 
			extraParams: {
				'param1':function(){
					// 得到国家编码
					var countryCode = $("#countryCode").val();
					if (countryCode == "US") {
						return $("#divisionCode").val();
					} else {
						return $("#countryCode").val();
					}
				},
				'type':function() {
					// 得到国家编码
					var countryCode = $("#countryCode").val();
					if (countryCode == "US") {
						return "2";
					} else {
						return "1";
					}
				}},
			parse: function(data) {
				return $.map(data,
				function(row) {
					return {
						data: row,
						value: row.city,
						result: row.city
					};
				});
			},
			formatItem: function(item) {
				return item.city;
			}
		}).result(function(e, data) {
			// 设置城市
			$("#city").val(data.city);
			
//			var param = $.csControl.appendKeyValue("","countryCode",$("#countryCode").val());
//			param = $.csControl.appendKeyValue(param,"city",$("#city").val());
//			var url = $.csCore.buildServicePath('/service/bldeliver/getpostalCodesbykeyword');
//			var postalCodes = $.csCore.invoke(url, param);
//			$(".lblHint").show();
//			$("#lblHint").html(postalCodes);
		});
	},
	
	/**
	 * 获取邮政编码
	 */
	getPostalCodes: function() {
		// 判断发货国家是否填写
		if($.csValidator.checkNull("countryName",$.csCore.getValue("Common_Required","Delivery_Country"))){
			return false;
		}

		// 判断城市 是否填写
		if ($.csValidator.checkNull("city",$.csCore.getValue("Common_Required","Delivery_City"))) {
			return false;
		}
		
		// 得到国家编码
		var countryCode = $("#countryCode").val();
		
		// 得到城市
		var city = $("#city").val();
		
		var param = $.csControl.appendKeyValue("",'countryCode',countryCode);
		param = $.csControl.appendKeyValue(param,'city',city);
		
		// 根据国家、城市得到邮政编码
//		var data = $.csCore.invoke($.csCore.buildServicePath('/service/bldeliver/getpostalCodesbykeyword'),param);
	},
	
	/**
	 * 验证提交
	 * @returns {Boolean}
	 */
	validatePost:function (){
		// 得到发货类型
		var value = $.csControl.getRadioValue("applyDeliveryTypeID");
		// 如果为自动发货，验证发货周期是否已选择
		if (value == DICT_APPLY_DELIVERY_TYPE_AUTO) {
			// 得到第一个发货周期的值
			var firChkValue = $("input[type=checkbox]:checked").val(); 
			if (firChkValue==null || firChkValue=="null" || firChkValue==undefined || firChkValue=="undefined" || firChkValue=="") {
				$.csCore.alert($.csCore.getValue("Common_PleaseSelect","Member_ApplyDeliveryDays"));
				$("#lblApplyDeliveryDays").focus();
				return false;
			} 
		}
		
		// 判断发货国家是否填写
		if($.csValidator.checkNull("countryName",$.csCore.getValue("Common_Required","Delivery_Country"))){
			return false;
		}
		
		// 判断州是否填写
		if ($("#countryCode").val() == "US") {
			if($.csValidator.checkNull("division",$.csCore.getValue("Common_Required","Delivery_Division"))){
				return false;
			}
		}
		
		// 判断城市 是否填写
		if ($.csValidator.checkNull("city",$.csCore.getValue("Common_Required","Delivery_City"))) {
			return false;
		}
		
		// 判断地址1是否填写
		if ($.csValidator.checkNull("addressLine1",$.csCore.getValue("Common_Required","Delivery_AddressLine1"))) {
			return false;
		}
		
		// 判断邮政编码是否填写
		if ($.csValidator.checkNull("postalCode",$.csCore.getValue("Common_Required","Delivery_PostalCode"))) {
			return false;
		}
		
		// 验证快递公司是否已选择
		if($.csValidator.checkNull("expressComId",$.csCore.getValue("Common_PleaseSelect","Member_Express"))) {
			return false;
		}
		
		return true;
	},
	
	submitSetting:function (){
		var url = $.csCore.buildServicePath("/service/orden/submitsetting");
		if($.csDeliverySetting.validatePost() == true){
			var deliveryType= $.csControl.getRadioValue("applyDeliveryTypeID");
			if($.csCore.postData(url, "formSetting")){
				$.csBlDeliveryFList.initDelivery(deliveryType);
				$.csCore.close();
				$.csCore.alert($.csCore.getValue("Common_SaveSuccess"));
			}
		}
	},
	
	/**
	 * 获取发货周期（去掉周天）
	 */
	getApplyDeliveryDays: function() {
		var url = $.csCore.buildServicePath('/service/bldeliver/getApplyDeliveryDays');
		var data = $.csCore.invoke(url);
		return data;
	},
	
	fillDeliveryType:function (){
	    $.csControl.fillRadios("applyDeliveryTypeIDContainer",$.csCore.getDicts(DICT_CATEGORY_APPLY_DELIVERY_TYPE), "applyDeliveryTypeID","ID" , "name");
	    $("#applyDeliveryTypeIDContainer input").click($.csDeliverySetting.changeDeliveryType);
	    $.csDeliverySetting.changeDeliveryType();
	},
	changeDeliveryType:function(){
		var value = $.csControl.getRadioValue("applyDeliveryTypeID");
		if(value == DICT_APPLY_DELIVERY_TYPE_AUTO){
			$(".auto").show();
		}else{
			$(".auto").hide();
		}
	},
	fillApplyDeliveryDays:function (initValue){
//		$.csControl.fillChecks('applyDeliveryDaysContainer',$.csCore.getDicts(DICT_CATEGORY_APPLY_DELIVERY_DAYS), "applyDeliveryDays", "ID" , "name", initValue);
		$.csControl.fillChecks('applyDeliveryDaysContainer',$.csDeliverySetting.getApplyDeliveryDays(), "applyDeliveryDays", "ID" , "name", initValue);
	},
	// 填充快递公司
	fillApplyDeliveryExpressCom: function(initValue) {
		$.csControl.fillOptions("expressComId",$.csBlExpressComCommon.queryAll(),"ID","name",initValue);
	},
	init:function(){
		$.csDeliverySetting.bindLabel();
		$.csDeliverySetting.bindEvent();
		$.csDeliverySetting.fillDeliveryType();
		$.csDeliverySetting.fillApplyDeliveryDays();
		$.csDeliverySetting.loadSetting();
		$.csDeliverySetting.autoCompleteCountry();
		$.csDeliverySetting.autoCompleteState();
		$.csDeliverySetting.autoCompleteCity();
		$.csDeliverySetting.autoCompletePostalCode();
	}
};