jQuery.csTempView={
	bindLabel:function (){
		$.csCore.getValue("Process_Info",null,".lblProcessInfo");
		$.csCore.getValue("Embroid_Design",null,".lblDepthDesign");
		$.csCore.getValue("Customer_Size",null,".lblCustomerSize");
		$.csCore.getValue("Common_Back",null,".lblBack");
	},
	bindEvent:function (){
		$(".lblBack").click(function(){$.csCore.close();});
	},
	list:function(id){
	    var orden = jQuery.csOrdenCommon.getOrdenByID(id);
		var dict=$.csCore.getDictByID(orden.clothingID);
		var arr= new Array(); 
		arr=dict.extension.split(",");
		var param = $.csControl.appendKeyValue('','clothingID',arr[0]);
		param=$.csControl.appendKeyValue(param,'ordenID',id);
	    var ordenTemp=$.csCore.invoke($.csCore.buildServicePath("/service/orden/gettempordenviewbyclothingid"),param);
		//alert(JSON.stringify(ordenTemp));
		if(orden.clothingID == DICT_CLOTHING_SUIT2PCS || orden.clothingID == DICT_CLOTHING_SUIT3PCS){
			var domSmall= "<ul>";
			if(!$.csValidator.isNull(orden.ordenDetails)){
			    $.each(orden.ordenDetails,function(i,detail){
			    	domSmall +="<li onclick=$.csTempView.showInformation('"+detail.singleClothingID+"','"+id+"')><img src='../../process/component/orden/"+detail.singleClothingID+"/"+orden.fabricCode+"_img.png'/></li>";
			    });
			}
			domSmall += "</ul>";
			$('.imageSmall').html(domSmall);
		}
		
	    $("#view_sizePart").html(ordenTemp.sizePartNames);
	    
	    var domProcess="";
	    domProcess ="<div class='process_Class'><label>"+$.csCore.getValue("Fabric_Code")+"</label> : <font color='#FFBB77'>"+orden.fabricCode+"</font></div>";
	    if(!$.csValidator.isNull(ordenTemp.ordenDetails)){
		    $.each(ordenTemp.ordenDetails,function(i,detail){
		    	if(!$.csValidator.isNull(detail.singleComponents)){
		    		domProcess += detail.singleComponents;
		    	}else{
			    	domProcess = $.csCore.getValue("Common_Standard");
			    }
		    	return false;
			});
	    }
	    $("#view_processInfo").html(domProcess);
	    
	    var domDetail = "";
	    if(!$.csValidator.isNull(ordenTemp.ordenDetails)){
			$.each(ordenTemp.ordenDetails,function(i,detail){
				if(!$.csValidator.isNull(detail.singleEmbroiderys)){
					domDetail += detail.singleEmbroiderys;
				}else{
			    	domDetail = $.csCore.getValue("Common_Nothing");
			    }
				return false;
			});
	    }
	    $('#view_depthDesign').html(domDetail);
	},
	showInformation:function(singleClothingID,ordenID){
		$.csTempView.loadProduct(ordenID,singleClothingID);
		var param = $.csControl.appendKeyValue('','clothingID',singleClothingID);
		param=$.csControl.appendKeyValue(param,'ordenID',ordenID);
	    var ordenTemp=$.csCore.invoke($.csCore.buildServicePath("/service/orden/gettempordenviewbyclothingid"),param);
	    
	    $("#view_sizePart").html("");
	    $("#view_sizePart").html(ordenTemp.sizePartNames);
	    	    
	    $("#view_processInfo").html("");
	    var domProcess="";
	    domProcess ="<div class='process_Class'><label>"+$.csCore.getValue("Fabric_Code")+"</label> : <font color='#FFBB77'>"+ordenTemp.fabricCode+"</font></div>";
	    var detail = ordenTemp.ordenDetails;
	    if(!$.csValidator.isNull(detail)){
	    	for(var i=0;i<detail.length;i++){
	    		if(detail[i].singleClothingID == singleClothingID){
	    			if(!$.csValidator.isNull(detail[i].singleComponents)){
	    				domProcess += detail[i].singleComponents;
	    			}else{
	    		    	domProcess = $.csCore.getValue("Common_Standard");
	    		    }
	    		}
		    }
	    }
	    $("#view_processInfo").html(domProcess);
	    
	    $('#view_depthDesign').html("");
	    var domDetail = "";
	    if(!$.csValidator.isNull(detail)){
	    	for(var i=0;i<detail.length;i++){
	    		if(detail[i].singleClothingID == singleClothingID){
	    			if(!$.csValidator.isNull(detail[i].singleEmbroiderys)){
	    				domDetail += detail[i].singleEmbroiderys;
	    			}else{
	    		    	domDetail = $.csCore.getValue("Common_Nothing");
	    		    }
	    		}
		    }
	    }
	    $('#view_depthDesign').html(domDetail);
	},
	loadProduct:function (ordenID,singleClothingID){
		var arr= new Array(); 
		var orden = jQuery.csOrdenCommon.getOrdenByID(ordenID);
		if($.csValidator.isNull(singleClothingID)){
			var dict=$.csCore.getDictByID(orden.clothingID);
			arr=dict.extension.split(",");
			singleClothingID = arr[0];
		}
		
		var param = $.csControl.appendKeyValue('','singleClothingID',singleClothingID);
		param=$.csControl.appendKeyValue(param,'ordenID',ordenID);
	    
	    var url = $.csCore.buildServicePath('/service/orden/gettempimagebyid');
	    var tempProducts = $.csCore.invoke(url,param);
		var divDom = "";
		var imgUrl = "";
		if(!$.csValidator.isNull(tempProducts)){
			for(var i=0;i<tempProducts.length;i++){
				imgUrl += tempProducts[i].imgUrl + " " + tempProducts[i].zindex +  "\n";
				if($.csValidator.isExistImg(tempProducts[i].imgUrl)){
					divDom += "<img style='z-index:"+tempProducts[i].zindex+"' src='" +tempProducts[i].imgUrl+ "'>";
				}
			}
		}
		$(".imageBig").html(divDom);
	},
	init:function(id){
		$.csTempView.bindLabel();
		$.csTempView.bindEvent();
		$.csTempView.list(id);
		$.csTempView.loadProduct(id,'');
	}
};