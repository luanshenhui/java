jQuery.csDistributionPost={
		moduler:"Company",
		list:function(pageIndex){
			param=$.csControl.appendKeyValue("",'pageindex',pageIndex);
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/distribution/getConmpanys'),param);
			$.csCore.processList($.csDistributionPost.moduler, data);
			if(pageIndex==0){
				$.csCore.initPagination($.csDistributionPost.moduler + "Pagination", data.count, PAGE_SIZE, $.csDistributionPost.list);
			}
		}
		,
		bindEvent:function(){
			$("#addCompany").click(function(){$.csDistributionPost.addCompany();});
		},
		addCompany:function(){
			var companyname=$("#companyname").val();
			if(companyname!=""&&companyname.length!=0){
				param=$.csControl.appendKeyValue("",'companyname',companyname);
				var data=$.csCore.invoke($.csCore.buildServicePath('/service/distribution/addCompanys'),param);
				if(data=='OK'){
					$.csDistributionPost.list(0);
				}
			}
			else
			{
				$.csCore.alert("填写物流公司");
			}	
		},
		deleteCompany:function(id){
			var ID=$.csControl.appendKeyValue("",'id',id);
			var data=$.csCore.invoke($.csCore.buildServicePath('/service/distribution/deleteCompanys'),ID);
			if(data=='OK'){
				$.csDistributionPost.list(0);
			}
			else
			{
				$.csCore.alert("不能删除");
			}
			
		},
		init:function(){
			$.csDistributionPost.bindEvent();
			$.csDistributionPost.list(0);
		}
}