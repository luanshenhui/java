jQuery.csCustomer={
	bindEvent:function (){
		$("#height").blur($.csCustomer.checkHeight);
	},
	checkHeight:function(){
		if($("#heightUnitID").val()==DICT_CM){
			if($("#height").val()<139 || $("#height").val()>230){
				$.csCore.alert($.csCore.getValue("Common_Height"));
				$("#height").val("");
			}
		}else{
			if($("#height").val()<54.7 || $("#height").val()>82.6){
				$.csCore.alert($.csCore.getValue("Common_Height_Inch"));
				$("#height").val("");
			}
		}
	},
	fillGender:function (){
	    $.csControl.fillOptions("genderID",$.csCore.getDicts(DICT_CATEGORY_GENDER), "ID" , "name", "");
	},
	fillWeightUnit:function (customer){
	    $.csControl.fillOptions("weightUnitID",$.csCore.getDicts(DICT_CATEGORY_WEIGHTUNIT), "ID" , "name", "");
	},
	fillHeightUnit:function (customer){
	    $.csControl.fillOptions("heightUnitID",$.csCore.getDicts(DICT_CATEGORY_HEIGHTUNIT), "ID" , "name", "");
	},
	loadCustomer:function (customer){
		if(!$.csValidator.isNull(customer)){
			$.updateWithJSON(customer);
			$("#userNo").val(customer.customerOrdenID);
		}else{
			$.updateWithJSON(customer);
		}
	},
	getTempCustomer:function (){
		return $.csCore.invoke($.csCore.buildServicePath('/service/customer/gettempcustomer'));
	},
	autoCompleteCustomerName:function (){
		var url = $.csCore.buildServicePath('/service/customer/getcustomerbykeyword');
		$("#name").autocomplete(url, {
			multiple : false,
			dataType : "json",
			parse : function(data) {
				return $.map(data, function(row) {
					return {
						data : row,
						value : row.ID,
						result : row.name
					};
				});
			},
			formatItem : function(item) {
				return item.name+"("+item.tel+")";  
			}
		}).result(function(e, data) {
			$.updateWithJSON(data);
		});
	},
	validate:function (){
		if($.csValidator.checkNull("name",$.csCore.getValue("Common_Required","Customer_Name"))){
			return false;
		}
		if($("#name").val().replace(/[ ]/g,"") == ""){//去除空格
			$.csCore.alert($.csCore.getValue("Common_Required","Customer_Name"));
			return false;
		}
		/*if($.csValidator.checkNull("height",$.csCore.getValue("Common_Required","Customer_Height"))){
			return false;
		}*/
		/*if($.csValidator.checkNotValidEmail("email",$.csCore.getValue("Common_EmailInvalid"))){
			return false; 
		}*/
		if($("#heightUnitID").val()==DICT_CM){
			if($("#height").val()<139 || $("#height").val()>230){
				$.csCore.alert($.csCore.getValue("Common_Height"));
				$("#height").val("");
				return false; 
			}
		}else{
			if($("#height").val()<54.7 || $("#height").val()>82.6){
				$.csCore.alert($.csCore.getValue("Common_Height_Inch"));
				$("#height").val("");
				return false; 
			}
		}
		
		var url_zh =window.location+"";
		if(url_zh.indexOf("www.rcmtm.cn")>-1 && $.csValidator.checkNull("tel",$.csCore.getValue("Common_Required","Common_Tel"))){
			return false;
		}
		if(url_zh.indexOf("www.rcmtm.cn")>-1 && (!$("#tel").val().match(/^1[3|4|5|8][0-9]\d{4,8}$/) || $("#tel").val().length != 11)){
			$.csCore.alert("电话格式不正确");
			return false;
		} 
		if ($("#memos").val().length > 200) {
			$("#memos").val($("#memos").val().substring(0, 200));
		}
		
		return true;
	},
	init:function(customer){
		$.csCustomer.autoCompleteCustomerName();
		$.csCustomer.loadCustomer(customer);
	},
	clearNoNum:function(obj) {  
	    obj.value = obj.value.replace(/[^\d.]/g, "");  
	    obj.value = obj.value.replace(/^\./g, "");  
	    obj.value = obj.value.replace(/\.{2,}/g, ".");  
	    obj.value = obj.value.replace(".", "$#$").replace(/\./g, "").replace("$#$", ".");  
	}
};
