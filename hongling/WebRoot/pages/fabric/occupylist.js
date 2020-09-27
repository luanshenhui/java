jQuery.csFabricOccupyList={
	divFabricOccupy:"FabricOccupy",
	list:function (pageIndex){
		var url = $.csCore.buildServicePath('/service/fabric/getfabricoccupys');
	    var param = "";
	    param = $.csControl.appendKeyValue(param,"pageindex",pageIndex);
	    param = $.csControl.appendKeyValue(param,"pagesize",PAGE_SIZE);
	    
	    var data = $.csCore.invoke(url,param);
	    $.csCore.processList($.csFabricOccupyList.divFabricOccupy, data);
	    $.csFabricCommon.bindLabel();
	},
	init:function(){
		$.csFabricOccupyList.list(0);
	}
};