jQuery.csFabricWareroomList={
		moduler:"FabricWareroom",
		fillBrands:function(){
			var datas = $.csCore.invoke($.csCore.buildServicePath('/service/fabricwareroom/getFabricTraderList'));
			$.csControl.fillOptions('searchBrands',datas , "id" , "traderName", $.csCore.getValue("Common_All"));
		}
		,
		fillCategory:function(){
			var datas=$.csCore.invoke($.csCore.buildServicePath('/service/fabric/getfabriccategorybytop'));
			$.csControl.fillOptions('searchCategory',datas, "ID" , "name", $.csCore.getValue("Common_All"));
			$("#searchCategory").change(function(){$.csFabricWareroomList.fillProperty($.csControl.appendKeyValue("",'categoryid',$("#searchCategory").val()));});
		}
		,
		fillStatus:function(){
			dom="";
			dom+="<option value='10050'>是</option>";
			dom+="<option value='10051'>否</option>";
			$("#status").html(dom);
		}
		,
		fillBelong:function(){
			dom="";
			dom+="<option>--请选择--</option>";
			dom+="<option>电商</option>";
			dom+="<option>青岛瑞璞服饰股份有限公司</option>";
			dom+="<option>RCMTM</option>";
			dom+="<option>青岛rcmtm制衣有限公司</option>";
			dom+="<option>青岛红领制衣有限公司</option>";
			dom+="<option>青岛凯妙服饰股份有限公司</option>";
			dom+="<option>大中华区</option>";
			dom+="<option>美洲区</option>";
			dom+="<option>欧洲区</option>";
			$("#belong").html(dom);
		}
		,
		list:function(pageIndex){
			var param=$.csControl.getFormData("search");
			param=$.csControl.appendKeyValue(param,'belong',$('#belong').val());
			param=$.csControl.appendKeyValue(param,'status',$('#status').val());
			var obj = eval('(' + param + ')');
			if(obj.searchProperty=="null"){
				obj.searchProperty='';
			}
			if(obj.searchProperty=='-1'){
				obj.searchProperty='';
			}
			param=JSON.stringify(obj);
			param=$.csControl.appendKeyValue(param,'pageindex',pageIndex);
			
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/fabricwareroom/getFabricWareroomList'),param);
			$.csCore.processList($.csFabricWareroomList.moduler, data);
			if(pageIndex==0){
				$.csCore.initPagination($.csFabricWareroomList.moduler + "Pagination", data.count, PAGE_SIZE, $.csFabricWareroomList.list);
			}
		}
		,
		bindEvent:function(){
			$("#btnquery").click(function(){$.csFabricWareroomList.query();});
			$("#btnadd").click(function(){$.csFabricWareroomList.openPost(null,$("#exchange").val());});
			$("#btndelete").click(function(){$.csFabricWareroomList.remove();});
			$("#changeRate").click(function(){$.csFabricWareroomList.changeRate($("#exchange").val(),$("#uachange").val());});
			$("#upload").click(function(){$.csFabricWareroomList.upload();});
			$('#puton').click(function(){$.csFabricWareroomList.puton('chkRow');});
			$('#exportOn').click(function(){$.csFabricWareroomList.exportOn();});
		}
		,
		exportOn:function(){
			var url = $.csCore.buildServicePath('/service/fabricwareroom/exportFabricWarerooms?formData=' + $.csFabricWareroomList.buildSearchParam());
			window.open(url);
		}
		,
		buildSearchParam:function(){
			var param = $.csControl.appendKeyValue("","searchFabricNo",$('#searchFabricNo').val());
			param = $.csControl.appendKeyValue(param,"searchProperty",$('#searchProperty').val());
			param = $.csControl.appendKeyValue(param,"searchBrands",$('#searchBrands').val());
			param = $.csControl.appendKeyValue(param,"searchCategory",$('#searchCategory').val());
			param = $.csControl.appendKeyValue(param,"belong",$('#belong').val());
			param = $.csControl.appendKeyValue(param,"status",$('#status').val());
			var obj = eval('(' + param + ')');
			if(obj.searchProperty=="null"){
				obj.searchProperty='';
			}
			if(obj.searchProperty=='-1'){
				obj.searchProperty='';
			}
			param=JSON.stringify(obj);
			return param;
		}
		,
		puton:function(chkRow){
			//获取多选框的值
			var str="";
			var $chkRowck=$("input:checkbox[name='"+chkRow+"']:checked");
			if($chkRowck.length>0){
				$chkRowck.each(function(){
					str+=$(this).val()+",";
				});
				param=$.csControl.appendKeyValue("",'ids',str);
				var data=$.csCore.invoke($.csCore.buildServicePath('/service/fabrictrader/updateFabricWareroomStatus'),param);
				if(data=='OK'){
					$.csFabricWareroomList.list(0);
				}
			}
			else
			{	
				$.csCore.alert("请至少选择一项下架产品");
			}
			
			
		}
		,
		upload:function(){
			$.csCore.loadModal('../fabricwareroom/import.jsp', 600, 300, function() {
			$.csImportFabricWareroom.init();
		});
		}
		,
		fillProperty:function(param){
			var datas=$.csCore.invoke($.csCore.buildServicePath('/service/fabric/getpropettybycategory'),param);
			$.csControl.fillOptions('searchProperty',datas, "ID" , "name", $.csCore.getValue("Common_All"));
		}
		,
		openView:function(id){
			$.csFabricWareroomList.openPost(id,$("#exchange").val());
		}
		,
		openV:function(id){
			$.csCore.loadModal('../fabricwareroom/view.jsp',650,300,function(){$.csFabricWareroomView.init(id);});
		}
		,
		changeRate:function(us,cn){
			$.csCore.loadModal('../fabricwareroom/changeRate.jsp',350,150,function(){$.csFabricWareroomChange.init(us,cn);});
		}
		,
		remove:function(){
			var removedIDs = $.csControl.getCheckedValue('chkRow');
			var url = $.csCore.buildServicePath('/service/fabrictrader/deleteFabricWareroom');
			$.csCore.removeData(url,removedIDs);
			$.csFabricWareroomList.list(0);
		}
		,
		openPost:function(ID,ex){
			$.csCore.loadModal('../fabricwareroom/post.jsp',650,300,function(){$.csFabricWareroomPost.init(ID,ex);});
		}
		,
		query:function(){
			$.csFabricWareroomList.list(0);
		}
		,
		getEx:function(){
			var daex=$.csCore.invoke($.csCore.buildServicePath('/service/fabrictrader/getExRateFabricWareroom'));
			$("#exchange").val(daex);
			var daus=$.csCore.invoke($.csCore.buildServicePath('/service/fabrictrader/getUsRateFabricWareroom'));
			$("#uachange").val(daus);
		}
		,
		init:function(){
			$.csFabricWareroomList.fillStatus();
			$.csFabricWareroomList.fillBrands();
			$.csFabricWareroomList.fillCategory();
			$.csFabricWareroomList.fillBelong();
			$.csFabricWareroomList.list(0);
			$.csFabricWareroomList.getEx();
			$.csFabricWareroomList.bindEvent();
		}
};