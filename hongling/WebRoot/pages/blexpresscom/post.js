jQuery.csBlExpressPost={
	/**
	 * 绑定事件
	 */
	bindEvent: function() {
		$("#btnSaveExpress").click($.csBlExpressPost.save);
		$("#btnCancelExpress").click($.csCore.close);
	},
	
	/**
	 * 验证
	 */
	validate: function() {
		if($.csValidator.checkNull("name",$.csCore.getValue("Common_Required","Delivery_ComName"))){
			return false;
		}
		if($.csValidator.checkNull("linkMan",$.csCore.getValue("Common_Required","Member_Contact"))){
			return false;
		}
		if($.csValidator.checkNull("mobile",$.csCore.getValue("Common_Required","Delivery_Mobile"))){
			return false;
		}
		if($.csValidator.checkNull("seq",$.csCore.getValue("Common_Required","Label_Seq"))){
			return false;
		}
		// 验证手机号码是否合法
//		if ($.csValidator.checkIsValidMobile("mobile"), $.csCore.getValue("Delivery_MobileInvalid")) {
//			return false;
//		};
		//判断设置顺序是否为正整数
		if($.csValidator.checkNotPositiveInteger($("#seq").val(),$.csCore.getValue("Common_PositiveInteger","Label_Seq"))){
			return false;
		}
		return true;
	},
	
	/**
	 * 保存
	 */
	save: function() {
		if ($.csBlExpressPost.validate()) {
			if($.csCore.postData($.csCore.buildServicePath('/service/blexpresscom/saveexpresscom'), 'form')){
		    	$.csBlExpressComList.list(0);
		    	$.csCore.close();
		    }
		}
	},
	
	/**
	 * 初始化
	 */
	init: function(id) {
		$.csBlExpressComCommon.bindLabel();
		$.csBlExpressPost.bindEvent();
		$('#form').resetForm();
		
		// 新增
		if($.csValidator.isNull(id)){
			$.csCore.getValue("Common_Add","Member_Express","form h1");
		// 修改
		}else{
			$.csCore.getValue("Common_Edit","Member_Express","form h1");
			var expressCom = $.csBlExpressComCommon.getExpressComById(id);
			$.updateWithJSON(expressCom);
		}
	}
};