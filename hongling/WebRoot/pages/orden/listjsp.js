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
		var member = $.csCore.getCurrentMember();
		if(member.userStatus == 10050){
			$("#btnSubmitMoreOrden").hide();
		}else{
			$("#btnPayMoreOrden").hide();
		}
		
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
		$("#btnOrdenStatistic").click(function(){$.csCore.loadModal('../orden/statistic.jsp',760,440,function(){$.csOrdenStatistic.init();});});
		$("#btnSubmitMoreOrden").click($.csOrdenList.getOrdenIds);
		$("#btnExportOrdenContent").click($.csOrdenList.exportOrdenContent);
		$("#btnPrintOrden").click($.csOrdenList.printOrden);
		$("#btnPayMoreOrden").click($.csOrdenList.payMoreOrden);
		 
	},
	viewStopCause: function(viewStopCause){
		$.csCore.alert(viewStopCause);
	},
	selectOrQuick: function () {
		$('[name=chkRow]').each(function () {
            if (this.checked == true) {
            	this.checked = false;
            }
        });
    },
	checkOnce: function (current) {
		if($("#moreSelect").attr("checked") != "checked"){
			var checked = current.checked;
	        $("input[name='" + current.name + "']").attr("checked", false);
	        current.checked = checked;
		}
    },
    getOrdenIds : function(){
    	var ordenIds="";
  	    $('input[name="chkRow"]:checked').each(function(){    
  	    	ordenIds +=$(this).val()+",";    
  	    });    
//  	  alert(chk_value.length==0 ?'你还没有选择任何内容！':chk_value);    
  	    if("" != ordenIds){
  	    	var param = $.csControl.appendKeyValue("","ordenIds",ordenIds);
  	    	param = $.csControl.appendKeyValue(param,"type","0");
  	    	var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/submitmoreorden'),param);
  	    	if(data != ""){
  	    		$.csCore.alert(data);
  	    	}
  	    	$.csOrdenList.list(0);
  	    }else{
  	    	$.csCore.alert($.csCore.getValue('Error_SelectOrden'));
  	    }
    },
    preSubmitOrden : function(ordenID){
    	$.csCore.loadModal('../orden/pre_commit.jsp',450,200,function(){$.csPre_commit.init(ordenID);});
    	/*var param = $.csControl.appendKeyValue("","ordenIds",ordenID);
    	param = $.csControl.appendKeyValue(param,"type","1");
    	var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/submitmoreorden'),param);
    	if(data != ""){
    		$.csCore.alert(data);
    	}*/
    },
    payMoreOrden : function(){//建行支付(批量)
    	var ordenIds="";
  	    $('input[name="chkRow"]:checked').each(function(){    
  	    	ordenIds +=$(this).val()+",";    
  	    });    
  	    if("" != ordenIds){
  	    	//待删除的批次号 发送给善融
  	    	var param = $.csControl.appendKeyValue("","ordenIds",ordenIds);
  	    	var data = $.csCore.invoke($.csCore.buildServicePath('/member/checkbatchno'),param);
  	    	if(data != ""){
  	    		$.csCore.alert(data);
  	    	}
  	    	if(data != "请选择待支付状态订单"){
    			//生成批次号 发送订单信息给善融
    			var param = $.csControl.appendKeyValue("","ordenIds",ordenIds);
    	    	var data = $.csCore.invoke($.csCore.buildServicePath('/member/batchpaymentorders'),param);
    	    	$("#payToCCB").html(data);
    	    	//发送订单明细信息
//  	    		$.csCore.invoke($.csCore.buildServicePath('/member/sendordendetail'));
  	    	}
  	    	
  	    	$.csOrdenList.list(0);
  	    }else{
  	    	$.csCore.alert($.csCore.getValue('Error_SelectOrden'));
  	    }
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
	//打开下单页面 
	openPost:function (){
		//新增  我的订单 弹出层
		if ($('#page_url').length <= 0) {
			if ($("#moreSelect").attr("checked") != "checked") {
				var selectedID = $.csControl.getCheckedValue("chkRow");
				$.csCore.loadModal('../orden/post.jsp', 1000, 510, function() {
					$.csOrdenPost.init(selectedID, true);
				});
			}
		}else{
			if ($("#moreSelect").attr("checked") != "checked") {
				var selectedID = $.csControl.getCheckedValue("chkRow");
				$('#ordenID2').val(selectedID);
				$('#copyFlag').val("0");
				// 快速下单页面
				var localObj = window.location;
				var contextPath = localObj.pathname.split("/")[1];
				var basePath = localObj.protocol + "//" + localObj.host + "/"
						+ contextPath;
				var server_context = basePath;
				if ($("#moreSelect").attr("checked") != "checked") {
					var selectedID = $.csControl.getCheckedValue("chkRow");
					$('#ordenID').val(selectedID);
				}
				$('#toAddOrdenJsp').attr('action',
						server_context + '/orden/add_ordenAction.do').submit();
			}
		}
	},
	openEdit:function (selectedID){
		if ($('#page_url').length <= 0) {
			//我的订单出
			$.csCore.loadModal('../orden/post.jsp',1000,600,function(){$.csOrdenPost.init(selectedID,false);});
		}else{
			//快速下单跳转
			$('#ordenID2').val(selectedID);
			$('#copyFlag').val("1");
			var localObj = window.location;
			var contextPath = localObj.pathname.split("/")[1];
			var basePath = localObj.protocol+"//"+localObj.host+"/"+contextPath;
			var server_context=basePath;
			$('#toAddOrdenJsp').attr('action',server_context+'/orden/add_ordenAction.do').submit();
		}
	},
	editJhrq:function (ID,JHRQ){
		if(JHRQ !=""){
			$.csCore.loadModal('../orden/jhrq.jsp',320,110,function(){$.csOrdenJhrq.init(ID,JHRQ,2);});
		}
	},
	remove:function (ordenID,status,companyID){
		if(status == "10039" && (companyID == "1002" || companyID == "1003")){//待支付、绑定的善融
			var url = $.csCore.buildServicePath("/member/removeordens");
			$.csCore.removeData(url,ordenID,$.csOrdenList.moduler + "Search");
			setTimeout(function(){$.csOrdenList.list(0);},3000);
		}else{
			var url = $.csCore.buildServicePath("/service/orden/removeordens");
			$.csCore.removeData(url,ordenID,$.csOrdenList.moduler + "Search");
		}
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
		var searchStatusID = $("#searchStatusID").val();
		var param =  $.csControl.getFormData('OrdenSearch');
		param = $.csControl.appendKeyValue(param,'pageindex',pageIndex);
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getordens'),param);
		$.csCore.processList($.csOrdenList.moduler, data);
		if (pageIndex == 0) {
			$.csCore.initPagination($.csOrdenList.moduler + "Pagination", data.count, PAGE_SIZE, $.csOrdenList.list);
		}
//		$.csOrdenCommon.bindLabel();
		$.csOrdenList.bindLabel();
		$.csOrdenList.fillStatus();
		$.csOrdenList.checkAccess();
		$("#searchStatusID").val(searchStatusID);
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
	exportOrdenContent:function(){//打印订单excel
		var ordenIds="";
  	    $('input[name="chkRow"]:checked').each(function(){    
  	    	ordenIds +=$(this).val()+",";    
  	    });    
  	    if("" != ordenIds){
  	    	var url = $.csCore.buildServicePath('/service/orden/exportordencontent?formData=');
  	    	url +="{'ordenIds':'"+ordenIds+"'}";
  	    	window.open(url);
  	    }
	},
	printOrden:function(){//打印订单html
		var ordenId="";
  	    $('input[name="chkRow"]:checked').each(function(){    
  	    	ordenId =$(this).val();    
  	    });    
  	    if("" != ordenId){
  	    	$.csCore.loadModal('../orden/print.jsp',1100,730,function(){$.csOrdenPrint.init(ordenId);});
  	    }
	},
	ordenToPay : function(ordenID,sysCode,userStauts,companyID,payTypeID){//待支付订单
		if(payTypeID == DICT_MEMBER_PAYTYPE_ONLINE && companyID == ''){//在线支付 未绑定善融
			var param = $.csControl.appendKeyValue("","sysCode",sysCode);
			var payToAlipay = $.csCore.invoke($.csCore.buildServicePath('/service/alipay/ordenpay'), param);
			$("#payToAlipay").html(payToAlipay);
		}else{//建行支付(单个)
			if(userStauts == "10050"){
				//待删除的批次号 发送给善融
				var para = $.csControl.appendKeyValue("","ordenID",ordenID);
				para = $.csControl.appendKeyValue(para,"sysCode",sysCode);
				$.csCore.invoke($.csCore.buildServicePath('/member/checkbatchno'), para);
				//生成批次号 发送订单信息给善融
				var param = $.csControl.appendKeyValue("","ordenID",ordenID);
				param = $.csControl.appendKeyValue(param,"sysCode",sysCode);
				var payToCCB = $.csCore.invoke($.csCore.buildServicePath('/member/ordensecondpaytosr'), param);
				$("#payToCCB").html(payToCCB);
				//发送订单明细信息
//		    	$.csCore.invoke($.csCore.buildServicePath('/member/sendordendetail'));
				$.csOrdenList.list(0);
			}else if(companyID == "1002"){//红领
				window.open("http://mall.ccb.com/alliance/gologin.php?cpcode=1002");
			}else if(companyID == "1003"){//凯妙
				window.open("http://mall.ccb.com/alliance/gologin.php?cpcode=1003");
			}
		}
	},
	init:function(){
//		$.csOrdenCommon.bindLabel();
		$.csOrdenList.bindLabel();
		$.csOrdenList.bindEvent();
		$.csOrdenList.fillClothing();
		$.csOrdenList.fillClient();
		$.csOrdenList.fillOverdue();
//		$.csOrdenList.fillStatus();
		$.csOrdenList.list(0);
	}
};