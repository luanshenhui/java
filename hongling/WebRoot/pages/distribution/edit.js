jQuery.csDistributionEdit={
		bindEvent:function(){
			$("#btnSave").click(function(){$.csDistributionEdit.getelement();});
		}
		,
		fillCompany:function(){
			var datas = $.csCore.invoke($.csCore.buildServicePath('/service/distribution/fillCompanys'));
			$.csControl.fillOptions('company',datas , "id" , "companyname");
		}
		,
		getelement:function(){
			if($.csDistributionEdit.validate()){
				var param=$.csControl.getFormData("form_edit");
				var data=$.csCore.invoke($.csCore.buildServicePath('/service/distribution/saveDistributionsById'),param);
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
		getLogisiticsById:function(ID){
			var param = $.csControl.appendKeyValue("","id",ID);
			var data=$.csCore.invoke($.csCore.buildServicePath('/service/distribution/getDistributionById'),param);
			$("#sendcount").val(data.sendcount);
			$("#MT_Price").val(data.MT_Price);
			$("#sendend").val(data.sendend);
			$("#sendto").val(data.sendto);
			$("#MXF_Price").val(data.MXF_Price);
			$("#MXK_Price").val(data.MXK_Price);
			$("#MDY_Price").val(data.MDY_Price);
			$("#MMJ_Price").val(data.MMJ_Price);
			$("#MXQ_Price").val(data.MXQ_Price);
			$("#MCY_Price").val(data.MCY_Price);
			$("#MPO_Price").val(data.MPO_Price);
			$("#company").val(data.company);
			$("#sendmode").val(data.sendmode);
			$("#status").val(data.status);
			$("#ID").val(ID);
		}
		,
		init:function(id){
			$.csDistributionEdit.fillCompany();
			$.csDistributionEdit.bindEvent();
			$.csDistributionEdit.getLogisiticsById(id);
		}
};