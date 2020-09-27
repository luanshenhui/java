jQuery.csFabricList={
	moduler : "Fabric",
	modulerPiece : "FabricPiece",
	modulerOccupy: "FabricOccupy",
	checkAccess:function(){
		if($.csCore.isAdmin() == false){
			$("#btnCreateFabric,#btnRemoveFabric,.edit,.lblEdit,.list_result .check").hide();
			$(".edit").parent().hide();
		}
	},
	bindEvent:function (){
		$("#btnSearch").click($.csFabricList.searchFabric);
		$("#searchSupplyCategoryID").change($.csFabricList.changeViewState);
		$("#btnRemoveFabric").click($.csFabricList.remove);
		$("#btnCreateFabric").click(function(){$.csFabricList.openPost(null);});
		$("#btnExportFabric").click($.csFabricList.exportFabrics);
		$('#btnOccupyView').click($.csFabricList.openOccupyList);
		$('#categoryID').change($.csFabricList.fillFormSeriesColorFlowerComposition);
		$.csDate.datePicker("arriveDate");
		$.csCore.pressEnterToSubmit('keyword','btnSearch');
	},
	changeViewState:function(){
		var supplyCategoryID = $("#searchSupplyCategoryID").val();
		if(supplyCategoryID == DICT_FABRIC_SUPPLY_CATEGORY_REDCOLLAR){
			$(".lblArriveDate").hide();
			$("#arriveDate").hide();
			$("#isValid").hide();
			$(".occupy").parent().show();
			$(".lblOccupy").show();
		}else if(supplyCategoryID == DICT_FABRIC_SUPPLY_CATEGORY_CLIENT_LARGE){
			$(".lblArriveDate").hide();
			$("#arriveDate").hide();
			$("#isValid").hide();
			$(".occupy").parent().hide();
			$(".lblOccupy").hide();
		}
		else if(supplyCategoryID == DICT_FABRIC_SUPPLY_CATEGORY_CLIENT_PIECE){
			$(".lblArriveDate").show();
			$("#arriveDate").show();
			$("#isValid").show();
		}
		$.csFabricList.searchFabric();
	},
	openPost:function (id){
		$.csCore.loadModal('../fabric/post.htm',800,500,function(){$.csFabricPost.init(id);});
	},
	openOccupy:function (code){
		$.csCore.loadModal('../fabric/occupy.htm',600,400,function(){$.csFabricOccupy.init(code);});
	},
	openOccupyList:function (){
		$.csCore.loadModal('../fabric/occupylist.htm',800,500,function(){$.csFabricOccupyList.init();});
	},
	fillSearchCategory:function (){
	    $.csControl.fillOptions('searchCategoryID',$.csCore.invoke($.csCore.buildServicePath('/service/fabric/getfabriccategorybytop')), "ID" , "name", $.csCore.getValue("Common_PleaseSelect","Fabric_Category"));
	},
	fillSearchIsValid:function (){
	    $.csControl.fillOptions('isValid',$.csCore.getDicts(DICT_CATEGORY_CLIENT_PIECE_VALID), "ecode" , "name", $.csCore.getValue("Common_PleaseSelect"," "));
	},
	fillSearchSupplyCategory:function (){
	    $.csControl.fillOptions('searchSupplyCategoryID',$.csCore.getDicts(DICT_CATEGORY_FABRIC_SUPPLY_CATEGORY), "ID" , "name", "");
	},
	fillFabricSupplyCategory:function (){
	    $.csControl.fillOptions('fabricSupplyCategoryID',$.csCore.getDicts(DICT_CATEGORY_FABRIC_SUPPLY_CATEGORY), "ID" , "name", "");
	    $('#fabricSupplyCategoryID option:last').remove();
	},
	releaseFabric:function (fabricID,ordenId){
		var url = $.csCore.buildServicePath("/service/fabric/releasefabric");
		$.csCore.confirm($.csCore.getValue('Fabric_ReleaseConfirm'),"$.csOrdenList.releaseDo('"+url+"','"+fabricID+"','"+ordenId+"')");
	},
	releaseDo:function(url,id,ordenId){
		$.ajax({
			url: url,
			data:{id:id,ordenId:ordenId},
			type: "post",
			dataType:"json",
			async: false,
			success: function (data, textStatus, jqXHR){
				if(!$.csValidator.isNull(data)){
					if(data == "OK"){
						$.csOrdenList.list(0);
					}
					else{
						$.csCore.alert(data);
					}
				}
			},
			error: function (xhr) { $.csCore.alert("error:" + xhr.responseText);}
		});
	},
	remove:function (){
		var removedIDs = $.csControl.getCheckedValue('chkRow');
		var url = $.csCore.buildServicePath('/service/fabric/removefabrics');
		$.csCore.removeData(url,removedIDs);
	},
	searchFabric:function(){
		if($('#searchSupplyCategoryID').val() == DICT_FABRIC_SUPPLY_CATEGORY_CLIENT_PIECE){
			$.csFabricList.listPiece(0);
		}else{
			$.csFabricList.list(0);
		}
	},
	list:function (pageIndex){
		$('#' + $.csFabricList.modulerPiece + 'Result').html('');
		$('#' + $.csFabricList.modulerPiece + 'Statistic').html('');
		$('#' + $.csFabricList.modulerPiece + 'Pagination').html('');
	    var data = $.csFabricList.getSearchResult(pageIndex);
	    $.csCore.processList($.csFabricList.moduler, data);
	    if (pageIndex == 0) {
	        $.csCore.initPagination($.csFabricList.moduler + "Pagination", data.count, PAGE_SIZE, $.csFabricList.list);
	    }
	    $.csFabricCommon.bindLabel();
	    $.csFabricList.checkAccess();
	},
	listPiece:function (pageIndex){
		//客供小块料
		$('#' + $.csFabricList.moduler + 'Result').html('');
		$('#' + $.csFabricList.moduler + 'Statistic').html('');
		$('#' + $.csFabricList.moduler + 'Pagination').html('');
	    var data = $.csFabricList.getSearchResult(pageIndex);
	    $.csCore.processList($.csFabricList.modulerPiece, data);
	    if (pageIndex == 0) {
	        $.csCore.initPagination($.csFabricList.modulerPiece + "Pagination", data.count, PAGE_SIZE, $.csFabricList.listPiece);
	    }
	    $.csFabricCommon.bindLabel();
	    $.csFabricList.checkAccess();
	},
	getSearchResult:function(pageIndex){
		var url = $.csCore.buildServicePath('/service/fabric/getfabrics');
	    var param = $.csFabricList.buildSearchParam();
	    param = param.replace("%","tmpstr");
	    param = $.csControl.appendKeyValue(param,"pageindex",pageIndex);
	    return $.csCore.invoke(url,param);
	},
	exportFabrics:function(){
		var url = $.csCore.buildServicePath('/service/fabric/exportfabrics?formData=' + $.csFabricList.buildSearchParam());
		window.open(url);
	},
	buildSearchParam:function(){
		var param = $.csControl.appendKeyValue("","keyword",$('#keyword').val());
		param = $.csControl.appendKeyValue(param,"categoryid",$('#searchCategoryID').val());
		param = $.csControl.appendKeyValue(param,"supplycategoryid",$('#searchSupplyCategoryID').val());
		param = $.csControl.appendKeyValue(param,"isvalid",$('#isValid').val());
		param = $.csControl.appendKeyValue(param,"arrivedate",$('#arriveDate').val());
		return param;
	},
	init:function(){
		$.csFabricCommon.bindLabel();
		$.csFabricList.bindEvent();
		$.csFabricList.fillSearchSupplyCategory();
		$.csFabricList.fillSearchCategory();
		$.csFabricList.fillSearchIsValid();
		$.csFabricList.fillFabricSupplyCategory();
		$.csFabricList.changeViewState();
	}
};
