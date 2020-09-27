jQuery.csCustomerAssesmentList={
		moduler:"CustomerAssessment",
		list:function(pageIndex){
			var param=$.csControl.getFormData("search");
			param=$.csControl.appendKeyValue(param,'pageindex',pageIndex);
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getCustomerOrdenAssessInfo'),param);
			$.csCore.processList($.csCustomerAssesmentList.moduler, data);
			if(pageIndex==0){
				$.csCore.initPagination($.csCustomerAssesmentList.moduler + "Pagination", data.count, PAGE_SIZE, $.csCustomerAssesmentList.list);
			}
		}
		,
		bindEvent:function(){
			$("#btnQuery").click(function(){$.csCustomerAssesmentList.list(0);});
			$.csDate.datePickerNull("dealDate");
			$.csDate.datePickerNull("dealToDate");
			$("#btnExportAssess").click($.csCustomerAssesmentList.exportAssertList);
			
		}
		,
		exportAssertList:function(){
			var url = $.csCore.buildServicePath('/service/orden/exportCustomAssess');
			var param = "?searchKeyword="+$("#searchKeyword").val()+"&dealDate="+$("#dealDate").val()+"&dealToDate="+$("#dealToDate").val();
			window.open(url+param);
		},
		init:function(){
			$.csCustomerAssesmentList.list(0);
			$.csCustomerAssesmentList.bindEvent();
		}
};