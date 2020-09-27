jQuery.csOrderTwoList={
		moduler:"OrderTwo",
		list:function(pageIndex){
			var param=$.csControl.getFormData("search");
			param=$.csControl.appendKeyValue(param,'pageindex',pageIndex);
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/repair/GetOrdenTwo'),param);
			$.csCore.processList($.csOrderTwoList.moduler, data);
			if(pageIndex==0){
				$.csCore.initPagination($.csOrderTwoList.moduler + "Pagination", data.count, PAGE_SIZE, $.csOrderTwoList.list);
			}
		},
		fillClothing:function (){
			var datas = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getclothing'));
		    $.csControl.fillOptions('searchClothingID',datas , "ecode" , "name", $.csCore.getValue("Common_All"));
		},
		bindEvent:function(){
			$("#btnQuery").click(function(){$.csOrderTwoList.list(0);});
			$.csDate.datePicker("dealDate");
			//$.csDate.datePickerNull("dealToDate");
			$('#exportOntwo').click(function(){$.csOrderTwoList.exportOntwo();});	
		}
		,

		exportOntwo:function(){
			var url = $.csCore.buildServicePath('/service/orden/ExportOrderTwo?formData=' + $.csOrderTwoList.buildSearchParam());
			//alert("ok");
			window.open(url);
		}
		,
		buildSearchParam:function(){
			var param = $.csControl.appendKeyValue("","search",$('#search').val());
			param = $.csControl.appendKeyValue(param,"searchClothingID",$('#searchClothingID').val());
			param = $.csControl.appendKeyValue(param,"memberName",$('#memberName').val());
			param = $.csControl.appendKeyValue(param,"dealDate",$('#dealDate').val());		
		//	alert(param);
			return param;
		}
		,
		init:function(){
			$.csOrderTwoList.fillClothing();
			$.csOrderTwoList.list(0);
			$.csOrderTwoList.bindEvent();
		}
};