jQuery.csSizePost={
	bindLabel:function (){
		$.csCore.getValue("Size_Info",null,"#sizeform h1");
		$.csCore.getValue("Button_SaveMyDesign",null,"#btnSaveSize");
		$.csCore.getValue("Button_Pre",null,"#btnPreSize");
		$("#btnPreSize").click(function(){$.csCore.close();$.csCore.loadModal('../size/select.htm',960,440,function(){$.csSizeSelect.init();});});
	},
	bindEvent:function (){
		$("#btnSaveSize").click($.csSizePost.saveOrden);
	},
	abortSize:function (){
		$.csCore.invoke($.csCore.buildServicePath('/service/orden/cleartempdesigns'));
		$.csCore.close();
		window.location.reload();
	},
	cancelSize:function (){
		if($.csCore.postData($.csCore.buildServicePath('/service/orden/saveordensize'), 'sizeform')){
	    	$.csCore.close();
	    }
	},
	saveOrden:function (){
		if($.csSize.validatePost()){
			if($.csCore.postData($.csCore.buildServicePath('/service/orden/saveorden'), 'sizeform')){
		    	$.csCore.close();
		    	if($.cookie("fashionClothing") == 1){
		    		$.csCore.loadModal('../customer/post.htm',980,500,function(){$.csCustomerPost.init();});
		    	}else{
		    		$.csCore.loadModal('../customer/more.htm',1065,500,function(){$.csCustomerMore.init();});
		    	}
		    }
		}
	},
	getOrdenSize:function (){
		return $.csCore.invoke($.csCore.buildServicePath('/service/orden/getordensize'));
	},
	init:function(){
		$.csSizePost.bindLabel();
		$.csSizePost.bindEvent();
		var orden = $.csSizePost.getOrdenSize();
		if(!$.csValidator.isNull(orden) && !$.csValidator.isNull(orden.ordenID)){
			$('#ordenID').val(orden.ordenID);
		}
		$.csCore.loadPage("container_size","../size/size.jsp",function(){$.csSize.init(orden);});
	}
};