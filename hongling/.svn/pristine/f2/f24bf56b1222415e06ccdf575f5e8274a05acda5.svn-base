jQuery.csPcsSuitList={
		moduler:"PcsSuit",
		list:function(pageIndex){
			var param=$.csControl.getFormData("search");
			param=$.csControl.appendKeyValue(param,'pageindex',pageIndex);
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/kitstyle/getkitstyles'),param);
			$.csCore.processList($.csPcsSuitList.moduler, data);
			if(pageIndex==0){
				$.csCore.initPagination($.csPcsSuitList.moduler + "Pagination", data.count, PAGE_SIZE, $.csPcsSuitList.list);
			}
		},
		bindEvent:function(){
			$.csDate.datePicker("fromDate", $.csDate.getLastYear());
			$.csDate.datePicker("toDate");
			$("#btnquery").click(function(){$.csPcsSuitList.query();});
			$("#btnadd").click(function(){$.csPcsSuitList.openPost("");});
			$("#btndelete").click(function(){$.csPcsSuitList.remove();});
			$.csAssembleCommon.fillStyleIDS(3);//款式风格
		},
		query:function(){
			$.csPcsSuitList.list(0);
		}
		,
		openView:function(id){
			$.csCore.loadModal('../style_pcssuit/view.jsp',600,250,function(){$.csPcsSuitView.init(id);});
		},
		remove:function(){
			var removedIDs = $.csControl.getCheckedValue('chkRow');
			var url = $.csCore.buildServicePath('/service/kitstyle/removekitstyles');
			$.csCore.removeData(url,removedIDs);
			$.csPcsSuitList.list(0);
		},
		openPost:function(id){
			$.csCore.loadModal('../style_pcssuit/post.jsp',650,300,function(){$.csPcsSuitPost.init(id);});
		},
		init:function(){
			$.csPcsSuitList.bindEvent();
			$.csPcsSuitList.list(0);
		}
};