jQuery.csFabricTraderList={
		moduler:"FabricTrader",
		list:function(pageIndex){
			var param=$.csControl.getFormData("search");
			param=$.csControl.appendKeyValue(param,'pageindex',pageIndex);
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/fabrictrader/getFabricTraders'),param);
			$.csCore.processList($.csFabricTraderList.moduler, data);
			if(pageIndex==0){
				$.csCore.initPagination($.csFabricTraderList.moduler + "Pagination", data.count, PAGE_SIZE, $.csFabricTraderList.list);
			}
		}
		,
		bindEvent:function(){
			$("#btnQuery").click(function(){$.csFabricTraderList.list(0);});
			$("#btnDelete").click(function(){$.csFabricTraderList.remove();});
			$("#btnAdd").click(function(){$.csFabricTraderList.openPost(null);});
			
		}
		,
		openPost:function(ID){
			$.csCore.loadModal('../fabrictrader/post.jsp',550,350,function(){$.csFabrictraderPost.init(ID);});
		}
		,
		remove:function(){
			var removedIDs = $.csControl.getCheckedValue('chkRow');
			var url = $.csCore.buildServicePath('/service/fabrictrader/deleteFabricTrader');
			$.csCore.removeData(url,removedIDs);
			$.csFabricTraderList.list(0);
		}
		,
		init:function(){
			$.csFabricTraderList.list(0);
			$.csFabricTraderList.bindEvent();
		}
};