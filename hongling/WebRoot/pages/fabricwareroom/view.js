jQuery.csFabricWareroomView={
		view:function(id){
			var param= $.csControl.appendKeyValue("","id",id);
			var data=$.csCore.invoke($.csCore.buildServicePath('/service/fabrictrader/getFabricWareroomById'),param);
			var pb=$.csControl.appendKeyValue("","id",data.brands);
			var weight=$.csCore.invoke($.csCore.buildServicePath('/service/fabrictrader/getFabricTraderById'),pb);
			var category=$.csControl.appendKeyValue("","id",data.category);
			var cate=$.csCore.invoke($.csCore.buildServicePath('/service/dict/getdictbyid'),category);
			var color=$.csControl.appendKeyValue("","id",data.color);
			var colorT=$.csCore.invoke($.csCore.buildServicePath('/service/dict/getdictbyid'),color);
			var flower=$.csControl.appendKeyValue("","id",data.flower);
			var flowerT=$.csCore.invoke($.csCore.buildServicePath('/service/dict/getdictbyid'),flower);
			var composition=$.csControl.appendKeyValue("","id",data.flower);
			var compositionT=$.csCore.invoke($.csCore.buildServicePath('/service/dict/getdictbyid'),composition);
			var fabricNo=$.csControl.appendKeyValue("","fabricNo",data.fabricNo);
			var fabricT=$.csCore.invoke($.csCore.buildServicePath('/service/fabricwareroom/getfabricbyNo'),fabricNo);
			$("#viewFabricNo").html(data.fabricNo);
			$("#viewCategory").html(cate.name);
			$("#viewColor").html(colorT.name);
			$("#viewFlower").html(flowerT.name);
			$("#viewComposition").html(compositionT.name);
			$("#viewStock").html(fabricT);
			$("#viewMoney").html(data.rmb+"(RMB);"+data.dollar+"(dollar);");
//			$("#viewRmb").val(data.rmb);
//			$("#viewDollar").val(data.dollar);
			$("#viewProperty").html(data.propertyName);
			$("#viewShazhi").html(data.shazhi);
			$("#viewAddress").html(data.address);
			$("#viewBrands").html(weight.traderName);
			$("#viewStatus").html(data.status==10050?"是":"否");
			$("#viewWeight").html(data.weight);
			$("#viewBelong").html(data.belong);
		}
		,
		init:function(id){
			$.csFabricWareroomView.view(id);
		}
};