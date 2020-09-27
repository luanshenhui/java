jQuery.csCoderList={
	bindLabel:function (){
		$.csCore.getValue("Coder_Title",null,"#coder_title");
		$.csCore.getValue("Coder_Kgml",null,"#coder_kgml");
		$.csCore.getValue("Coder_Kgmlbh",null,"#coder_kgmlbh");
		$.csCore.getValue("Coder_Hlbh",null,"#coder_hlbh");
		$.csCore.getValue("Coder_Fzks",null,"#coder_fzks");
		$.csCore.getValue("Coder_Scks",null,"#coder_scks");
		$.csCore.getValue("Coder_Jbbh",null,"#coder_jbbh");
		$.csCore.getValue("Coder_JscxBOM",null,"#coder_jscxBOM");
		$.csCore.getValue("Coder_JsBOM",null,"#coder_jsBOM");
		$.csCore.getValue("Coder_Ks",null,"#coder_ks");
		$.csCore.getValue("Coder_Ml",null,"#coder_ml");
	},
	bindEvent:function (){
		$("#bom").click(function(){$.csCoderList.getBom();});
		$("#redCode").click(function(){$.csCoderList.getRedCode();});
		$("#retailerCode").click(function(){$.csCoderList.getRetailerCode();});
		$("#basiscoding").click(function(){$.csCoderList.getBasisCoding();});
		$("#model").click(function(){$.csCoderList.getModel();});
	},
	validate:function(id,type){
		if ($.csValidator.checkNull(id, $.csCore.getValue("Common_Required", type))) {
			return false;
		}
		return true;
	},
	getBom:function (){//查询技术BOM
		if ($.csCoderList.validate("model2T","Coder_Ks") == false || $.csCoderList.validate("fabricsT","Coder_Ml") == false) {
			return false;
		}
		var model2T = $("#model2T").val();
		var fabricsT = $("#fabricsT").val();
		
		var param =  $.csControl.appendKeyValue("",'model2T',model2T);
		param = $.csControl.appendKeyValue(param,'fabricsT',fabricsT);
		param = $.csControl.appendKeyValue(param,'type',"bom");
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/core/getcode'),param);
		
		$("#showbom").val(data);
	},
	getRedCode:function (){//红领编号->客供面料编号
		if ($.csCoderList.validate("redCodeT","Coder_Hlbh") == false) {
			return false;
		}
		var redCodeT= $("#redCodeT").val();
		
		var param =  $.csControl.appendKeyValue("",'redCodeT',redCodeT);
		param = $.csControl.appendKeyValue(param,'type',"redCode");
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/core/getcode'),param);
		
		$("#retailerCodeT").val(data);
	},
	getRetailerCode:function (){//客供面料编号->红领编号
		if ($.csCoderList.validate("retailerCodeT","Coder_Kgmlbh") == false) {
			return false;
		}
		var retailerCodeT = $("#retailerCodeT").val();
		
		var param =  $.csControl.appendKeyValue("",'retailerCodeT',retailerCodeT);
		param = $.csControl.appendKeyValue(param,'type',"retailerCode");
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/core/getcode'),param);
		
		$("#redCodeT").val(data);
	},
	getBasisCoding:function (){//基本编号->市场款式
		if ($.csCoderList.validate("basiscodingT","Coder_Jbbh") == false) {
			return false;
		}
		var basiscodingT = $("#basiscodingT").val();
		
		var param =  $.csControl.appendKeyValue("",'basiscodingT',basiscodingT);
		param = $.csControl.appendKeyValue(param,'type',"basiscoding");
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/core/getcode'),param);
		
		$("#modelT").val(data);
	},
	getModel:function (){//市场款式->基本编号
		if ($.csCoderList.validate("modelT","Coder_Scks") == false) {
			return false;
		}
		var modelT = $("#modelT").val();
		
		var param =  $.csControl.appendKeyValue("",'modelT',modelT);
		param = $.csControl.appendKeyValue(param,'type',"model");
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/core/getcode'),param);
		
		$("#basiscodingT").val(data);
	},
	init:function(){
		$.csCoderList.bindLabel();
		$.csCoderList.bindEvent();
	}
};