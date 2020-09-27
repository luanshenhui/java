jQuery.csDistributionList={
		moduler:"Distribution",
		list:function(pageIndex){
			var param=$.csControl.getFormData("DistributionSearch");
			param=$.csControl.appendKeyValue(param,'pageindex',pageIndex);
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/distribution/getDistributions'),param);
			$.csCore.processList($.csDistributionList.moduler, data);
			if(pageIndex==0){
				$.csCore.initPagination($.csDistributionList.moduler + "Pagination", data.count, PAGE_SIZE, $.csDistributionList.list);
			}
		},
		bindEvent:function(){
			$("#btnQuery").click(function(){$.csDistributionList.list(0);});
			$("#btnAddMode").click(function(){$.csDistributionList.openPost();});
			$("#btnAdd").click(function(){$.csDistributionList.openView(null);});
		},
		openView:function(ID){
			$.csCore.loadModal('../distribution/view.jsp',600,300,function(){$.csDistributionView.init();});1
		}
		,
		openPost:function(){
			$.csCore.loadModal('../distribution/addCompanys.jsp',600,400,function(){$.csDistributionPost.init();});
		}
		,
		openEdit:function(id){
			$.csCore.loadModal('../distribution/edit.jsp',510,320,function(){$.csDistributionEdit.init(id);});
		}
		,
		deleteByID:function(ID){
			var url = $.csCore.buildServicePath('/service/distribution/deleteDistributions');
			$.csCore.confirm($.csCore.getValue('Common_RemoveConfirm'), "$.csDistributionList.remove('" + url + "','" + ID + "')");
			
		},
		remove:function(url,ID){
			var param = $.csControl.appendKeyValue("", "ID", ID);
	        var data = $.csCore.invoke(url, param);
	        if (data != null) {
	            if (data == "OK") {
	            		$('#td' + ID).html("否");
	            	}
	            }
		}
		,
		fillCompany:function(){
			var datas = $.csCore.invoke($.csCore.buildServicePath('/service/distribution/fillCompanys'));
			$.csControl.fillOptions('searchCompanyID',datas , "id" , "companyname", $.csCore.getValue("Common_All"));
		}
		,
		init:function(){
			$.csDistributionList.fillCompany();
			$.csDistributionList.bindEvent();  
			$.csDistributionList.list(0);
		}
};