jQuery.csPcssuitAssemble={
		moduler:"Assemble",
		list:function(pageIndex,type){
			var param = $.csControl.getFormData('SearchPcssuitAssemble');
			param = $.csControl.appendKeyValue(param, 'pageindex', pageIndex);
			param = $.csControl.appendKeyValue(param, 'type', type);
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/assemble/listAssembleByType'), param);
			$.csCore.processList($.csPcssuitAssemble.moduler, data);
			if(pageIndex==0){
				$.csCore.initPagination($.csPcssuitAssemble.moduler + "Pagination", data.count, PAGE_SIZE, $.csPcssuitAssemble.list);
			}
		}
		,
		fillStyle:function(type){
			var datas=$.csCore.invoke($.csCore.buildServicePath('/service/assemble/getStyleListByType'),type);
			$.csControl.fillOptions('searchStyleID',datas, "ID" , "name", $.csCore.getValue("Common_All"));
		}
		,
		search:function(type){
			$.csPcssuitAssemble.list(0,type);
		}
		,
		checkOnce : function (current) {
			var checked = current.checked;
	        $("input[name='" + current.name + "']").attr("checked", false);
	        current.checked = checked;
		}
		,
		submitStyle:function(type){
			var styleCode = "";
			$('input[name="chkRow"]:checked').each(function(){    
				styleCode =$(this).val();    
	  	    });
			if(styleCode!=""){
				if(type==3){
					$("#style_3").val(styleCode);
				}
				if(type==2000){
					$("#style_2000").val(styleCode);
				}
				if(type==4000){
					$("#style_4000").val(styleCode);
				}
			}
			$.csCore.close();
		}
		,
		bindEvent:function(type){
			$("#btnsearch").click(function(){$.csPcssuitAssemble.search(type);});
			$("#btnsumbit").click(function(){$.csPcssuitAssemble.submitStyle(type);});
		}
		,
		init:function(type){
			$.csPcssuitAssemble.bindEvent(type);
			$.csPcssuitAssemble.fillStyle(type);
			$.csPcssuitAssemble.list(0,type);
		}
};