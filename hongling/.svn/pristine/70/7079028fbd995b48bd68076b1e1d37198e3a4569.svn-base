jQuery.csOrdenPrint={
	printView:function (id){
		var param =  $.csControl.appendKeyValue("","ordenIds",id);
		param =  $.csControl.appendKeyValue(param,"type","print");
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/exportordencontent'),param);
//		alert(data);
		$("#ordenPrint").html(data);
	},
	init:function(id){
		$("#btnCancelOrden").click($.csCore.close);
		$.csOrdenPrint.printView(id);
	}
};