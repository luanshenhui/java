jQuery.csOrdenStop={
	bindLabel:function (){
		$.csCore.getValue("Orden_StopCause",null,".lblOrdenStop");
		$.csCore.getValue("Orden_Stop",null,"#formStop h1");
		$.csCore.getValue("Button_Submit",null,"#btnSubmitConfirm");
		$.csCore.getValue("Button_Cancel",null,"#btnCancelConfirm");
	},
	bindEvent:function (){
		$("#btnSubmitConfirm").click($.csOrdenStop.stopOrden);
		$("#btnCancelConfirm").click($.csCore.close);
	},
	stopOrden:function (){
		var ordenID = $("#ordenID").val();
		var stopCauseID = $("#stopCause").val();
		var url=$.csCore.buildServicePath("/service/orden/ordenstopcause?ordenID="+ordenID+"&stopCauseID="+stopCauseID);
		var result=$.csCore.invoke(url);
		if(result){
			$.csOrdenList.list(0);
			$.csCore.close();
		}
	},
	fillCause:function (){
		var datas = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getordenstopcause'));
	    $.csControl.fillOptions('stopCause',datas , "ID" , "name",'');
	},
	init:function(ordenID){
		$.csOrdenStop.fillCause();
		$.csOrdenStop.bindLabel();
		$.csOrdenStop.bindEvent();
		$("#ordenID").val(ordenID);
	}
};