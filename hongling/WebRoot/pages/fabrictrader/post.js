jQuery.csFabrictraderPost={
		bindEvent:function(){
			$("#btnSave").click(function(){$.csFabrictraderPost.save();});
		}
		,
		save:function(){
			if ($.csFabrictraderPost.validate()) {
				if($.csCore.postData($.csCore.buildServicePath("/service/fabrictrader/saveFabricTrader"), "form")){
					$.csFabricTraderList.list(0);
					$.csCore.close();
				}
			}
		}
		,
		view:function(id){
			$("#ID").val(id);
			var param= $.csControl.appendKeyValue("","id",id);
			var data=$.csCore.invoke($.csCore.buildServicePath('/service/fabrictrader/getFabricTraderById'),param);
			$("#traderName").val(data.traderName);
			$("#recommendation").val(data.recommendation);
			$("#address").val(data.address);
			$("#telephone").val(data.telephone);
			$("#remark").val(data.remark);
			
		}
		,
		validate:function(){
			if($.csValidator.checkNull("traderName","商户名称不能为空")){
				return false;
			}
			if($.csValidator.checkNull("recommendation","推荐面料不能为空")){
				return false;
			}
			if($.csValidator.checkNull("address","地址不能为空")){
				return false;
			}
			return true;
		}
		,
		init:function(id){
				$.csFabrictraderPost.bindEvent();
				$.csFabrictraderPost.view(id);
			
		}
};