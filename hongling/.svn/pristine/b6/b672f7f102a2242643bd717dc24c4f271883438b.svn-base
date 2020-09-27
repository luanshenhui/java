jQuery.dorden_page={
		bindEvent:function(){
			$.csDate.datePicker("fromDate", $.csDate.getLastYear());
			$.csDate.datePicker("toDate");
			$.csDate.datePickerNull("dealDate");
			$.csDate.datePickerNull("dealToDate");
			$("#signOut").click($.csCore.signOut);
			$('#btnsearch').click(function(){$.dorden_page.search();});
			//快速下单
			$("#btnCreateOrden").click($.dorden_page.openPost);
			//导出
			$("#btnExportOrdens").click($.dorden_page.exportOrdens);
			//发货明细
			//$("#btnStatement").click($.dorden_page.exportStatement);
			//订单统计
			$("#btnOrdenStatistic").click(function(){
				$.csCore.loadModal('../pages/orden/statistic.jsp',760,440,function(){$.csOrdenStatistic.init();});});
			//批量提交
			$("#btnSubmitMoreOrden").click($.dorden_page.getOrdenIds);
			//批量支付
			$("#btnPayMoreOrden").click($.dorden_page.payMoreOrden);
			//订单导出
			$("#btnExportOrdenContent").click($.dorden_page.exportOrdenContent);
			//订单打印
			$("#btnPrintOrden").click($.dorden_page.printOrden);
			
			$("#openEdit").click(function(){alert($('#xxordenID').val());});
			
			//搜索项
			$("#searchClothingID").val("-1");
			if($.cookie("ordenSearchUrl") != null){
				var arr = new Array();
				var arrs = new Array();
				var jsons = $.cookie("ordenSearchUrl");
				arr=jsons.split("&");
				for(var i=0;i<arr.length;i++){
					var arrJson =arr[i];
					arrs = arrJson.split("=");
					$("#"+arrs[0]).val(arrs[1]);
				}
			}
		}
		,
		viewStopCause: function(viewStopCause,memo){
			if(memo !="{null}" && memo != "{提交BL 失败}"){
				memo = memo.replace("{","");
				memo = memo.replace("}","");
				var arr = new Array();
				arr = memo.split(",");
				if(arr.length>1){
					var cause =$.csCore.getValue("Fabric_Message_"+arr[0])+" "+arr[1]+" "+$.csCore.getValue("FabricSize_Message_2")+arr[2]+$.csCore.getValue("FabricSize_Message_1")+arr[3];
					$.csCore.alert(cause);
				}else{
					$.csCore.alert(memo);
				}
				
			}else{
				viewStopCause = viewStopCause.replace("{","");
				viewStopCause = viewStopCause.replace("}","");
				$.csCore.alert(viewStopCause);
			}
		}
		,
		openView:function (id){
			$.csCore.loadModal('../pages/orden/view.jsp',964,540,function(){$.csOrdenView.init(id);});
		}
		,
		openPost:function(){
			var len=$('input[name="chkRow"]:checked').length;
			if(len == 0){
				$('#ordenID2').val('');
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
						server_context + '/orden/addOrdenAction.do').submit();
			}else if(len = 1){
				//复制
				var selectedID = $('input[name="chkRow"]:checked').val();
				$('#ordenID2').val(selectedID);
				$('#copyFlag').val("1");
				
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
						server_context + '/orden/editOrdenAction.do').submit();
			}
			
		}
		,
		editJhrq:function (ID,JHRQ){
			if(JHRQ !=""){
				$.csCore.loadModal('../pages/orden/jhrq.jsp',320,110,function(){$.csOrdenJhrq.init(ID,JHRQ,1);});
			}
//			setTimeout(function(){window.location.href='/hongling/orden/dordenPage.do'},3000);
		}
		,
		exportStatement:function(){
			if($.csValidator.checkNull("searchClientID",$.csCore.getValue("Common_PleaseSelect","Common_Client"))){
				return false;
			}
			var url = $.csCore.buildServicePath('/service/orden/exportstatement?formData=');
			url +=$.csControl.getFormData('OrdenSearch');
			window.open(url);
		}
		,
		getOrdenIds : function(){
	    	var ordenIds="";
	  	    $('input[name="chkRow"]:checked').each(function(){    
	  	    	ordenIds +=$(this).val()+",";    
	  	    });
	  	    if("" != ordenIds){
	  	    	var param = $.csControl.appendKeyValue("","ordenIds",ordenIds);
	  	    	param = $.csControl.appendKeyValue(param,"type","0");
	  	    	var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/submitmoreorden'),param);
	  	    	if(data != ""){
	  	    		$.csCore.alert(data);
	  	    	}
	  	    	if($.cookie("ordenSearchUrl") != null){
    				window.location.href='/hongling/orden/dordenPage.do?'+$.cookie("ordenSearchUrl");
    			}else{
    				window.location = this.getPath() + '/orden/ordenListPage_transitAction.do';
    			}
	  	    }else{
	  	    	$.csCore.alert($.csCore.getValue('Error_SelectOrden'));
	  	    }
	    }
		,
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
//	  	    		$.csCore.invoke($.csCore.buildServicePath('/member/sendordendetail'));
	  	    	}
	  	    	
	  	    	if($.cookie("ordenSearchUrl") != null){
    				window.location.href='/hongling/orden/dordenPage.do?'+$.cookie("ordenSearchUrl");
    			}else{
    				window.location = this.getPath() + '/orden/ordenListPage_transitAction.do';
    			}
	  	    }else{
	  	    	$.csCore.alert($.csCore.getValue('Error_SelectOrden'));
	  	    }
	    },
		printOrden:function(){//打印订单html
			var ordenId="";
	  	    $('input[name="chkRow"]:checked').each(function(){    
	  	    	ordenId =$(this).val();    
	  	    });    
	  	    if("" != ordenId){
	  	    	$.csCore.loadModal('../pages/orden/print.jsp',1100,730,function(){$.csOrdenPrint.init(ordenId);});
	  	    }
		}
		,
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
		}
		,
		selectOrQuick: function () {
			$('[name=chkRow]').each(function () {
	            if (this.checked == true) {
	            	this.checked = false;
	            }
	        });
	    }
		,
		checkOnce: function (current) {
			if($("#moreSelect").attr("checked") != "checked"){
				var checked = current.checked;
		        $("input[name='" + current.name + "']").attr("checked", false);
		        current.checked = checked;
			}
	    }
		,
		exportOrdens:function(){
			var url = $.csCore.buildServicePath('/service/orden/exportordens?formData=');
			url += $.csControl.getFormData('OrdenSearch');
			window.open(url);
		}
		,
		search:function(){
			var param=$('form').serialize();
			var search="";
			var arr = new Array();
			var arrs = new Array();
			var jsons = param.substring(0,param.length-25);
			arr=jsons.split("&");
			for(var i=0;i<arr.length;i++){
				var arrJson =arr[i];
				arrs = arrJson.split("=");
				if(arrs[0]=="keyword"){
					arrJson = "keyword="+$("#keyword").val();
				}
				search += arrJson +"&";
			}
			$.cookie("ordenSearchUrl",search.substring(0,search.length-1));
			window.location.href='/hongling/orden/dordenPage.do?'+param.substring(0,param.length-25);
//			$("#fromsubmit").attr("action","/hongling/orden/dordenPage.do").submit();
		}
		,
		remove:function (ordenID,status,companyID){
			if(status == "10039" && (companyID == "1002" || companyID == "1003")){//待支付、绑定的善融
				var url = $.csCore.buildServicePath("/member/removeordens");
				$.dorden_page.removeData(url,ordenID,"OrdenSearch");
			}else{
				var url = $.csCore.buildServicePath("/service/orden/removeordens");
				$.dorden_page.removeData(url,ordenID,"OrdenSearch");
			}
//			setTimeout(function(){window.location.href='/hongling/orden/dordenPage.do';},3000);
		},
		removeData: function (url, removedIDs) {
	        if (removedIDs == null || removedIDs == "") {
	        	$.csCore.alert($.csCore.getValue('Common_PleaseSelect', 'Common_ForRemoved'));
	            return false;
	        }
	        $.dorden_page.confirm($.csCore.getValue('Common_RemoveConfirm'), "$.dorden_page.removeRemote('" + url + "','" + removedIDs + "')");
	    },
		removeRemote: function (url, removedIDs) {
	        var param = $.csControl.appendKeyValue("", "removedIDs", removedIDs);
	        var data = $.csCore.invoke(url, param);
	        if (data != null) {
	            if (data == "OK") {
					var url="";
					if($.cookie("ordenSearchUrl") != null){
						url=$.cookie("ordenSearchUrl");
					}
					window.location.href='/hongling/orden/dordenPage.do?'+url;
	            }
	            else {
	                $.csCore.alert(data);
	            }
	        }
	    },
		confirm: function (msg, okEvent) {
	        $.weeboxs.open(msg, {
	            title: $.csCore.getValue("Common_Prompt"),
	            okBtnName: $.csCore.getValue("Button_OK"),
	            cancelBtnName: $.csCore.getValue("Button_Cancel"),
	            type: 'dialog',
	            onok: function () {
	                eval(okEvent);
	                $.csCore.close();
	            },
	            oncancel: function () {
	                $.csCore.close();
	            }
	        });
	    },
		openEdit:function (selectedID){
			
//			$.csCore.loadModal('../pages/orden/post.jsp',920,600,function(){$.csOrdenPost.init(selectedID,false);});
			$('#ordenID2').val(selectedID);
			$('#copyFlag').val("0");
			// 编辑 快速下单 
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
					server_context + '/orden/editOrdenAction.do').submit();
		}
		,
		preSubmitOrden : function(ordenID){
			$.csCore.loadModal('../pages/orden/pre_commit.jsp',450,200,function(){$.csPre_commit.init(ordenID);});
//	    	var param = $.csControl.appendKeyValue("","ordenIds",ordenID);
//	    	param = $.csControl.appendKeyValue(param,"type","1");
//	    	var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/submitmoreorden'),param);
//	    		alert(data);
//	    	if(data != ""){
//	    		$.csCore.alert(data);
//	    	}
	    }
		,
		ordenToPay:function(ordenID,sysCode,userStauts,companyID,payTypeID){//待支付订单
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
			    	$.csCore.invoke($.csCore.buildServicePath('/member/sendordendetail'));
					$.csOrdenList.list(0);
				}else if(companyID == "1002"){//红领
					window.open("http://mall.ccb.com/alliance/gologin.php?cpcode=1002");
				}else if(companyID == "1003"){//凯妙
					window.open("http://mall.ccb.com/alliance/gologin.php?cpcode=1003");
				}
			}
		}
		,
		link:function(){
			
		}
		,
		loadPage:function(url, fun){
			$.csCore.loadPage("page_url",url,fun);
		}
		,
		loadVersions:function(){
			$.csControl.fillOptions('versions',$.csCore.getVersions(), "ID" , "name", "");
	        var currentVersion = $.csCore.getCurrentVersion();
	        $.csControl.initSingleCheck(currentVersion);
	        $("#versions").change(function(){$.csCore.changeVersion($("#versions").val());});
	        $("#signOut").bind("click", $.csCore.signOut);
		}
		,
		enterPress : function(e){ //传入 event
			var e = e || window.event;
			if(e.keyCode == 13){
				var page = $("#changePage").val()-1;
				var url="pageindex="+page;
				if($.cookie("ordenSearchUrl") != null){
					url="pageindex="+page+"&"+$.cookie("ordenSearchUrl");
				}
				window.location.href='/hongling/orden/dordenPage.do?'+url;
			}
		},
		init:function(){
			$.dorden_page.loadVersions();
			$.dorden_page.bindEvent();
			var member = $.csCore.getCurrentMember();
			if(member.userStatus == 10050){
				$("#btnSubmitMoreOrden").hide();
			}else{
				$("#btnPayMoreOrden").hide();
			}
			if(member.username == 'CME' || member.username == 'CMEA' 
				|| member.username == 'CMEB' || member.username == 'CMEC' || member.username == 'CMED' || member.username == 'CMEE' 
				|| member.username == 'CMEF' || member.username == 'CMEG' || member.username == 'CMEH'){//无退出
				$("#signOut").hide();
			}
		}
};
$(document).ready(function(){
	$.dorden_page.init();
});