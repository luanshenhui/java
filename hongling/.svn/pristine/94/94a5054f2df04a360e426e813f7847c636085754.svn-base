jQuery.csMemberPost={
	bindEvent:function (){
		$("#btnSaveMember").click($.csMemberPost.save);
		$("#btnCancelMember").click($.csCore.close);
		$("#parentName").click($.csMemberPost.pickUser);
		$("#username").blur($.csMemberPost.checkUser);
		$("#noticeNum").click($.csMemberPost.setPriceUnit);
	},
	blDiscountList:function(memberid){
		$.csCore.loadModal('../bldiscount/BlDiscountList.htm',800,500,function(){$.csBlDiscountList.init(memberid);});
	},
    setPriceUnit:function(){
    	var moneySignID = $("#moneySignID").val();
    	var moneySignName=$.csCore.getValue("Dict_"+$("#moneySignID").val());
    	$("#tip_noticeUnit").html(moneySignName);
    	$("#tip_stopUnit").html(moneySignName);
    	if (moneySignID==10360){
    		if ($("#noticeNum").val().length==0){
    			$("#noticeNum").val('2000');
    		}
    		if ($("#stopNum").val().length==0){
    			$("#stopNum").val('1000');
    		}
    	}else if(moneySignID==10361){
    		if ($("#noticeNum").val().length==0){
    			$("#noticeNum").val('10000');
    		}
    		if ($("#stopNum").val().length==0){
    			$("#stopNum").val('5000');
    		}
    	}
    }, 
	fillMoneySign:function (){
	    $.csControl.fillOptions('moneySignID',$.csCore.getDicts(DICT_CATEGORY_MONEYSIGN), "ID" , "name", "");
	},
	fillPayType:function (){
	    $.csControl.fillOptions('payTypeID',$.csCore.getDicts(DICT_CATEGORY_PAYTYPE), "ID" , "name", $.csCore.getValue("Common_PleaseSelect","Member_PayType"));
	},
	fillMTO:function (){
	    $.csControl.fillOptions('isMTO',$.csCore.getDicts(DICT_CATEGORY_BOOL), "ID" , "name", $.csCore.getValue("Common_PleaseSelect","Member_Mto"));
	},
	fillHomePage:function (){
	    $.csControl.fillOptions('homePage',$.csCore.getDicts(DICT_CATEGORY_HOMEPAGE), "ID" , "name", $.csCore.getValue("Common_PleaseSelect","Member_HomePage"));
	},
	fillExpress:function (){
		var express = "<option value='-1'>" + $.csCore.getValue("Common_PleaseSelect","Member_Express") + "</option>";
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/blexpresscom/getAllexpresscoms'));
		for(var i=0;i<data.length;i++){
			express += "<option value='"+ data[i].ID +"'>" + data[i].name + "</option>";
		}
		$("#expressComId").html(express);
	},
	/**
	 * 填充快递付款方式
	 */
	fillShippingPayType: function() {
		 $.csControl.fillOptions('shippingPaymentType',$.csCore.getDicts(DICT_CATEGORY_SHIPPING_PAY_TYPE), "ID" , "name", $.csCore.getValue("Common_PleaseSelect","Member_ShiperPayType"));
	},
	/**
	 * 填充经营单位
	 */
	fillBusinessUnit: function() {
		$.csControl.fillOptions('businessUnit',$.csCore.getDicts(DICT_CATEGORY_BUSINESS_UNIT), "ID" , "name", $.csCore.getValue("Common_PleaseSelect","Member_BusinessUnit"));
	},
	save:function (){
		if($.csMemberPost.validate()){
	        var formData = $.csControl.getFormData('form');
	        var data = $.csCore.invoke($.csCore.buildServicePath('/service/member/savemember'), formData);
	        if (!$.csValidator.isNull(data)) {
	            if (data.toUpperCase() == "OK") {
	                $('#form').resetForm();
			    	$.csMemberList.list(0);
			    	$.csCore.close();
	            }
	            // 大B账户
	            else {
			    	$.csMemberList.list(0);
			    	$.csCore.close();
			    	$.csMemberPost.blDiscountList(data);
	            }
	        }else{
	        	$.csCore.alert(data);
	        }
		}
	},
	validate:function (){
		if($.csValidator.checkNull("parentID",$.csCore.getValue("Common_Required","Member_Parent"))){
			return false;
		}
		if($.csValidator.checkNull("username",$.csCore.getValue("Common_Required","Member_Username"))){
			return false;
		}
		if($.csValidator.checkNull("name",$.csCore.getValue("Common_Required","Member_Name"))){
			return false;
		}
		if($.csValidator.checkNull("phoneNumber",$.csCore.getValue("Common_Required","Member_Contact"))){
			return false;
		}
		if($.csValidator.checkNull("groupID",$.csCore.getValue("Common_PleaseSelect","Member_Group"))){
			return false;
		}
		if($.csValidator.checkNull("statusID",$.csCore.getValue("Common_PleaseSelect","Common_Status"))){
			return false;
		}
		if($.csValidator.checkNull("payTypeID",$.csCore.getValue("Common_PleaseSelect","Member_PayType"))){
			return false;
		}
		if($.csValidator.checkNull("companyName",$.csCore.getValue("Common_Required","Member_CompanyName"))){
			return false;
		}
		if($.csValidator.checkNull("statusID",$.csCore.getValue("Common_PleaseSelect","Common_Status"))){
			return false;
		}
		if($.csValidator.checkNull("cmtPrice",$.csCore.getValue("Common_Required","Member_CmtPrice"))){
			return false;
		}
		if($.csValidator.checkNull("verifyPassword",$.csCore.getValue("Common_Required","Member_Password"))){
			return false;
		}
		if($.csValidator.checkNull("homePage",$.csCore.getValue("Common_PleaseSelect","Member_HomePage"))){
			return false;
		}
		if($.csValidator.checkNull("shippingPaymentType",$.csCore.getValue("Common_PleaseSelect","Member_ShiperPayType"))){
			return false;
		}
		if($.csValidator.checkNull("LTNo",$.csCore.getValue("Common_Required","LTNo"))){
			return false;
		}
		if($("#password").val()!=$("#verifyPassword").val()){
			$.csCore.alert($.csCore.getValue("Member_PasswordNotMatch"));
			return false;
		}
		if($.csMemberPost.checkUser()){
			return false;
		}
		return true;
	},
	pickUser: function () {
        $.csCore.pickUser('parentID', 'parentName', false);
    },
    checkUser:function(){
    	if($.csValidator.isNull($("#ID").val())){
			var url = $.csCore.buildServicePath('/service/member/getmemberbyusername');
			var param = $.csControl.appendKeyValue("","username",$("#username").val());
		    var member = $.csCore.invoke(url,param);
			if (!$.csValidator.isNull(member)) {
				$.csCore.getValue("Member_UsernameNotUnique",null,"#message");
				setTimeout( function(){$("#message").empty();},3000);
				return true;
			}
			return false;
		}
    },
	init:function(id){
		$('#form').resetForm();
		$.csMemberCommon.bindLabel();
		$.csMemberPost.bindEvent();
		$.csMemberCommon.fillStatus('statusID');
		$.csMemberCommon.fillGroup('groupID');
		$.csMemberPost.fillPayType();
		$.csMemberPost.fillMoneySign();
		$.csMemberPost.fillMTO();
		$.csMemberPost.fillHomePage();
		$.csMemberPost.fillExpress();
		$.csMemberPost.fillShippingPayType();
		$.csMemberPost.fillBusinessUnit();
		if($.csValidator.isNull(id)){
			$.csCore.getValue("Common_Add","Member_Moduler","#form h1");
		}else{
			$.csCore.getValue("Common_Edit","Member_Moduler","#form h1");
			var member = $.csCore.getMemberByID(id);
			var cash = $.csCore.getCashByMemberByID(id);
			if (cash!=null){
				$("#noticeNum").val(cash.noticeNum);
				$("#stopNum").val(cash.stopNum);
			}
			$("#parentID").val(member.parentID);
			$("#verifyPassword").val(member.password);
			$("#username").attr('readonly',true);
			$("#username").attr('disabled',true);
			$.updateWithJSON(member);
			if (member.isDiscount!=null && member.isDiscount==DICT_YES){
				$("#isDiscount").attr('checked',true);
			} else {
				$("#isDiscount").attr('checked',false);
			}
		}
	}
};