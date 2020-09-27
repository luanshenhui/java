$(document).ready(function (){
//	var id='XXXX13072663';
	var id= window.window.location.search.split("?")[1];
	jQuery.csOrdenInfoView.init(id);
});
jQuery.csOrdenInfoView={
	bindLabel:function (){
		$.csCore.getValue("Process_Info",null,"#lblProcessInfo");
		$.csCore.getValue("Embroid_Design",null,"#lblDepthDesign");
		$.csCore.getValue("Customer_Size",null,"#lblCustomerSize");
	},
	bindEvent:function (){
	},
	list:function(id){
		var param = $.csControl.appendKeyValue('','ordenID',id);
	    var orden = $.csCore.invoke($.csCore.buildServicePath("/service/ordenview/getordeninfobyid"),param);
		$('.imageSmall').html(orden.memo);
	    $("#view_sizePart").html(orden.sizePartNames);
	    
	    var domProcess ="<div class='process_Class'><label>"+$.csCore.getValue("Fabric_Code")+"</label> : <font color='#FFBB77'>"+orden.fabricCode+"</font></div>";
	    if(!$.csValidator.isNull(orden.ordenDetails)){
		    $.each(orden.ordenDetails,function(i,detail){
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
	    if(!$.csValidator.isNull(orden.ordenDetails)){
			$.each(orden.ordenDetails,function(i,detail){
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
		$.csOrdenInfoView.loadProduct(ordenID,singleClothingID);
		var param = $.csControl.appendKeyValue('','clothingID',singleClothingID);
		param=$.csControl.appendKeyValue(param,'ordenID',ordenID);
	    var orden=$.csCore.invoke($.csCore.buildServicePath("/service/ordenview/getordeninfobyid"),param);
	    
	    $("#view_sizePart").html("");
	    $("#view_sizePart").html(orden.sizePartNames);
	    	    
	    $("#view_processInfo").html("");
	    var domProcess ="<div class='process_Class'><label>"+$.csCore.getValue("Fabric_Code")+"</label> : <font color='#FFBB77'>"+orden.fabricCode+"</font></div>";
	    var detail = orden.ordenDetails;
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
		var param = $.csControl.appendKeyValue('','singleClothingID',singleClothingID);
		param=$.csControl.appendKeyValue(param,'ordenID',ordenID);
	    var url = $.csCore.buildServicePath('/service/ordenview/getordenimagebyid');
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
		$.csOrdenInfoView.bindLabel();
		$.csOrdenInfoView.bindEvent();
		$.csOrdenInfoView.list(id);
		$.csOrdenInfoView.loadProduct(id,'');
	}
};