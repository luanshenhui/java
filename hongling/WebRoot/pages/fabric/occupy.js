jQuery.csFabricOccupy={
	bindEvent:function (){
		$("#btnOccupyFabric").click($.csFabricOccupy.occupy);
		$("#btnOccupyCancel").click($.csCore.close);
	},
	occupy:function (){
		if($.csFabricOccupy.validate()){
		    if($.csCore.postData($.csCore.buildServicePath('/service/fabric/occupyfabric'), 'form_occupy')){
		    	alert($.csCore.getValue("Fabric_OccupyOk"));
		    	$.csCore.close();
		    }
	    }
	},
	validate:function (){
		if($.csValidator.checkNull("amount",$.csCore.getValue("Common_Required","Fabric_OccupyAmount"))){
			return false;
		}
		return true;
	},
	init:function(code){
		$.csFabricCommon.bindLabel();
		$.csFabricOccupy.bindEvent();
		$('#occupyCode').html(code);
		$('#fabricCode').val(code);
	}
};