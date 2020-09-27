jQuery.csPre_commit={
	bindLabel:function (){		
	},
	bindEvent:function (){
//		$("#btnSubmit").click($.csPre_commit.commit);
//		$("#btnCancel").click($.csCore.close);
	},
	kg_show:function(){
		$("#kgxx").show();
		$("#type").val("2");
		
	},
	hongling_show:function(){
		$("#kgxx").hide();
		$("#type").val("1");
	},
	commit : function(){
		if($("#type").val() == "1"){
			$.csPre_commit.hongling_Commit();
		}else if($("#type").val() == "2"){
			$.csPre_commit.kg_Commit();
		}
	},
	kg_Commit:function (){
	    var param = $.csControl.appendKeyValue("","ordenIds",$("#pre_ordenID").val());
    	param = $.csControl.appendKeyValue(param,"type","2");
    	param = $.csControl.appendKeyValue(param,"tg",$("#tg").val());
    	param = $.csControl.appendKeyValue(param,"tgkd",$("#tgkd").val());
    	param = $.csControl.appendKeyValue(param,"fk",$("#fk").val());
    	var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/submitmoreorden'),param);
    	if(data != ""){
    		$.csCore.alert(data);
    	}
	},
	hongling_Commit : function(){
		var param = $.csControl.appendKeyValue("","ordenIds",$("#pre_ordenID").val());
    	param = $.csControl.appendKeyValue(param,"type","1");
    	var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/submitmoreorden'),param);
    	if(data != ""){
    		$.csCore.alert(data);
    	}
	},
	init:function(ID){
		$("#pre_ordenID").val(ID);
	}
};