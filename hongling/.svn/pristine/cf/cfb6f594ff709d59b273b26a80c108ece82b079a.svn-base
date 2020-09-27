jQuery.csPcssuitFabric={
		moduler:"FabricWareroom",
		fillBrands:function(){
			var datas = $.csCore.invoke($.csCore.buildServicePath('/service/fabricwareroom/getFabricTraderList'));
			$.csControl.fillOptions('searchBrands',datas , "id" , "traderName", $.csCore.getValue("Common_All"));
		}
		,
		fillCategory:function(){
			var datas=$.csCore.invoke($.csCore.buildServicePath('/service/fabric/getfabriccategorybytop'));
			$.csControl.fillOptions('searchCategory',datas , "ID" , "name", $.csCore.getValue("Common_All"));
		}
		,
		list:function(pageIndex){
			var param=$.csControl.getFormData("search");
			param=$.csControl.appendKeyValue(param,'pageindex',pageIndex);
			param=$.csControl.appendKeyValue(param,'searchCategory',8001);
			param=$.csControl.appendKeyValue(param,'status',10050);
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/fabricwareroom/getFabricWareroomList'),param);
			$.csCore.processList($.csPcssuitFabric.moduler, data);
			if(pageIndex==0){
				$.csCore.initPagination($.csPcssuitFabric.moduler + "Pagination", data.count, PAGE_SIZE, $.csPcssuitFabric.list);
			}
		}
		,
		query:function(){
			$.csPcssuitFabric.list(0);
		}
		,
		submitFabric:function(){
			var fabricCode = "";
			$('input[name="chRow"]:checked').each(function(){    
				fabricCode +=$(this).val()+",";    
	  	    });
			if(fabricCode!=""){
				if($.cookie("fabricType") == 0){
					$("#defaultFabric").val(fabricCode.substring(0, fabricCode.length-1));
				}
				if($.cookie("fabricType") == 1){
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
		}
		,
		checkAll : function(chkRow, chked){
	    	if($.cookie("fabricType") == 1){//推荐面料多选
	    		$('[name=' + chkRow + ']').each(function () { $(this).attr("checked", chked); });
	    	}
	    },
	    checkOnce : function (current) {
			if($.cookie("fabricType") == 0){//默认面料单选
				if($("#moreSelect").attr("checked") != "checked"){
					var checked = current.checked;
			        $("input[name='" + current.name + "']").attr("checked", false);
			        current.checked = checked;
				}
			}
	    },
		init:function(type){
			$.cookie("fabricType",type);
			$.csPcssuitFabric.fillBrands();
			$.csPcssuitFabric.fillCategory();
			$.csPcssuitFabric.list(0);
			$.csPcssuitFabric.bindEvent();
		}
};