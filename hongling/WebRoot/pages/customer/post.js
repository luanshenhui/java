jQuery.csCustomerPost={
	bindLabel:function (){
		$(".pay_title").html($.csCore.getValue("Pay_Title"));
		$("#pay_zfb").html($.csCore.getValue("Pay_Zfb"));
		$("#pay_paypail").html($.csCore.getValue("Pay_Paypail"));
		$("#pay_srjh").html($.csCore.getValue("Pay_SrJh"));
		$("#pay_qt").html($.csCore.getValue("Pay_HongLing"));
		$.csCore.getValue("Common_product",null,".lblClothing");
		$.csCore.getValue("Orden_Fabric",null,".lblFabric");
		$.csCore.getValue("Orden_SizeCategory",null,".lblSizeCategory");
		$.csCore.getValue("Button_Remove",null,".lblRemove");
		$.csCore.getValue("Orden_Number",null,".lblNum");
		$.csCore.getValue("Common_Count",null,".lblCount");
		$.csCore.getValue("Button_Browse",null,".preview");
		$.csCore.getValue("Button_MyOrder",null,"#orden_temp_list h1");
		$.csCore.getValue("Customer_Info",null,"#customer_form h1");
		$.csCore.getValue("Button_Submit",null,"#btnSubmitOrdens");
		$.csCore.getValue("Common_Save",null,"#btnSaveOrdens");
	},
	bindEvent:function (){
		//$("#saveOrdens").click($.csCustomerPost.saveOrdens);
	},
	browseTempOrden:function(id){
		$.csCore.loadModal('../orden/tempview.htm',964,540,function(){$.csTempView.init(id);});
	},
	modifyTempOrden:function(id){
		$.csCore.loadModal('../orden/post.htm',920,510,function(){$.csOrdenPost.init(id,false);});
	},
    validate:function (){
    	var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/gettempordens'));
	    for(var i=0;i<data.data.length;i++){
	    	var fabricCode = $("#fabric_"+data.data[i].ordenID).val();
	    	if($.csCore.contain(DICT_FABRIC_SUPPLY_CATEGORY_CLIENT, fabricCode) || fabricCode.length <= 3){
				$("#fabric_"+data.data[i].ordenID).val('');
			}
	    	if($.csValidator.checkNull("fabric_"+data.data[i].ordenID,$.csCore.getValue("Common_Required","Fabric_Moduler"))){
				return false;
			}
	    }
	    return true;
	},
	saveOrdens:function(isCompany){
		if($.csCustomerPost.validate() == false){
			return false;
		}
		if($.csCustomer.validate()){
			/*if($.csCore.postData($.csCore.buildServicePath('/service/orden/saveordens'), 'all')){
				$.csCore.close();
				$.csBase.loadMyOrden();
		    }*/
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/saveordens'), $.csControl.getFormData("all"));
			if (!$.csValidator.isNull(data)) {
				 if (isCompany=="10050") {
					if (data.indexOf("<form")==0) {
						$("#alipay_submit").html(data);
						document.forms['myForm'].submit();
					}else{
						$.weeboxs.open(data, { title: $.csCore.getValue("Common_Prompt"), type: 'alert', okBtnName: $.csCore.getValue("Button_OK"),onok: $.csCustomerPost.panduan()});
					}
	    			}else{
	    				if (data.toUpperCase() == "OK") {
	    	                $('#all').resetForm();
	    	                $.csCustomerPost.panduan();
	    	            }else{
	    	            	$.weeboxs.open(data, { title: $.csCore.getValue("Common_Prompt"), type: 'alert', okBtnName: $.csCore.getValue("Button_OK"),onok: $.csCustomerPost.panduan()});
	    	            }
	    			}
			}
	   	}
	},
	/*submitOrdens:function (){
		if($.csCustomerPost.validate() == false){
			return false;
		}
		if($.csCustomer.validate()){
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/submitordens'), $.csControl.getFormData("all"));
			if (!$.csValidator.isNull(data)) {
				if (data.toUpperCase() == "OK") {
	                $('#all').resetForm();
	                $.csCustomerPost.panduan();
	            }else{
	            	$.weeboxs.open(data, { title: $.csCore.getValue("Common_Prompt"), type: 'alert', okBtnName: $.csCore.getValue("Button_OK"),onok: $.csCustomerPost.panduan()});
	            }
			}
		}
	},*/
	submitOrdens:function (){
		if($.csCustomerPost.validate() == false){
			return false;
		}
		if($.csCustomer.validate()){
			var member = $.csCore.getCurrentMember();
			if((member.companyID == 1002 || member.companyID == 1003) && member.userStatus == 10050){
				$("#pay_srbj").hide();
				var data = $.csCore.invoke($.csCore.buildServicePath('/member/submitordens'), $.csControl.getFormData("all"));
				if (!$.csValidator.isNull(data)) {
					if (data.toUpperCase() == "OK") {
		                $('#all').resetForm();
	                    $.csCustomerPost.panduan();
	                    $.csCore.alert("提交成功，请支付！");
		            }else{
		            	$.weeboxs.open(data, { title: $.csCore.getValue("Common_Prompt"), type: 'alert', okBtnName: $.csCore.getValue("Button_OK"),onok: $.csCustomerPost.panduan()});
		            }
				}
			}else if(member.payTypeID == DICT_MEMBER_PAYTYPE_ONLINE){//在线支付
				$("#pay_bj").show();
			}else{//非在线支付--提交
				var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/submitordens'), $.csControl.getFormData("all"));
				if (!$.csValidator.isNull(data)) {
					if (data.toUpperCase() == "OK") {
		                $('#all').resetForm();
                      $.csCustomerPost.panduan();
		            }else{
		            	$.weeboxs.open(data, { title: $.csCore.getValue("Common_Prompt"), type: 'alert', okBtnName: $.csCore.getValue("Button_OK"),onok: $.csCustomerPost.panduan()});
		            }
				}
			}
		}
	},
	ordenPay : function(type){
		if(type == 1){//支付宝
			$("#pay_bj").hide();
//			var param =  $.csControl.getFormData("all");
//			param = $.csControl.appendKeyValue(param,"type","1");
//			var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/alipayordens'), param);
//			$("#alipay_submit").html(data);
			var param =  $.csControl.getFormData("all");
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/alipay/submitordens'), param);
			if(data.substr(0,2) == "OK"){
				$("#alipay_submit").html(data.substr(2,data.length-2));
			}else{
				$.csCore.alert(data);
			}
		}else if(type == 2){//paypail
			$("#pay_bj").hide();
			var param =  $.csControl.getFormData("all");
			param = $.csControl.appendKeyValue(param,"type","2");
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/alipayordens'), param);
			$("#alipay_submit").html(data);
//			$.csBase.loadMyOrden();
		}else{
			$("#pay_bj").hide();
		}
	},
	panduan : function(){
		$.csCore.close();
		$.csBase.loadMyOrden();
	},
	removeTempOrdenConfirm:function(ordenID){
		$.csCore.confirm($.csCore.getValue('Common_RemoveConfirm'),"$.csCustomerPost.removeTempOrden('"+ordenID+"')");
	},
	removeTempOrden:function (ordenID){
		var url = $.csCore.buildServicePath('/service/orden/removetemporden');
		var param = $.csControl.appendKeyValue("","ordenid",ordenID);
		$.csCore.invoke(url,param);
		this.listOrdens(0);
	},
	listOrdens:function (){
	    var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/gettempordens'));
	    $.csCore.processList('Ordens', data);

	    for(var i=0;i<data.data.length;i++){
	    	//alert(JSON.stringify(data.data));
	    	$.csCustomerPost.autoCompleteFabric('fabric_' + data.data[i].ordenID);
	    	var j=i+1;
	    	$("#num"+data.data[i].ordenID).html("NO."+j);
    		if(data.data[i].morePants == DICT_YES){
	    		$("#count"+data.data[i].ordenID).html(1);
	    	}else{
	    		$("#count"+data.data[i].ordenID).html(data.data[i].morePants);
	    	}
	    	var img = data.data[i].clothingID;
	    	if(img < DICT_CLOTHING_ShangYi){
	    		img = DICT_CLOTHING_ShangYi;
	    	}
	    	$("#img"+data.data[i].ordenID).html("<img src='../../process/component/orden/"+img+"/"+data.data[i].fabricCode+"_img.png'>");
	    	
	    	if(!$.csCore.contain(DICT_FABRIC_SUPPLY_CATEGORY_CLIENT, data.data[i].fabricCode)){
				$("#fabric_"+data.data[i].ordenID).attr("disabled", "disabled");
			}
	    }
	    $.csCustomerPost.bindLabel();
	},
	autoCompleteFabric:function (txt){
		
		var url = $.csCore.buildServicePath('/service/fabric/getfabricbykeyword');
			$("#" + txt).autocomplete(url, {
			multiple : false,
			dataType : "json",
			parse : function(data) {
				return $.map(data, function(row) {
					return {
						data : row,
						value : row.code,
						result : row.code
					};
				});
			},
			formatItem : function(item) {
				return item.code + "(" + item.categoryName + ")"; 
			}
		});
	},
	init:function(){
		$('#customer_form').resetForm();
		$.csCustomerPost.bindEvent();
		$.csCore.loadPage("container_customer_info","../customer/customer.jsp",function(){$.csCustomer.init();});
		$.csCustomerPost.listOrdens();
	}
};