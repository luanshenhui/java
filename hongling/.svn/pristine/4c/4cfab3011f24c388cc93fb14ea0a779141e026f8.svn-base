jQuery.csCategoryPeriodAssesmentList={
		moduler:"CustomerAssessment",
		list:function(pageIndex){
			var param=$.csControl.getFormData("search");
			param=$.csControl.appendKeyValue(param,'pageindex',pageIndex);
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/GetAssessReportWithClothcategory'),param);
			$.csCore.processList($.csCategoryPeriodAssesmentList.moduler, data);
			/*if(pageIndex==0){
				$.csCore.initPagination($.csCategoryPeriodAssesmentList.moduler + "Pagination", data.count, PAGE_SIZE, $.csCategoryPeriodAssesmentList.list);
			}*/
		}
		,
		bindEvent:function(){
			$("#btnQuery").click(function(){$.csCategoryPeriodAssesmentList.list(0);});
			$("#btnExportCategory").click(function(){$.csCategoryPeriodAssesmentList.exportCategoryAssert();});
			$.csDate.datePicker("dealDate");
			//$.csDate.datePickerNull("dealToDate");
			
		},
		
		exportCategoryAssert:function(){
			var url = $.csCore.buildServicePath('/service/orden/exportCategoryAssess');
			var param = "?searchKeyword="+$("#searchKeyword").val()+"&dealDate="+$("#dealDate").val();
			window.open(url+param);
		},
		init:function(){
			$.csCategoryPeriodAssesmentList.list(0);
			$.csCategoryPeriodAssesmentList.bindEvent();
		}
};