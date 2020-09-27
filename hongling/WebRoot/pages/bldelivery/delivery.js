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
jQuery.csOrdenDelivery={
	bindEvent:function (){
		$("#btnSaveDelivery").click($.csOrdenDelivery.save);
		$("#btnCancelDelivery").click($.csCore.close);
		
		// 获取默认发货日期，为当前日期后四个工作日
		var defaultDate = $.csCore.invoke($.csCore.buildServicePath("/service/delivery/getDefaultDeliveryDate"));
		$.csDate.datePicker("deliveryDate",defaultDate);
	},

	/**
	 * 初始化发货信息，绑定发货地址与快递公司
	 */
	initDeliveryInfo: function() {
		var current = $.csCore.getCurrentMember();
		var member = $.csCore.getMemberByID(current.ID);
		$.csOrdenDelivery.fillApplyDeliveryExpressCom($.csCore.getValue("Common_PleaseSelect","Member_Express"));
		if (member.countryCode=="US") {
			$(".state").show();
		} else {
			$(".state").hide();
		}
		//$.updateWithJSON(member);
	},
	// 填充快递公司
	fillApplyDeliveryExpressCom: function(initValue) {
		$.csControl.fillOptions("expressComId",$.csBlExpressComCommon.queryAll(),"ID","name",initValue);
	},
	/**
	 * 自动填充国家
	 */
	autoCompleteCountry: function() {
		var url = $.csCore.buildServicePath('/service/bldeliver/getcountriesbykeyword');
		$("#countryName").autocomplete(url, {
			multiple: false,
			dataType: "json",
			parse: function(data) {
				return $.map(data,
				function(row) {
					return {
						data: row,
						value: row.en,
						result: row.en
					};
				});
			}
			,
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
		});
	},
	/**
	 * 提交发货申请
	 */
	save:function(){
		if($.csOrdenDelivery.validate() == true){
			// 设置发货日期及所选订单
			var param = $.csControl.appendKeyValue("","date",$("#deliveryDate").val());
			param = $.csControl.appendKeyValue(param,"ordens",$.csControl.getCheckedValue('chkDeliveryOrden'));
			// 设置发货地址及快递公司
//			param = $.csControl.appendKeyValue(param,"address",$("#deliveryAddress").val());
			param = $.csControl.appendKeyValue(param,"countryName",$("#countryName").val());
			param = $.csControl.appendKeyValue(param,"countryCode",$("#countryCode").val());
			param = $.csControl.appendKeyValue(param,"city",$("#city").val());
			param = $.csControl.appendKeyValue(param,"division",$("#division").val());
			param = $.csControl.appendKeyValue(param,"divisionCode",$("#divisionCode").val());
			param = $.csControl.appendKeyValue(param,"addressLine1",$("#addressLine1").val());
			param = $.csControl.appendKeyValue(param,"addressLine2",$("#addressLine2").val());
			param = $.csControl.appendKeyValue(param,"postalCode",$("#postalCode").val());
			param = $.csControl.appendKeyValue(param,"expressComId", $("#expressComId").val());
			var data = $.csCore.invoke($.csCore.buildServicePath("/service/delivery/submitdelivery"),param);
			if(data == "OK"){
				$.csCore.alert($.csCore.getValue("Delivery_Success"));
				$.csOrdenDelivery.list();
				$.csBlDeliveryFList.list(0);
				$.csCore.close();
			} else {
				$.csCore.alert($.csCore.getValue("Delivery_Error"));
			}
		}
	},
	/**
	 * 验证
	 * @returns {Boolean}
	 */
	validate:function (){
		// 判断发货日期是否已选择
		if($.csValidator.checkNull("deliveryDate",$.csCore.getValue("Common_PleaseSelect","Delivery_Date"))){
			return false;
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
		
		// 验证是否已选择订单
		if($.csValidator.isNull($.csControl.getCheckedValue('chkDeliveryOrden'))){
			$.csCore.alert($.csCore.getValue("Common_PleaseSelect","Orden_Info"));
			return false;
		}
		
		// 设置用户所选发货日期
		var param = $.csControl.appendKeyValue("","date",$("#deliveryDate").val());
		
		// 设置用户所选订单
		param = $.csControl.appendKeyValue(param,"ordens",$.csControl.getCheckedValue('chkDeliveryOrden'));
		
		// 验证发货日期是否合法
		var retValue = $.csCore.invoke($.csCore.buildServicePath("/service/delivery/checkDeliveryDate"),param);
		if (retValue == 1) {
			$.csCore.alert($.csCore.getValue("Delivery_DateInvidBefore")+$.csCore.invoke($.csCore.buildServicePath("/service/delivery/getDefaultDeliveryDate")));
			return false;
		} else if (retValue == 2) {
			$.csCore.alert($.csCore.getValue("Delivery_DateInvidSunday"));
			return false;
		}
		
		// 验证用户所选的发货日期与最早发货日期
		// 自动计算发货日期并与用户所选日期进行比较
		var hintDate = $.csCore.invoke($.csCore.buildServicePath("/service/delivery/getHintDeliveryDate"),param);
		if ($("#deliveryDate").val() != hintDate) {
			$.csCore.alert($.csCore.getValue("Delivery_DateInvidEarly")+"("+hintDate+")"+$.csCore.getValue("Delivery_DateInvidAfter"));
			return false;
		}
		
		return true;
	},
	list:function (){
		var url = $.csCore.buildServicePath('/service/orden/getfinishedordens');
		var data = $.csCore.invoke(url);
		$.csCore.processList("DeliveryDetails", data);
		$.csOrdenDeliveryCommon.bindLabel();
	},
	init:function(){
		$.csOrdenDeliveryCommon.bindLabel();
		$.csOrdenDelivery.bindEvent();
		$.csOrdenDelivery.initDeliveryInfo();
		$.csOrdenDelivery.list();
		$.csOrdenDelivery.autoCompleteCountry();
		$.csOrdenDelivery.autoCompleteState();
		$.csOrdenDelivery.autoCompleteCity();
	}
};

jQuery.csOrdenDeliveryCommon={
		bindLabel:function (){
			$.csCore.getValue("Delivery_Date",null,".lblDeliveryDate");
			$.csCore.getValue("Delivery_Country",null,".lblDeliveryCountry");
			$.csCore.getValue("Delivery_City",null,".lblDeliveryCity");
			$.csCore.getValue("Delivery_AddressLine1",null,".lblDeliveryAddress1");
			$.csCore.getValue("Delivery_AddressLine2",null,".lblDeliveryAddress2");
			$.csCore.getValue("Delivery_PostalCode",null,".lblDeliveryPostalCode");
			$.csCore.getValue("Member_Express",null,".lblDeliveryExpressCom");
			
			$.csCore.getValue("Delivery_Info",null,"#delivery_form h1");
			$.csCore.getValue("Button_Submit",null,"#btnSaveDelivery");
			$.csCore.getValue("Button_Cancel",null,"#btnCancelDelivery");
			
			$.csCore.getValue("Orden_Code",null,".lblCode");
			$.csCore.getValue("Orden_ClothingCategory",null,".lblClothingCategory");
			$.csCore.getValue("Common_Tel",null,".lblTel");
			$.csCore.getValue("Customer_Name",null,".lblName");
			$.csCore.getValue("Fabric_Moduler",null,".lblFabric");
			$.csCore.getValue("Delivery_Division",null,".lblDeliveryState");
			$.csCore.getValue("Common_Status",null,".lblState");
		},
};