jQuery.csCashPost={
	bindEvent:function (){
		$("#btnSaveCash").click($.csCashPost.save);
		$("#btnCancelCash").click($.csCore.close);
		$.csDate.datePicker("pubDate");
		$("#num").click($.csCashPost.setPriceUnit);
	},
	fillIsReconciliation:function (){
	    $.csControl.fillOptions('isReconciliation',$.csCore.getDicts(DICT_CATEGORY_BOOL), "ID" , "name", "");
	},
	save:function (){
	    if($.csCashPost.validate()){
		    if($.csCore.postData($.csCore.buildServicePath('/service/cash/savecash'), 'form')){
		    	$.csCashList.list(0);
		    	$.csCore.close();
		    }
	   	}
	},
	validate:function (){
		if($.csValidator.checkNull("pubMemberID",$.csCore.getValue("Common_Required","Member_Username"))){
			return false;
		}
		if($.csValidator.checkNull("noticeNum",$.csCore.getValue("Common_Required","Cash_NoticeNum"))){
			return false;
		}
		if($.csValidator.checkNull("stopNum",$.csCore.getValue("Common_Required","Cash_StopNum"))){
			return false;
		}
		if($.csValidator.checkNotPositiveMoney($("#noticeNum").val(),$.csCore.getValue("Cash_NotPositiveMoney"))){
			return false;
		}
		if($.csValidator.checkNotPositiveMoney($("#stopNum").val(),$.csCore.getValue("Cash_NotPositiveMoney"))){
			return false;
		}
		return true;
	},
    setPriceUnit:function(){
    	var member=$.csCore.getMemberByID($("#pubMemberID").val());
    	$("#tip_priceUnit").html(member.moneySignName);
    	$("#tip_noticeUnit").html(member.moneySignName);
    	$("#tip_stopUnit").html(member.moneySignName);
    	if (member.moneySignID==10360){
    		if ($("#noticeNum").val().length==0){
    			$("#noticeNum").val('2000');
    		}
    		if ($("#stopNum").val().length==0){
    			$("#stopNum").val('1000');
    		}
    	}else if(member.moneySignID==10361){
    		if ($("#noticeNum").val().length==0){
    			$("#noticeNum").val('10000');
    		}
    		if ($("#stopNum").val().length==0){
    			$("#stopNum").val('5000');
    		}
    	}
    }, 
	init:function(id){
		$.csCashPost.fillIsReconciliation();
		$.csCashCommon.bindLabel();
		$.csCashPost.bindEvent();
		$.csCore.getValue("Common_Add","Cash_Moduler","#form h1");
		$('#form').resetForm();
		if($.csValidator.isNull(id)){
			$.csCore.getValue("Common_Add","Cash_Moduler","#form h1");
		}else{
			$.csCore.getValue("Common_Edit","Cash_Moduler","#form h1");
			var cash = $.csCashCommon.getCashByID(id);
			$.updateWithJSON(cash);
			$.csCashPost.setPriceUnit();
            $("#pubDate").val($.csDate.formatMillisecondDate(cash.pubDate));
            $("#companyName").val(cash.member.username);
            $("#num").attr('readonly',true);
            $("#num").attr('disabled',true);
//            $("#noticeNum").attr('readonly',true);
//            $("#noticeNum").attr('disabled',true);
//            $("#stopNum").attr('readonly',true);
//            $("#stopNum").attr('disabled',true);
            if ($("#num").val().length==0){
            	$("#num").val(0);
            }
		}
	}
};