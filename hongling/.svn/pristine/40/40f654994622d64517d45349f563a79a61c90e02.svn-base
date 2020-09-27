jQuery.csCustomer={
	bindLabel:function (){
		$.csCore.getValue("Customer_No",null,".lblCustomerNo");
		$.csCore.getValue("Common_Customer",null,".lblName");
		$.csCore.getValue("Common_Gender",null,".lblGender");
		$.csCore.getValue("Common_Tel",null,".lblTel");
		$.csCore.getValue("Customer_Weight",null,".lblWeight");
		$.csCore.getValue("Customer_Height",null,".lblHeight");
		$.csCore.getValue("Customer_Email",null,".lblEmail");
		$.csCore.getValue("Customer_Address",null,".lblAddress");
		$.csCore.getValue("Customer_LtName",null,".lblLtName");
	},
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
	fillWeightUnit:function (){
	    $.csControl.fillOptions("weightUnitID",$.csCore.getDicts(DICT_CATEGORY_WEIGHTUNIT), "ID" , "name", "");
	},
	fillHeightUnit:function (){
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
		if($.csValidator.checkNotValidEmail("email",$.csCore.getValue("Common_EmailInvalid"))){
			return false; 
		}
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
		
		return true;
	},
	init:function(customer){
		$.csCustomer.bindLabel();
		$.csCustomer.bindEvent();
		$.csCustomer.autoCompleteCustomerName();
		$.csCustomer.fillGender();
		$.csCustomer.fillWeightUnit();
		$.csCustomer.fillHeightUnit();
		$.csCustomer.loadCustomer(customer);
	}
};
