jQuery.csDistributionView={
		bindEvent:function(){
			$("#btnSave").click(function(){$.csDistributionView.getelement();});
		}
		,
		fillCompany:function(){
			var datas = $.csCore.invoke($.csCore.buildServicePath('/service/distribution/fillCompanys'));
			$.csControl.fillOptions('company',datas , "id" , "companyname");
		}
		,
		getelement:function(){
			if($.csDistributionView.validate()){
				var param=$.csControl.getFormData("form");
				var data=$.csCore.invoke($.csCore.buildServicePath('/service/distribution/addDistributions'),param);
					if(data=="OK"){
						$.csDistributionList.list(0);
				    	$.csCore.close();
					}
			}
		}
		,
		validate:function(){
			 var value = /^[1-9][0-9]*$/;
			if($.csValidator.checkNull("sendend","目的地不能为空")){
				return false;
			}
			
			if($.csValidator.checkNull("sendto","始发地不能为空")){
				return false;
			}
			
			if(!value.test($("#MT_Price").val())){
				$.csCore.alert("套装费用必须位数字");
				return false;
			}
			if(!value.test($("#MXF_Price").val())){
				$.csCore.alert("上衣费用必须位数字");
				return false;
			}
			if(!value.test($("#MXK_Price").val())){
				$.csCore.alert("西裤费用必须位数字");
				return false;
			}
			if(!value.test($("#MDY_Price").val())){
				$.csCore.alert("大衣费用必须位数字");
				return false;
			}
			if(!value.test($("#MMJ_Price").val())){
				$.csCore.alert("马甲费用必须位数字");
				return false;
			}
			if(!value.test($("#MXQ_Price").val())){
				$.csCore.alert("西裙费用必须位数字");
				return false;
			}
			if(!value.test($("#MCY_Price").val())){
				$.csCore.alert("衬衣费用必须位数字");
				return false;
			}
			
			if(!value.test($("#MPO_Price").val())){
				$.csCore.alert("配饰费用必须位数字");
				return false;
			}
			return true;
			
		}
		,
		init:function(){
			$.csDistributionView.fillCompany();
			$.csDistributionView.bindEvent();
		}
};