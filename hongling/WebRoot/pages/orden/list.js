jQuery.csOrdenList={
	moduler : "Orden",
	checkAccess:function(){
		if($.csCore.isAdmin() == false){
			$("#btnStatement").hide();
		}else{
			$("#btnCreateOrden,#btnDelivery,#btnDeliverySetting").hide();
		}
	},
	bindLabel:function (){
		$.csCore.getValue($.csCore.getDictResourceName(DICT_BACKEND_MENU_ORDEN_MANAGER),null,".list_search h1");
		$.csCore.getValue("Orden_ClothingCategory",null,".lblClothingCategory");
		$.csCore.getValue("Common_Status",null,".lblStatus");
		$.csCore.getValue("Member_Username",null,".lblMemberName");
		$.csCore.getValue("Common_Keyword",null,".lblKeyword");
		$.csCore.getValue("Button_FastSubmitOrden",null,"#btnCreateOrden");
		$.csCore.getValue("Button_Export",null,"#btnExportOrdens");
		$.csCore.getValue("Delivery_Details",null,"#btnStatement");
		$.csCore.getValue("Orden_Statistic",null,"#btnOrdenStatistic");
		$.csCore.getValue("Orden_PubDate",null,".lblPubDate");
		$.csCore.getValue("Orden_DealDate",null,".lblDealDate");
		$.csCore.getValue("Button_Search",null,"#btnSearch");
		$.csCore.getValue("Orden_Number",null,".lblNumber");
		$.csCore.getValue("Orden_Code",null,".lblCode");
		$.csCore.getValue("Orden_ClothingCategory",null,".lblClothingCategory");
		$.csCore.getValue("Customer_Name",null,".lblName");
		$.csCore.getValue("Fabric_Moduler",null,".lblFabric");
		$.csCore.getValue("Orden_PubDate",null,".lblPubDate");
		$.csCore.getValue("Delivery_Date",null,".lblDeliveryDate");
		$.csCore.getValue("Orden_DealDate",null,".lblDealDate");
		$.csCore.getValue("Delivery_Status",null,".lblDeliveryStatus");
		$.csCore.getValue("Common_Status",null,".lblStatus");
		$.csCore.getValue("Button_Do",null,".lblDo");
		$.csCore.getValue("Orden_StopCause",null,".lblStopCause");
	},
	bindEvent:function (){
		$.csDate.datePicker("fromDate", $.csDate.getLastYear());
		$.csDate.datePicker("toDate");
		$.csDate.datePickerNull("dealDate");
		$.csDate.datePickerNull("dealToDate");
		$.csCore.pressEnterToSubmit('keyword','btnSearch');
		$("#btnSearch").click(function(){$.csOrdenList.list(0);});
		$("#btnCreateOrden").click($.csOrdenList.openPost);
		$("#btnExportOrdens").click($.csOrdenList.exportOrdens);
		$("#btnStatement").click($.csOrdenList.exportStatement);
		$("#btnOrdenStatistic").click(function(){$.csCore.loadModal('../orden/statistic.htm',760,440,function(){$.csOrdenStatistic.init();});});
	},
	fillClient:function (){
		var datas = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getordensclient'));
	    $.csControl.fillOptions('searchClientID',datas , "ID" , "name", $.csCore.getValue("Common_All"));
	},
	fillClothing:function (){
		var datas = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getclothing'));
	    $.csControl.fillOptions('searchClothingID',datas , "ID" , "name", $.csCore.getValue("Common_All"));
	},
	fillStatus:function (){
		var param =  $.csControl.getFormData('OrdenSearch');
		var datas = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getstatusstatistic'), param);
	    $.csControl.fillOptions('searchStatusID',datas , "ID" , "name", $.csCore.getValue("Common_All"));
	},
	openPost:function (){
		var selectedID = $.csControl.getCheckedValue("chkRow");
		$.csCore.loadModal('../orden/post.htm',920,510,function(){$.csOrdenPost.init(selectedID,true);});
	},
	openEdit:function (selectedID){
		$.csCore.loadModal('../orden/post.htm',920,510,function(){$.csOrdenPost.init(selectedID,false);});
	},
	editJhrq:function (ID,JHRQ){
		if(JHRQ !=""){
			$.csCore.loadModal('../orden/jhrq.htm',320,110,function(){$.csOrdenJhrq.init(ID,JHRQ);});
		}
	},
	remove:function (ordenID){
		var url = $.csCore.buildServicePath("/service/orden/removeordens");
		$.csCore.removeData(url,ordenID,$.csOrdenList.moduler + "Search");
	},
	approveOrden:function (ordenID){
		var url = $.csCore.buildServicePath("/service/orden/approveorden");
		$.csCore.confirm($.csCore.getValue('Orden_ApproveConfirm'),"$.csOrdenList.approveDo('"+url+"','"+ordenID+"')");
	},
	approveDo:function(url,id){
		$.ajax({
			url: url,
			data:{id:id},
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
	rejectOrden:function (ordenID){
		var url = '../orden/confirm.htm';
		$.csCore.loadModal(url,760,440,function(){$.csOrdenConfirm.init(ordenID);});
	},
	list:function (pageIndex){
		var param =  $.csControl.getFormData('OrdenSearch');
		param = $.csControl.appendKeyValue(param,'pageindex',pageIndex);
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getordens'),param);
		$.csCore.processList($.csOrdenList.moduler, data);
		if (pageIndex == 0) {
			$.csCore.initPagination($.csOrdenList.moduler + "Pagination", data.count, PAGE_SIZE, $.csOrdenList.list);
		}
//		$.csOrdenCommon.bindLabel();
		$.csOrdenList.bindLabel();
		$.csOrdenList.checkAccess();
	},
	fillOverdue:function(){
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getoverduecount'));
		if($.csValidator.isNull(data)){
			data = 0;
		}
		$('#overdue').html($.csCore.getValue("Orden_OverDueStatistic") + " : " + data);
	},
	openView:function (id){
		$.csCore.loadModal('../orden/view.jsp',964,540,function(){$.csOrdenView.init(id);});
	},
	exportOrdens:function(){
		var url = $.csCore.buildServicePath('/service/orden/exportordens?formData=');
		url += $.csControl.getFormData('OrdenSearch');
		window.open(url);
	},
	exportStatement:function(){
		if($.csValidator.checkNull("searchClientID",$.csCore.getValue("Common_PleaseSelect","Common_Client"))){
			return false;
		}
		var url = $.csCore.buildServicePath('/service/orden/exportstatement?formData=');
		url +=$.csControl.getFormData('OrdenSearch');
		window.open(url);
	},
	isStop:function (ordenID,isStop){
		if(isStop > DICT_YES){
			var url = '../orden/stop.htm';
			$.csCore.loadModal(url,560,240,function(){$.csOrdenStop.init(ordenID);});
		}else{	
			var url = $.csCore.buildServicePath("/service/orden/ordenstopcause"+"?ordenID="+ordenID+"&stopCauseID=-1");
			$.csCore.confirm($.csCore.getValue('Common_StopConfirm'),"$.csOrdenList.cancelStop('"+url+"','')");
		}
	},
	cancelStop:function(url,param){
		$.ajax({
			url: url,
			data:param,
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
	init:function(){
//		$.csOrdenCommon.bindLabel();
		$.csOrdenList.bindLabel();
		$.csOrdenList.bindEvent();
		$.csOrdenList.fillClothing();
		$.csOrdenList.fillClient();
		$.csOrdenList.fillOverdue();
		$.csOrdenList.fillStatus();
		$.csOrdenList.list(0);
	}
};