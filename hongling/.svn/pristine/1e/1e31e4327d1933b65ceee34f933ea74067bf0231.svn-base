jQuery.csBlAddNum={
	bindEvent:function (){
		$("#blBtnSaveNum").click($.csBlAddNum.save);
		$("#blBtnCancelNum").click($.csCore.close);
	},
	save:function (){
	    if($.csBlAddNum.validate()){
	    	var id = $("#blId").val();
	    	var flag = $("#flag").val();
		    if($.csCore.postData($.csCore.buildServicePath('/service/cash/BlCashAddNum'), 'blAddNumForm')){
		    	// from post.htm
		    	if (flag.length==0){
			    	$.csCashPost.init(id);
			    	$.csCashList.list(0);
		    	} 
		    	// from list.htm
		    	else {
		    		$.csCashList.list(0);
		    	}
		    	$.csCore.close();
		    }
	   	}
	},
	validate:function (){
		if($.csValidator.checkNull("blAddMoneyNum",$.csCore.getValue("Common_Required","Cash_AddMoneyNum"))){
			return false;
		}
		if($.csValidator.checkNotPositiveMoney($("#blAddMoneyNum").val(),$.csCore.getValue("Cash_NotPositiveMoney"))){
			return false;
		}
		return true;
	},
	init:function(cashid,memberid,flag){
		$.csBlAddNumCommon.bindLabel();
		$.csBlAddNum.bindEvent();
		$("#blId").val(cashid);
		$("#memberid").val(memberid);
		$("#flag").val(flag);
		var member=$.csCore.getMemberByID(memberid);
		$("#tip_addnum").html(member.moneySignName);
	}
};