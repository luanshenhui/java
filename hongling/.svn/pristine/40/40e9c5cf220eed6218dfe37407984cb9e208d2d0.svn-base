jQuery.csOrdenConfirm={
	bindLabel:function (){
		$.csCore.getValue("Orden_Memo",null,".lblMemo");
		$.csCore.getValue("Orden_Confirm",null,"#formConfirm h1");
		$.csCore.getValue("Button_Submit",null,"#btnSubmitConfirm");
		$.csCore.getValue("Button_Cancel",null,"#btnCancelConfirm");
	},
	bindEvent:function (){
		$("#btnSubmitConfirm").click($.csOrdenConfirm.rejectOrden);
		$("#btnCancelConfirm").click($.csCore.close);
	},
	rejectOrden:function (ordenID){
		var url = $.csCore.buildServicePath("/service/orden/rejectorden");
		if($.csOrdenConfirm.validatePost() == true){
			var result = $.csCore.postData(url, "formConfirm");
			if(result){
				$.csOrdenList.list(0);
				$.csCore.close();
			}
		}
	},
	validatePost:function (){
		if($.csValidator.checkNull("memo",$.csCore.getValue("Common_Required","Orden_Memo"))){
			return false;
		}
		return true;
	},
	init:function(ordenID){
		$.csOrdenConfirm.bindLabel();
		$.csOrdenConfirm.bindEvent();
		$("#ordenConfirmID").val(ordenID);
	}
};