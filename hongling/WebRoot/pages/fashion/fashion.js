jQuery.csFashion = {
	bindLabel:function(){
		$("#professional_edition").html($.csCore.getValue("Label_Professional"));
		$("#sssw").html($.csCore.getValue("Label_FashionBusiness"));
		$("#jdsw").html($.csCore.getValue("Label_ClassicBusiness"));
		$("#sslf").html($.csCore.getValue("Label_FashionDress"));
		$("#jdlf").html($.csCore.getValue("Label_ClassicDress"));
	},
	bindEvent:function (){
		$("#professional_edition").click($.csFashion.to_profession);
	},
	showImg :function(type){
		$.cookie("fashiontype", type);
		location.reload(); 
	},
	showImg1 :function(){
		var type = $.cookie("fashiontype");
		var param = $.csControl.appendKeyValue('', 'type', type);
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/fashion/getfashions'), param);
		$("#bank").html(data);
	},
	changeColor : function(id){
		$.cookie("btid", id);
	},
	to_profession : function(){
		var url = $.csCore.buildServicePath('/service/orden/settempclothingid');
		var param = $.csControl.appendKeyValue("", "clothingid", 3);
		$.csCore.invoke(url, param);
		$.cookie("btid", "");
		$.cookie("fashiontype","");
	},
	realm : function(){//根据域名显示不同logo
		var realm = window.location.href; 
		var param = $.csControl.appendKeyValue("","realm",realm);
		var realmdata = $.csCore.invoke($.csCore.buildServicePath('/service/realmname/getrealmname'),param);
		
		if ($.csValidator.isNull(realmdata) || $.csValidator.isNull(realmdata.customerName)){
			$("#logo").html("<img id='b' src='../../fashionIMG/img/b.gif'/><img id='bb'  stlye='height:100px;' src='../../fashionIMG/img/logo.png'/>");
		}else{
			$("#logo").html("<img id='b' src='../../fashionIMG/img/b.gif'/><img id='bb' src='../../fashionIMG/img/"+ realmdata.customerName +".png'/>");
		}
	},
	init:function(){
		$.csFashion.bindLabel();
		$.csFashion.bindEvent();
		$.csFashion.realm();

		if($.cookie("fashiontype") == null || $.cookie("fashiontype") == ""){
			var param = $.csControl.appendKeyValue('', 'type', 1);
			var data = $.csCore.invoke($.csCore.buildServicePath('/service/fashion/getfashions'), param);
			$("#bank").html(data);
		}else{
			$.csFashion.showImg1();
		}
		if($("#versions").val()==2){
			$("#jdsw").css("padding-right","40px");
			$("#jdsw").css("padding-left","40px");
			$("#sssw").css("padding-right","40px");
			$("#sssw").css("padding-left","40px");
			$("#jdlf").css("padding-right","40px");
			$("#jdlf").css("padding-left","40px");
			$("#sslf").css("padding-right","40px");
			$("#sslf").css("padding-left","40px");
		}
		//标题经典商务字体黑色
		$("#jdsw").css("color","#292929");
	}
};
$(function() {
	$.csBase.init(this);
	$.csFashion.init();
});