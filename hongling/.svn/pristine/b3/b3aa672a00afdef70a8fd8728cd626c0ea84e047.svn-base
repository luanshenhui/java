jQuery.csBlAddDeal={
	/**
	 * 绑定事件
	 */
	bindEvent:function (){
		$("#blBtnSaveDeal").click($.csBlAddDeal.save);
		$("#blBtnCancelDeal").click($.csCore.close);
	},
	/**
	 * 保存
	 */
	save:function (){
	    if($.csBlAddDeal.validate()){
		    if($.csCore.postData($.csCore.buildServicePath('/service/blcash/SaveDeal'), 'BlAddDealForm')){
		    	$.csBlDealList.list(0);
		    	$.csCashList.list(0);
		    	$.csCore.close();
		    }
	   	}
	},
	/**
	 * 验证
	 * @returns {Boolean}
	 */
	validate:function (){
		if($.csValidator.checkNull("blDealNum",$.csCore.getValue("Common_Required","Cash_DealNum"))){
			return false;
		}
		// 如果交易项目为运费，判断运单号是否已经填写
		if ($("#blDealItems").val()==45) {
			if($.csValidator.checkNull("blYundanId",$.csCore.getValue("Common_Required","Delivery_TrackingNO"))){
				return false;
			}
		}
		if($.csValidator.checkNotPositiveMoney($("#blDealNum").val(),$.csCore.getValue("Cash_NotPositiveMoney"))){
			return false;
		}
		//撤单退款和下单扣款，订单号必填
		if ($("#blDealItems").val()==2 || $("#blDealItems").val()==82) {
			if($.csValidator.checkNull("blMemo",$.csCore.getValue("Common_Required","Orden_Code"))){
				return false;
			}
		}
		return true;
	},
	/**
	 * 填充交易项目
	 */
	fillBlDealItems:function(){
		$.csControl.fillOptions('blDealItems',$.csCore.getBlDealItems(), "ID" , "name", "");
	},
	/**
	 * 修改交易类型
	 */
	changeDealItem: function() {
		// 如果交易类型为运费
		if ($("#blDealItems").val()==45) {
			$("#yuanDanId").show();
		} else {
			$("#yuanDanId").hide();
		}
		$("#yuanDanId").val('');
	},	
	/**
	 * 初始化
	 * @param blcashid
	 * @param blmemberid
	 */
	init:function(blcashid,blmemberid){
		$.csBlAddDeal.fillBlDealItems();
		$.csBlAddDealCommon.bindLabel();
		$.csBlAddDeal.bindEvent();
		$("#bldealcashid").val(blcashid);
		$("#bldealmemberid").val(blmemberid);
		var member=$.csCore.getMemberByID(blmemberid);
		$("#tip_dealnum").html(member.moneySignName);
		$("#blAccountName").val(member.username);
        $("#blAccountName").attr('readonly',true);
        $("#blAccountName").attr('disabled',true);
        // 隐藏运单号
        $("#yuanDanId").hide();
	}
};