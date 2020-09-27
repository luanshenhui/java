jQuery.csAssembleFabric={
		moduler:"FabricWareroom",
		fillBrands:function(){
			var datas = $.csCore.invoke($.csCore.buildServicePath('/service/fabricwareroom/getFabricTraderList'));
			$.csControl.fillOptions('searchBrands',datas , "id" , "traderName", $.csCore.getValue("Common_All"));
		}
		,
		fillProperty:function(clothingCategory){
			var param = $.csControl.appendKeyValue("",'categoryid',clothingCategory);
			var datas=$.csCore.invoke($.csCore.buildServicePath('/service/fabric/getpropettybycategory'),param);
			$.csControl.fillOptions('property',datas, "ID" , "name", $.csCore.getValue("Common_All"));
		}
		,
		list:function(pageIndex,clothingCategory){
			if(clothingCategory == undefined){
				clothingCategory = $("#clothingCategory").val();
			}
			var property = $("#property").val();
			if(property == -1){
				property = "";
			}
			var param=$.csControl.getFormData("search");
			param=$.csControl.appendKeyValue(param,'pageindex',pageIndex);
			param=$.csControl.appendKeyValue(param,'searchCategory',clothingCategory);
			param=$.csControl.appendKeyValue(param,'searchProperty',property);
			param=$.csControl.appendKeyValue(param,'status',10050);
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/fabricwareroom/getFabricWareroomList'),param);
			$.csCore.processList($.csAssembleFabric.moduler, data);
			if(pageIndex==0){
				$.csCore.initPagination($.csAssembleFabric.moduler + "Pagination", data.count, PAGE_SIZE, $.csAssembleFabric.list);
			}
		}
		,
		bindEvent:function(){
			$("#btnquery").click(function(){$.csAssembleFabric.query();});
			$("#btnsubmit").click(function(){$.csAssembleFabric.submitFabric();});
		},
		submitFabric : function(){//保存面料
			var fabricCode = "";
			$('input[name="chkRows"]:checked').each(function(){  
				fabricCode +=$(this).val()+",";    
	  	    });
			if(fabricCode != ""){
				if($.cookie("assemble_fabricType") == 0){//默认面料
					$("#defaultFabric").val(fabricCode.substring(0, fabricCode.length-1));
				}else if($.cookie("assemble_fabricType") == 1){//推荐面料
					var fabricCodes = $("#fabrics").val()+ fabricCode;
					var arr = new Array(); 
					arr = fabricCodes.split(",");
					for(var i=0;i<arr.length;i++){
					    for(var j=i+1;j<arr.length;j++){
						    if(arr[j]==arr[i]){
						    	arr.splice(j,1);
						    }
					    }
				    }
					$("#fabrics").val(arr.join(","));
				}
			}
			$.csCore.close();
		},
		query:function(){
			$.csAssembleFabric.list(0);
		}
		,
		checkOnce : function (current) {
			if($.cookie("assemble_fabricType") == 0){//默认面料单选
				if($("#moreSelect").attr("checked") != "checked"){
					var checked = current.checked;
			        $("input[name='" + current.name + "']").attr("checked", false);
			        current.checked = checked;
				}
			}
	    },
	    checkAll : function(chkRow, chked){
	    	if($.cookie("assemble_fabricType") == 1){//推荐面料多选
	    		$('[name=' + chkRow + ']').each(function () { $(this).attr("checked", chked); });
	    	}
	    },
		init:function(type,clothingCategory){
			if(clothingCategory == 6000){//大衣
				clothingCategory = 8050;
			}else if(clothingCategory == 3000){//衬衣
				clothingCategory = 8030;
			}else{//西装礼服
				clothingCategory = 8001;
			}
			$("#clothingCategory").val(clothingCategory);//面料服装类别
			$.cookie("assemble_fabricType",type);//面料类型
			$.csAssembleFabric.fillBrands();
			$.csAssembleFabric.fillProperty(clothingCategory);
			$.csAssembleFabric.list(0,clothingCategory);
			$.csAssembleFabric.bindEvent();
		}
};