
$(document).ready(function(){
	var id="MTMB12090051";
	$.csOrdenInfoView.init(id);
});
jQuery.csOrdenInfoView={
		moduler:"ordeninfo_shangpin",
		bindlabel:function(id){
			var param = $.csControl.appendKeyValue('','ordenID',id);
			var orden = $.csCore.invoke($.csCore.buildServicePath("/service/ordenview/getordeninfobyid"),param);
			$("#fabriccode").html(orden.fabricCode);
			param=$.csControl.appendKeyValue(param,"clothingID",orden.clothingID);
			param=$.csControl.appendKeyValue(param,"pageindex",0);
//			if(orden.clothingID==1){
//				//两件套
//			}
//			if(orden.clothingID==2){
//				//三件套
//			}
//			if(orden.clothingID!=1&&orden.clothingID!=2){
//				//单件
//			}
			$.csOrdenInfoView.list_info(param);
		}
		,
		list_info:function(param){
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getordensbyclothingid'),param);
		}
		,
		init:function(id){
			$.csOrdenInfoView.bindlabel(id);
		}
};