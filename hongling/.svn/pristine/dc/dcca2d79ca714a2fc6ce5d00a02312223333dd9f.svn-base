jQuery.csFabricWareroomPost={
		fillBrands:function(){
			var datas = $.csCore.invoke($.csCore.buildServicePath('/service/fabricwareroom/getFabricTraderList'));
			$.csControl.fillOptions('brands',datas , "id" , "traderName", "");
			
		}
		,
		fillCategory:function(){
			var datas=$.csCore.invoke($.csCore.buildServicePath('/service/fabric/getfabriccategorybytop'));
			$.csControl.fillOptions('category',datas, "ID" , "name", "");
			//判断
		}
		,
		fillProperty:function(param){
			var datas=$.csCore.invoke($.csCore.buildServicePath('/service/fabric/getpropettybycategory'),param);
			$.csControl.fillOptions('property',datas, "ID" , "name", "");
		}
		,
		fillEvent:function(){
			$("#series,#color,#flower,#composition").empty();
			var param = $.csControl.appendKeyValue('','categoryid',$('#category').val());
			$.csFabricWareroomPost.fillProperty(param);
			var dictsColor = $.csCore.invoke($.csCore.buildServicePath('/service/fabric/getcolorbycategory'),param);
			$.csControl.fillOptions('color',dictsColor, "ID" , "name", $.csCore.getValue("Common_PleaseSelect","Fabric_Color"));
			var dictsFlower = $.csCore.invoke($.csCore.buildServicePath('/service/fabric/getflowerbycategory'),param);
			$.csControl.fillOptions('flower',dictsFlower, "ID" , "name", $.csCore.getValue("Common_PleaseSelect","Fabric_Flower"));
			var dictsComposition = $.csCore.invoke($.csCore.buildServicePath('/service/fabric/getcompositionbycategory'),param);
			$.csControl.fillOptions('composition',dictsComposition, "ID" , "name", $.csCore.getValue("Common_PleaseSelect","Fabric_Composition"));
		}
		,
		bindEvent:function(ex){
			$("#category").change(function(){$.csFabricWareroomPost.fillEvent();});
			$("#fabricNo").blur(function(){$.csFabricWareroomPost.getFabricNo();});
			$("#rmb").blur(function(){$.csFabricWareroomPost.catRmb(ex);});
			$("#btnSave").click(function(){$.csFabricWareroomPost.save();});
		}
		,
		save:function(){
			if ($.csFabricWareroomPost.validate()) {
				if($.csCore.postData($.csCore.buildServicePath("/service/fabrictrader/saveFabricWareroom"), "form")){
					$.csFabricWareroomList.list(0);
					$.csCore.close();
				}
			}
		}
		,
		validate:function(){
			var zh=/^[0-9].*$/;
			if($.csValidator.checkNull("fabricNo","面料编码不能为空")){
				return false;
			}
			if($.csValidator.checkNull("property","属性不能为空")){
				return false;
			}
			if($.csValidator.checkNull("belong","单位不能为空")){
				return false;
			}
			if($.csValidator.checkNull("category","请选择分类")){
				return false;
			}
			if($.csValidator.checkNull("color","请选择颜色")){
				return false;
			}
			if($.csValidator.checkNull("flower","请选择花型")){
				return false;
			}
			if($.csValidator.checkNull("composition","请选择成分")){
				return false;
			}
			if(!zh.test($("#rmb").val())){
				$.csCore.alert("价格为请输入数字");
				return false;
			}
			return true;
			
		}
		,
		getFabricNo:function(){
			var param=$("#fabricNo").val();
//			var data=$.csCore.invoke($.csCore.buildServicePath('/service/fabricwareroom/getStockByFabricNo'),param);
//			$("#stock").val(data);
			var dat=$.csCore.invoke($.csCore.buildServicePath('/service/fabricwareroom/getFabricByCode'),param);
			if($.csValidator.isNull(dat)){
				$("#shazhi").val("");
			}
			else
			{
				$("#shazhi").val(dat.shaZhi);
			}	
		}
		,
		catRmb:function(ex){
			var dollar=(document.getElementById("rmb").value*ex)+"";
			$("#dollar").val(dollar.substring(0,dollar.indexOf(".")+3));
		}
		,
		fillStop:function(){
			$.csControl.fillOptions('status',$.csCore.getDicts(DICT_CATEGORY_BOOL), "ID" , "name", "");
		}
		,
		view:function(id){
			$("#ID").val(id);
			var param= $.csControl.appendKeyValue("","id",id);
			var data=$.csCore.invoke($.csCore.buildServicePath('/service/fabrictrader/getFabricWareroomById'),param);
			$("#fabricNo").val(data.fabricNo);
			$("#category").val(data.category);
			$.csFabricWareroomPost.fillEvent();
			$("#color").val(data.color);
			$("#flower").val(data.flower);
			$("#composition").val(data.composition);
			$("#stock").val(data.stock);
			$("#rmb").val(data.rmb);
			$("#dollar").val(data.dollar);
			$("#property").val(data.property);
			$("#shazhi").val(data.shazhi);
			$("#address").val(data.address);
			$("#brands").val(data.brands);
			$("#status").val(data.status);
			$("#weight").val(data.weight);
			$("#belong").val(data.belong);

		}
		,
		init:function(id,ex){
			$.csFabricWareroomPost.fillBrands();
			$.csFabricWareroomPost.fillCategory();
			$.csFabricWareroomPost.bindEvent(ex);
//			$.csFabricWareroomPost.fillStop();
			$.csFabricWareroomPost.view(id);
		}
};