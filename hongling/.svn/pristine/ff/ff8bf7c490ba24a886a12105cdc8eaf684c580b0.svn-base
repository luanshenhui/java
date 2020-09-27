jQuery.csOrderOneList={
		moduler:"OrderOne",
		list:function(pageIndex){
			var param=$.csControl.getFormData("search");
			param=$.csControl.appendKeyValue(param,'pageindex',pageIndex);
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/repair/GetOrderOne'),param);
			$.csCore.processList($.csOrderOneList.moduler, data);
			if(pageIndex==0){
				$.csCore.initPagination($.csOrderOneList.moduler + "Pagination", data.count, PAGE_SIZE, $.csOrderOneList.list);
			}
		}
		,
		fillClothing:function (){
			var datas = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getclothing'));
		    $.csControl.fillOptions('searchKeyword',datas , "ID" , "name", $.csCore.getValue("Common_All"));
		},

		bindEvent:function(){
			$("#btnQuery").click(function(){$.csOrderOneList.list(0);});
			$.csDate.datePicker("dealDate");
			//$.csDate.datePickerNull("dealToDate");
			$('#exportOn').click(function(){$.csOrderOneList.exportOn();});			
		}
		,
		exportOn:function(){
			var url = $.csCore.buildServicePath('/service/orden/exportOrderOne?formData=' + $.csOrderOneList.buildSearchParam());
			window.open(url);
		}
		,
		buildSearchParam:function(){
			var param = $.csControl.appendKeyValue("","search",$('#search').val());
			param = $.csControl.appendKeyValue(param,"searchKeyword",$('#searchKeyword').val());
			param = $.csControl.appendKeyValue(param,"dealDate",$('#dealDate').val());
			return param;
		}
		,
		init:function(){
			$.csOrderOneList.fillClothing();
			$.csOrderOneList.list(0);
			$.csOrderOneList.bindEvent();
			
		}
};