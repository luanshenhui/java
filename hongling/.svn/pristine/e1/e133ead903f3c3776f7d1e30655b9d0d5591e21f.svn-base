jQuery.csFabricDiscount={
	bindEvent:function (code){
		$("#memberName").click($.csFabricDiscount.pickUser);
		$("#btnDiscountFabric").click(function(){$.csFabricDiscount.saveDiscount(code);});
		$("#btnDiscountCancel").click($.csCore.close);
	},
	
	/**
	 * 选择用户
	 */
	pickUser: function () {
        $.csCore.pickUser('memberId', 'memberName', true);
    },
    
	/**
	 * 保存面料促销活动
	 */
	saveDiscount:function (code){
		if($.csFabricDiscount.validate()){
		    if($.csCore.postData($.csCore.buildServicePath('/service/fabric/discountfabric'), 'form_discount')){
		    	$.csCore.close();
		    }
	    }
		// 刷新列表页面
		$.csFabricDiscountList.list(0,code);
	},
	
	validate:function (){
		if($.csValidator.checkNull("memberName",$.csCore.getValue("Common_Required","Fabric_Member"))){
			return false;
		}
/*		if($.csValidator.checkNull("startDate",$.csCore.getValue("Common_Required","Fabric_StartDate"))){
			return false;
		}
		if($.csValidator.checkNull("endDate",$.csCore.getValue("Common_Required","Fabric_EndDate"))){
			return false;
		}*/
		if($.csValidator.checkNull("discount",$.csCore.getValue("Common_Required","Cash_Discount"))){
			return false;
		}
		return true;
	},

	init:function(code){
		$.csFabricCommon.bindLabel();
		$.csFabricDiscount.bindEvent(code);
		$('#discountCode').html(code);
		$('#fabricCode').val(code);
	},
};