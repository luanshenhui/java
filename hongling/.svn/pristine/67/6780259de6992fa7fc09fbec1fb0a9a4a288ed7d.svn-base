jQuery.csOrdenJhrq={
	bindLabel:function (){		
		$.csCore.getValue("Orden_DealDate",null,".lblDealDate");
		$.csCore.getValue("Button_Cancel",null,"#btnCancel");
		$.csCore.getValue("Button_Submit",null,"#btnSubmit");
	},
	bindEvent:function (){
		$("#btnSubmit").click($.csOrdenJhrq.saveJhrq);
		$("#btnCancel").click($.csCore.close);
	},
	saveJhrq : function(){
		$.csCore.confirm($.csCore.getValue('Orden_JhrqConfirm'),"$.csOrdenJhrq.save()");
	},
	save:function (){
	    if($.csCore.postData($.csCore.buildServicePath('/service/orden/saveordenjhrq'), 'form')){
//	    	$.csOrdenList.list(0);
//	    	$.csCore.close();
	    	window.location.href='/hongling/orden/dordenPage.do';
	    }
	},
	init:function(ID,jhrq){
		$.csOrdenJhrq.bindLabel();
		$.csOrdenJhrq.bindEvent();
		$.csDate.datePickerTo10("jhrq",jhrq);
		$("#ID").val(ID);
	}
};