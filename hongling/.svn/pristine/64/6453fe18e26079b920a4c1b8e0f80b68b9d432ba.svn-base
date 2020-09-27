jQuery.csFabricInfoReport1List={
		moduler:"FabricInfoReport",
		list:function(pageIndex,fpareaid){
			var param=$.csControl.getFormData("search");
			param=$.csControl.appendKeyValue(param,'pageindex',pageIndex);
			param=$.csControl.appendKeyValue(param,'fpareaid',"20151");
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/GetFabricInfoReport'),param);
			
			$.csCore.processList($.csFabricInfoReport1List.moduler, data);
			if(pageIndex==0){
				$.csCore.initPagination($.csFabricInfoReport1List.moduler + "Pagination", data.count, PAGE_SIZE, $.csFabricInfoReport1List.list);
			}
		}
		,
		bindEvent:function(){
			$("#btnQuery").click(function(){$.csFabricInfoReport1List.list(0);});
			$.csDate.datePickerNull("dealDate");
		}
		,
		exportfabricinfo : function() {
				var url = $.csCore.buildServicePath('/service/fabric/exportfabricinfo');
				var param = "?fpareaid=20151&searchKeyword="+$("#searchKeyword").val()+"&dealDate="+$("#dealDate").val();
				window.open(url+param);
		}
		,
		init:function(){
			$.csFabricInfoReport1List.list(0);
			$.csFabricInfoReport1List.bindEvent();
		}
};
$("#btnExportFabricInfo").click(function(){$.csFabricInfoReport1List.exportfabricinfo()});

