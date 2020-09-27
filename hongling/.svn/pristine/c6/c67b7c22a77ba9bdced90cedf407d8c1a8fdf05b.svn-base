jQuery.csDictPricePost={
	bindEvent:function (){
		$("#btnSaveInformation").click($.csDictPricePost.save);
		$("#btnCancelInformation").click($.csCore.close);
	},
	fillGroup:function (initValue){
		$.csControl.fillChecks('divGroup',$.csCore.getDicts(DICT_CATEGORY_MEMBER_GROUP), "groupids", "ID" , "name", initValue);
	},
	validate:function (){
		if($.csValidator.checkNull("code","工艺代码必须填写!")){
			return false;
		}
		if($.csValidator.checkNull("name","工艺描述必须填写!")){
			return false;
		}
		if($.csValidator.checkNull("price","美元价格必须填写!")){
			return false;
		}
		if($.csValidator.checkNull("rmbPrice","人名币价格必须填写!")){
			return false;
		}
		return true;
	},
	onlyNumber:function(obj){//只允许录入数字和小数点
	    //先把非数字的都替换掉，除了数字和.
	     obj.value = obj.value.replace(/[^\d\.]/g,'');   
	     //必须保证第一个为数字而不是.   
	     obj.value = obj.value.replace(/^\./g,'');   
	     //保证只有出现一个.而没有多个.   
	     obj.value = obj.value.replace(/\.{2,}/g,'.');  
	     //保证.只出现一次，而不能出现两次以上   
	     obj.value = obj.value.replace('.','$#$').replace(/\./g,'').replace('$#$','.');
	     
	     var re = /([0-9]+\.[0-9]{2})[0-9]*/;  
	     obj.value = obj.value.replace(re,"$1");  
	},
	save:function (){
		if($.csDictPricePost.validate()){
		    if($.csCore.postData($.csCore.buildServicePath('/service/dictprice/savedictprice'), 'form')){
		    	$.csDictPriceList.list(0);
		    	$.csCore.close();
		    }
		}
	},
	getDictPriceByID:function(id){
		var param = $.csControl.appendKeyValue("","id",id);
		return  $.csCore.invoke($.csCore.buildServicePath('/service/dictprice/getdictpricebyid'),param);
	},
	init:function(id){
		$.csDictPricePost.bindEvent();
		$('#form').resetForm();
		$.csDictPricePost.fillGroup("");
		
		if($.csValidator.isNull(id)){
			$.csCore.getValue("Common_Add","Information_Moduler","#form h1");
		}else{
			$.csCore.getValue("Common_Edit","Information_Moduler","#form h1");
			var dictPrice = $.csDictPricePost.getDictPriceByID(id);
			$.updateWithJSON(dictPrice);
			$.csDictPricePost.fillGroup(dictPrice.groupids);
		}
	}
};