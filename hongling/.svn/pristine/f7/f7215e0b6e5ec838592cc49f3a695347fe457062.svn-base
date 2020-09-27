jQuery.csOrdenView={
	view:function (id){
		$.csCore.addValueLine('view_orden');
		$.csCore.resetView('view_orden');
		var orden = $.csOrdenCommon.getOrdenByID(id);
		if(!$.csValidator.isNull(orden)){
//			alert(JSON.stringify(orden));
			$.csCore.viewWithJSON('view_orden',orden);
			if(!$.csValidator.isNull(orden.customer)){
				$.csCore.viewWithJSON('view_orden',orden.customer);
				$("#_view_ordenPubDate").html($.csDate.formatMillisecondDate(orden.pubDate));
				var weight = orden.customer.weight;
				if(!$.csValidator.isNull(weight)){
					$("#_view_weight").html(weight+orden.customer.weightUnitName);
				}
				var height = orden.customer.height;
				if(!$.csValidator.isNull(height)){
					$("#_view_height").html(height+orden.customer.heightUnitName);
				}
			}
			if(!$.csValidator.isNull(orden.ordenDetails)){
				var domDetail = "";
				$.each(orden.ordenDetails,function(i,detail){
					domDetail += detail.singleClothingName + "<br />";
					/*if(detail.cmtPrice != null){
						domDetail += "<span><label>"+$.csCore.getValue("Common_Price")+ "</label> : "+detail.cmtPrice+"</span>";
					}*/
					domDetail += "<span><label>"+$.csCore.getValue("Common_Amount")+ "</label>: "+detail.amount+"</span>";
					domDetail += detail.singleComponents + "<br />";
//					domDetail += "<span style='color:red;'><label>CMT价格</label>: "+detail.cmtPrice+"</span><span style='color:red;'><label>面料价格</label>: "+detail.fabricPrice+"</span><span style='color:red;'><label>工艺价格</label>: "+detail.processPrice+"</span>" + "<br />";
					if(detail.singleEmbroiderys !=null){
						$('#_view_embroidery').html($('#_view_embroidery').html()+detail.singleClothingName + "<br />"+detail.singleEmbroiderys+"<br/>");
					}
					
				});
				$('#_view_detail').html(domDetail.replaceAll("null",""));
			}
			$("#_view_userNo").html(orden.userordeNo);
			$("#_view_sizePart").html(orden.sizePartNames);
			$("#_view_sizePart").append(orden.jtSizeName);//老平台净体量体（成衣、净体都有时）
			if(orden.sizeCategoryID == DICT_SIZE_CATEGORY_STANDARD){//标准号
				$("#lblClothingStyle").hide();
				$("#_view_clothingStyleName").hide();
				$("#lblBodyType").hide();
				$("#_view_bodyType").hide();
			}else if(orden.sizeCategoryID == DICT_SIZE_CATEGORY_CLOTH){//成衣尺寸
				$("#lblClothingStyle").hide();
				$("#_view_clothingStyleName").hide();
				$("#_view_bodyType").html(orden.sizeBodyTypeNames);
			}else{//净体量体
				$("#_view_bodyType").html(orden.sizeBodyTypeNames);
				if(orden.clothingID==6000){
					$("#_view_clothingStyleName").html(orden.clothingStyleName+"&nbsp;"+orden.styleDYName);
				}else{
					$("#_view_clothingStyleName").html(orden.clothingStyleName);
				}
			}
			if(!$.csValidator.isNull(orden.ordenID)){
				if(orden.ordenID.length == 36){
					$('#_view_ordenID').html('');
				}
			}
			/*if($.csValidator.isNull(orden.memo)){
				$(".lblMemo").parent().hide();
			}*/
		}
	},
	init:function(id){
		$.csOrdenCommon.bindLabel();
		$.csOrdenView.view(id);
	}
};