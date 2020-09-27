jQuery.csFabricInfoReport2List={
		moduler:"FabricPriceReport",
		list:function(pageIndex){
			var param=$.csControl.getFormData("search");
			param=$.csControl.appendKeyValue(param,'pageindex',pageIndex);
			param=$.csControl.appendKeyValue(param,'fpareaid',"20150");
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/GetFabricPriceReport'),param);
			
			$.csCore.processList($.csFabricInfoReport2List.moduler, data);
			if(pageIndex==0){
				$.csCore.initPagination($.csFabricInfoReport2List.moduler + "Pagination", data.count, PAGE_SIZE, $.csFabricInfoReport2List.list);
			}
		}
		,
		bindEvent:function(){
			$("#btnQuery").click(function(){$.csFabricInfoReport2List.list(0);});
			$.csDate.datePickerNull("dealDate");
		}
		,
		exportfabricprice : function() {
			var url = $.csCore.buildServicePath('/service/fabric/exportfabricprice');
			var param = "?fpareaid=20150&searchKeyword="+$("#searchKeyword").val()+"&dealDate="+$("#dealDate").val();
			window.open(url+param);
		}
		,
		init:function(){
			$.csFabricInfoReport2List.list(0);
			$.csFabricInfoReport2List.bindEvent();
		}
};
$("#btnExportFabricPrice").click(function(){$.csFabricInfoReport2List.exportfabricprice()});

