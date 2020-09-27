jQuery.csCustomerPeriodAssesmentList={
		moduler:"CustomerAssessment",
		list:function(pageIndex){
			var param=$.csControl.getFormData("search");
			param=$.csControl.appendKeyValue(param,'pageindex',pageIndex);
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/GetAssessReportWithCustomername'),param);
			$.csCore.processList($.csCustomerPeriodAssesmentList.moduler, data);
			if(pageIndex==0){
				$.csCore.initPagination($.csCustomerPeriodAssesmentList.moduler + "Pagination", data.count, PAGE_SIZE, $.csCustomerPeriodAssesmentList.list);
			}
		}
		,
		bindEvent:function(){
			$("#btnQuery").click(function(){$.csCustomerPeriodAssesmentList.list(0);});
			$("#btnExportPeriod").click(function(){$.csCustomerPeriodAssesmentList.exportPeriodAssert();});
			$.csDate.datePicker("dealDate");
			//$.csDate.datePickerNull("dealToDate");
			
		},
		
		exportPeriodAssert:function(){
			var url = $.csCore.buildServicePath('/service/orden/exportPeriodAssess');
			var param = "?searchKeyword="+$("#searchKeyword").val()+"&dealDate="+$("#dealDate").val();
			window.open(url+param);
		},
		init:function(){
			$.csCustomerPeriodAssesmentList.list(0);
			$.csCustomerPeriodAssesmentList.bindEvent();
		}
};