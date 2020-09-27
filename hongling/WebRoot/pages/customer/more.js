jQuery.csCustomerMore={
	bindLabel:function (){
		$("#continue_add").html($.csCore.getValue("Continue_Add")+" >>");
		$("#next_step").html($.csCore.getValue("Button_SaveMyDesign")+" >>");
	},
	bindEvent:function (){
		$("#continue_add").click(function(){$.csCustomerMore.continueAdd();});
		$("#next_step").click(function(){$.csCustomerMore.nextStep();});
	},
	list:function(){
		var datas = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getclothing'));
		if(datas != null && datas.length > 0){
			var clothing="<table><tr>";
			for(var i=0;i<datas.length;i++){
				if(datas[i].ID != 5000 && datas[i].ID != 4 && datas[i].ID != 5 && datas[i].ID != 6 && datas[i].ID != 7 
						&& datas[i].ID != 90000 && datas[i].ID != 95000 && datas[i].ID != 98000){
					clothing+="<td class='clothing_category_logo_"+datas[i].ID +"' onclick='$.csCustomerMore.showOrden("+datas[i].ID +")'><h3 id='clothing_category_logo_text'>"+datas[i].name+"</h3></td>";
				}		
			}
			clothing+="</tr></table>";
			$('#more_category').html(clothing);
		}
	},
	showOrden:function (clothingID){
		if($.csCore.postData($.csCore.buildServicePath('/service/customer/settempcustomer'), 'customer_form')){
			$.csOrden.loadAccordion('#p'+clothingID,clothingID);
	    	$.csCore.close();
	    }
	},
	continueAdd:function (){
		$.csCore.close();
	},
	nextStep:function (){
    	$.csCore.close();
    	$.csCore.loadModal('../customer/post.jsp',980,500,function(){$.csCustomerPost.init();});

	},
	init:function(){
		$.csCustomerMore.bindLabel();
		$.csCustomerMore.bindEvent();
		$.csCustomerMore.list();
	}
};