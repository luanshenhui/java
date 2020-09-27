$(document).ready(function (){
	jQuery.csSelect.init();
});
jQuery.csSelect={
	bindLabel:function(){
//		$.csCore.getValue("Label_Professional",null,"#professional_edition");
//		$.csCore.getValue("Button_MyOrder",null,"#myorden");
//		$.csCore.getValue("Button_FabricSearch",null,"#myfabric");
//		$.csCore.getValue("Dict_10309",null,"#blDelivery");
//		$.csCore.getValue("Dict_10305",null,"#blCash");
//		$.csCore.getValue("Dict_10308",null,"#mymessage");
//		$.csCore.getValue("Button_User",null,"#myuser");
//		$.csCore.getValue("Button_MyInformation",null,"#myinformation");
//		$.csCore.getValue("Button_Coder",null,"#coder");
//		$.csCore.getValue("Button_Exit",null,"#signOut");
	},
	bindEvent:function (){
		$("#professional_edition").click(function(){$.csCore.invoke($.csCore.buildServicePath('/service/orden/cleartempdesigns'));});
		$("#myorden").bind("click",$.csBase.loadMyOrden);
		$("#myfabric").click($.csBase.loadMyFabric);
		$("#blDelivery").bind("click",$.csBase.loadBlDelivery);
		$("#blCash").bind("click",$.csBase.loadBlCash);
		$("#mymessage").click($.csBase.loadMyMessage);
		$("#myuser").click($.csBase.loadMyUser);
		$("#myinformation").bind("click",$.csBase.loadMyInformation);
		$("#coder").bind("click",$.csBase.loadCoder);
		$("#signOut").bind("click", $.csCore.signOut);
		$("#versions").change(function(){$.csCore.changeVersion($("#versions").val());});
	},
	loadVersions:function(){
		$.csControl.fillOptions('versions',$.csCore.getVersions(), "ID" , "name", "");
	    var currentVersion = $.csCore.getCurrentVersion();
	    var option = $("option[value='" + currentVersion + "']");
        if (option.length > 0) {
            option.attr("selected", true);
        }
	},
	//深入设计
	save : function (){
		$.csCore.postData($.csCore.buildServicePath("/service/fix/settempcomponentid?type=1"), "form");
		$.csSelect.setMrgyAndKxgy();
    },
    //完成设计
    size : function (){
    	$.csCore.postData($.csCore.buildServicePath("/service/fix/settempcomponentid?type=1"), "form");
    	$.csSelect.setMrgyAndKxgy();
		$.csCore.loadModal('../size/select.htm', 998, 440,
			function() {
				$.csSizeSelect.init();
			});
		$(".clothing_type").html("<select id='type' onchange='$.csSelect.changeType(this.value)'><option value='-1' checked>"+$.csCore.getValue("SSB_SELECT")+"</option><option value='1'>"+$.csCore.getValue("Dict_1")+"</option><option value='2'>"+$.csCore.getValue("Dict_2")+"</option><option value='3'>"+$.csCore.getValue("Dict_3")+"</option><option value='2000'>"+$.csCore.getValue("Dict_2000")+"</option><option value='3000'>"+$.csCore.getValue("Dict_3000")+"</option><option value='4000'>"+$.csCore.getValue("Dict_4000")+"</option><option value='6000'>"+$.csCore.getValue("Dict_6000")+"</option></select>");
		$.csSelect.changeType("-1");//服装分类
    },
    //点击图片 选择毛衬类型
    changeMC : function(id,vals){
    	$.csSelect.setChecked(id);
    	$("#mc_val").val(vals);
    	$.csSelect.setComponentID("mc_val",vals);
    	//根据毛衬类型切换基本信息
    	if($("#type").val()==1 || $("#type").val()==2){
    		var str ="";
    		var clothing = $("input[name='type']:checked").val();
    		if(clothing ==3 && (id =="0AAA" || id =="0AAD" || id =="0AAB")){//全手工全毛衬（0AAA）、全手工、无组合胸衬（0AAD）全手工半毛衬（0AAB）
    			str ="<table id='mrgy3'>"+
    			"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_132")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_1889")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_6769")+"</td><td align='left'>"+$.csCore.getValue("Dict_82071")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_70049")+"</td><td align='left'>"+$.csCore.getValue("Dict_82077")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_60897")+"</td><td align='left'>"+$.csCore.getValue("Dict_6087")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_60883")+"</td><td align='left'>"+$.csCore.getValue("Dict_2639")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_178")+"</td><td align='left'>"+$.csCore.getValue("Dict_32334")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_32335")+"</td><td align='left'>"+$.csCore.getValue("Dict_30252")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_40641")+"</td><td align='left'>"+$.csCore.getValue("Dict_32336")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_60892")+"</td><td align='left'>"+$.csCore.getValue("Dict_32338")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_60867")+"</td><td align='left'>"+$.csCore.getValue("Dict_1961")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_60894")+"</td><td align='left'>"+$.csCore.getValue("Dict_30253")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_32340")+"</td></tr></table>";
    		}else if(clothing ==3 && (id =="00AA" || id =="00AD")){//半手工全毛衬（00AA）、半手工无组合胸衬（00AD
    			str ="<table id='mrgy3'>"+
    			"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_132")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_1889")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_6769")+"</td><td align='left'>"+$.csCore.getValue("Dict_82071")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_70049")+"</td><td align='left'>"+$.csCore.getValue("Dict_82077")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_60897")+"</td><td align='left'>"+$.csCore.getValue("Dict_1961")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_178")+"</td><td align='left'>"+$.csCore.getValue("Dict_60894")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_40641")+"</td><td align='left'>"+$.csCore.getValue("Dict_30253")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_60892")+"</td><td align='left'></td></tr></table>";
    		}else if(clothing ==3 && id =="0BAA"){//半手工半毛衬（0BAA）
    			str ="<table id='mrgy3'>"+
    			"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_132")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_40641")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_6769")+"</td><td align='left'>"+$.csCore.getValue("Dict_82071")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_70049")+"</td><td align='left'>"+$.csCore.getValue("Dict_82077")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_60897")+"</td><td align='left'>"+$.csCore.getValue("Dict_")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_178")+"</td><td align='left'>"+$.csCore.getValue("Dict_")+"</td></tr></table>";
    		}else if(clothing ==3){
    			str ="<table id='mrgy3'><tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_51")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("SSB_BTK83")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_37")+"</td><td align='left'>"+$.csCore.getValue("Dict_6054")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_QLZ")+"</td><td align='left'>"+$.csCore.getValue("Dict_219")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_6191")+"</td><td align='left'>"+$.csCore.getValue("Dict_194")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_YXBXK")+"</td><td align='left'>"+$.csCore.getValue("Dict_3229")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_XCSY")+"</td><td align='left'>"+$.csCore.getValue("SSB_WZBS")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_SYSML")+"</td><td align='left'>"+$.csCore.getValue("SSB_SMLSLB")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_BSYLB")+"</td><td align='left'>"+$.csCore.getValue("SSB_SJHT")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_6244")+"</td><td align='left'>"+$.csCore.getValue("Dict_1934")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_NZBSML")+"</td></tr></table>";
    		} 
    		else if(clothing ==2000 && (id =="0AAA" || id =="0AAD" || id =="0AAB")){
    			str ="<table id='mrgy2000'>"+
    			"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("SSB_QZFH")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_2356")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_3611")+"</td><td align='left'>"+$.csCore.getValue("Dict_40057")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_2994")+"</td><td align='left'>"+$.csCore.getValue("Dict_6075")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_6185")+"</td><td align='left'>"+$.csCore.getValue("Dict_60033")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_40640")+"</td><td align='left'>"+$.csCore.getValue("SSB_KDQMZB")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_1469")+"</td><td align='left'>"+$.csCore.getValue("Dict_2353")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_345M")+"</td><td align='left'>"+$.csCore.getValue("Dict_2682")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_2808")+"</td><td align='left'>"+$.csCore.getValue("Dict_40041")+"</td></tr>"+
    			"<tr><td align='left' width=132>"+$.csCore.getValue("Dict_2355")+"</td></tr></table>";
    		}else if(clothing ==2000 && (id =="00AA" || id =="00AD")){//半手工全毛衬（00AA）、半手工无组合胸衬（00AD
    			str ="<table id='mrgy2000'>"+
    			"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("SSB_QZFH")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_2356")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_3611")+"</td><td align='left'>"+$.csCore.getValue("Dict_40640")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_2994")+"</td><td align='left'>"+$.csCore.getValue("Dict_6075")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_6185")+"</td><td align='left'>"+$.csCore.getValue("Dict_2808")+"</td></tr>"+
    			"<tr><td align='left' width=132>"+$.csCore.getValue("Dict_40057")+"</td></tr>";
    			"<tr><td align='left' width=132>"+$.csCore.getValue("Dict_2355")+"</td></tr></table>";
    		}else if(clothing ==2000 && id =="0BAA"){//半手工半毛衬（0BAA）
    			str ="<table id='mrgy2000'>"+
    			"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("SSB_QZFH")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_2356")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_3611")+"</td><td align='left'>"+$.csCore.getValue("Dict_40057")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_40640")+"</td><td align='left'>"+$.csCore.getValue("Dict_6075")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_6185")+"</td><td align='left'>"+$.csCore.getValue("Dict_2808")+"</td></tr>"+
    			"<tr><td align='left' width=132>"+$.csCore.getValue("Dict_2355")+"</td></tr></table>";
    		}else if(clothing ==2000){
    			str ="<table id='mrgy2000'><tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_2034")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("SSB_SKXSYDK")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_ZS25")+"</td><td align='left'>"+$.csCore.getValue("SSB_JBJT")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_2113")+"</td><td align='left'>"+$.csCore.getValue("SSB_BJTC55")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_25XCKD")+"</td><td align='left'>"+$.csCore.getValue("SSB_NLLL")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_ZCCD")+"</td><td align='left'>"+$.csCore.getValue("SSB_QBKL")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_2957")+"</td><td align='left'>"+$.csCore.getValue("SSB_SYSML")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_3229")+"</td><td align='left'>"+$.csCore.getValue("SSB_KJNZ5")+"</td></tr>"+
    			"<tr><td align='left' width=132>"+$.csCore.getValue("Dict_2666")+"</td></tr></table>";
    		}
    		else if(clothing ==4000 && (id =="0AAA" || id =="0AAD" || id =="0AAB")){
    			str ="<table id='mrgy4000'>"+
    			"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_4280")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_2661")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_40639")+"</td><td align='left'>"+$.csCore.getValue("Dict_2639")+"</td></tr>"+
    			"<tr><td align='left' width=132>"+$.csCore.getValue("Dict_40641")+"</td></tr></table>";
    		}else if(clothing ==4000 && (id =="00AA" || id =="00AD")){//半手工全毛衬（00AA）、半手工无组合胸衬（00AD
    			str ="<table id='mrgy4000'>"+
    			"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_4280")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_2661")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_40639")+"</td><td align='left'></td></tr></table>";
    		}else if(clothing ==4000 && id =="0BAA"){//半手工半毛衬（0BAA）
    			str ="<table id='mrgy4000'>"+
    			"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_4280")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_2661")+"</td></tr></table>";
    		}else if(clothing ==4000){
    			str ="<table id='mrgy4000'><tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_4023")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_40")+"</td></tr>"+
    	    	"<tr><td align='left'>"+$.csCore.getValue("Dict_4638")+"</td><td align='left'>"+$.csCore.getValue("Dict_4070")+"</td></tr>"+
    	    	"<tr><td align='left'>"+$.csCore.getValue("Dict_4066")+"</td><td align='left'>"+$.csCore.getValue("Dict_4050")+"</td></tr></table>";
    		}
    		$("#all_jbgy").html(str);
			$("#all_jbgy").css("margin-right", "120px");
    	}else if($("#type").val()==3){
    		var str ="";
    		if(id =="0AAA" || id =="0AAD" || id =="0AAB"){//全手工全毛衬（0AAA）、全手工、无组合胸衬（0AAD）全手工半毛衬（0AAB）
    			str ="<table id='mrgy3'>"+
    			"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_132")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_1889")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_6769")+"</td><td align='left'>"+$.csCore.getValue("Dict_82071")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_70049")+"</td><td align='left'>"+$.csCore.getValue("Dict_82077")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_60897")+"</td><td align='left'>"+$.csCore.getValue("Dict_6087")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_60883")+"</td><td align='left'>"+$.csCore.getValue("Dict_2639")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_178")+"</td><td align='left'>"+$.csCore.getValue("Dict_32334")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_32335")+"</td><td align='left'>"+$.csCore.getValue("Dict_30252")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_40641")+"</td><td align='left'>"+$.csCore.getValue("Dict_32336")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_60892")+"</td><td align='left'>"+$.csCore.getValue("Dict_32338")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_60867")+"</td><td align='left'>"+$.csCore.getValue("Dict_1961")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_60894")+"</td><td align='left'>"+$.csCore.getValue("Dict_30253")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_32340")+"</td></tr></table>";
    		}else if(id =="00AA" || id =="00AD"){//半手工全毛衬（00AA）、半手工无组合胸衬（00AD
    			str ="<table id='mrgy3'>"+
    			"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_132")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_1889")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_6769")+"</td><td align='left'>"+$.csCore.getValue("Dict_82071")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_70049")+"</td><td align='left'>"+$.csCore.getValue("Dict_82077")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_60897")+"</td><td align='left'>"+$.csCore.getValue("Dict_1961")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_178")+"</td><td align='left'>"+$.csCore.getValue("Dict_60894")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_40641")+"</td><td align='left'>"+$.csCore.getValue("Dict_30253")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_60892")+"</td><td align='left'></td></tr></table>";
    		}else if(id =="0BAA"){//半手工半毛衬（0BAA）
    			str ="<table id='mrgy3'>"+
    			"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_132")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_40641")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_6769")+"</td><td align='left'>"+$.csCore.getValue("Dict_82071")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_70049")+"</td><td align='left'>"+$.csCore.getValue("Dict_82077")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_60897")+"</td><td align='left'>"+$.csCore.getValue("Dict_")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_178")+"</td><td align='left'>"+$.csCore.getValue("Dict_")+"</td></tr></table>";
    		}else{
    			str ="<table id='mrgy3'><tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_51")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("SSB_BTK83")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_37")+"</td><td align='left'>"+$.csCore.getValue("Dict_6054")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_QLZ")+"</td><td align='left'>"+$.csCore.getValue("Dict_219")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_6191")+"</td><td align='left'>"+$.csCore.getValue("Dict_194")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_YXBXK")+"</td><td align='left'>"+$.csCore.getValue("Dict_3229")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_XCSY")+"</td><td align='left'>"+$.csCore.getValue("SSB_WZBS")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_SYSML")+"</td><td align='left'>"+$.csCore.getValue("SSB_SMLSLB")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_BSYLB")+"</td><td align='left'>"+$.csCore.getValue("SSB_SJHT")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_6244")+"</td><td align='left'>"+$.csCore.getValue("Dict_1934")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_NZBSML")+"</td></tr></table>";
    		} 
    		$("#all_jbgy").html(str);
			$("#all_jbgy").css("margin-right", "120px");
    	}else if($("#type").val()==2000){
    		var str ="";
    		if(id =="0AAA" || id =="0AAD" || id =="0AAB"){//全手工全毛衬（0AAA）、全手工、无组合胸衬（0AAD）全手工半毛衬（0AAB）
    			str ="<table id='mrgy2000'>"+
    			"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("SSB_QZFH")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_2356")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_3611")+"</td><td align='left'>"+$.csCore.getValue("Dict_40057")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_2994")+"</td><td align='left'>"+$.csCore.getValue("Dict_6075")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_6185")+"</td><td align='left'>"+$.csCore.getValue("Dict_60033")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_40640")+"</td><td align='left'>"+$.csCore.getValue("SSB_KDQMZB")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_1469")+"</td><td align='left'>"+$.csCore.getValue("Dict_2353")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_345M")+"</td><td align='left'>"+$.csCore.getValue("Dict_2682")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_2808")+"</td><td align='left'>"+$.csCore.getValue("Dict_40041")+"</td></tr>"+
    			"<tr><td align='left' width=132>"+$.csCore.getValue("Dict_2355")+"</td></tr></table>";
    		}else if(id =="00AA" || id =="00AD"){//半手工全毛衬（00AA）、半手工无组合胸衬（00AD
    			str ="<table id='mrgy2000'>"+
    			"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("SSB_QZFH")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_2356")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_3611")+"</td><td align='left'>"+$.csCore.getValue("Dict_40640")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_2994")+"</td><td align='left'>"+$.csCore.getValue("Dict_6075")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_6185")+"</td><td align='left'>"+$.csCore.getValue("Dict_2808")+"</td></tr>"+
    			"<tr><td align='left' width=132>"+$.csCore.getValue("Dict_40057")+"</td></tr>";
    			"<tr><td align='left' width=132>"+$.csCore.getValue("Dict_2355")+"</td></tr></table>";
    		}else if(id =="0BAA"){//半手工半毛衬（0BAA）
    			str ="<table id='mrgy2000'>"+
    			"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("SSB_QZFH")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_2356")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_3611")+"</td><td align='left'>"+$.csCore.getValue("Dict_40057")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_40640")+"</td><td align='left'>"+$.csCore.getValue("Dict_6075")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_6185")+"</td><td align='left'>"+$.csCore.getValue("Dict_2808")+"</td></tr>"+
    			"<tr><td align='left' width=132>"+$.csCore.getValue("Dict_2355")+"</td></tr></table>";
    		}else{
    			str ="<table id='mrgy2000'><tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_2034")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("SSB_SKXSYDK")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_ZS25")+"</td><td align='left'>"+$.csCore.getValue("SSB_JBJT")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_2113")+"</td><td align='left'>"+$.csCore.getValue("SSB_BJTC55")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_25XCKD")+"</td><td align='left'>"+$.csCore.getValue("SSB_NLLL")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("SSB_ZCCD")+"</td><td align='left'>"+$.csCore.getValue("SSB_QBKL")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_2957")+"</td><td align='left'>"+$.csCore.getValue("SSB_SYSML")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_3229")+"</td><td align='left'>"+$.csCore.getValue("SSB_KJNZ5")+"</td></tr>"+
    			"<tr><td align='left' width=132>"+$.csCore.getValue("Dict_2666")+"</td></tr></table>";
    		} 
    		$("#all_jbgy").html(str);
			$("#all_jbgy").css("margin-right", "120px");
    	}else if($("#type").val()==4000){
    		var str ="";
    		if(id =="0AAA" || id =="0AAD" || id =="0AAB"){//全手工全毛衬（0AAA）、全手工、无组合胸衬（0AAD）全手工半毛衬（0AAB）
    			str ="<table id='mrgy4000'>"+
    			"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_4280")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_2661")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_40639")+"</td><td align='left'>"+$.csCore.getValue("Dict_2639")+"</td></tr>"+
    			"<tr><td align='left' width=132>"+$.csCore.getValue("Dict_40641")+"</td></tr></table>";
    		}else if(id =="00AA" || id =="00AD"){//半手工全毛衬（00AA）、半手工无组合胸衬（00AD
    			str ="<table id='mrgy4000'>"+
    			"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_4280")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_2661")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_40639")+"</td><td align='left'></td></tr></table>";
    		}else if(id =="0BAA"){//半手工半毛衬（0BAA）
    			str ="<table id='mrgy4000'>"+
    			"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_4280")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_2661")+"</td></tr></table>";
    		}else{
    			str ="<table id='mrgy4000'><tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_4023")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_40")+"</td></tr>"+
    	    	"<tr><td align='left'>"+$.csCore.getValue("Dict_4638")+"</td><td align='left'>"+$.csCore.getValue("Dict_4070")+"</td></tr>"+
    	    	"<tr><td align='left'>"+$.csCore.getValue("Dict_4066")+"</td><td align='left'>"+$.csCore.getValue("Dict_4050")+"</td></tr></table>";
    		} 
    		$("#all_jbgy").html(str);
			$("#all_jbgy").css("margin-right", "120px");
    	}else if($("#type").val()==6000){
    		var str ="";
    		if(id =="0AAA" || id =="0AAD" || id =="0AAB"){//全手工全毛衬（0AAA）、全手工、无组合胸衬（0AAD）全手工半毛衬（0AAB）
    			str ="<table id='mrgy6000'>"+
    			"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_6769")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_6767")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_6742")+"</td><td align='left'>"+$.csCore.getValue("Dict_1380")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_30129")+"</td><td align='left'>"+$.csCore.getValue("Dict_1998")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_1483")+"</td><td align='left'>"+$.csCore.getValue("Dict_1482")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_1965")+"</td><td align='left'>"+$.csCore.getValue("Dict_178")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_32335")+"</td><td align='left'>"+$.csCore.getValue("Dict_32334")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_30252")+"</td><td align='left'>"+$.csCore.getValue("Dict_1469")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_32336")+"</td><td align='left'>"+$.csCore.getValue("Dict_32337")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_32339")+"</td><td align='left'>"+$.csCore.getValue("Dict_32340")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_30253")+"</td><td align='left'>"+$.csCore.getValue("Dict_30254")+"</td></tr>"+
    			"<tr><td align='left' width=132>"+$.csCore.getValue("Dict_32338")+"</td></tr></table>";
    		}else if(id =="00AA" || id =="00AD"){//半手工全毛衬（00AA）、半手工无组合胸衬（00AD
    			str ="<table id='mrgy6000'>"+
    			"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_6769")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_6767")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_6742")+"</td><td align='left'>"+$.csCore.getValue("Dict_1380")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_30129")+"</td><td align='left'>"+$.csCore.getValue("Dict_1998")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_32339")+"</td><td align='left'>"+$.csCore.getValue("Dict_178")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_30253")+"</td><td align='left'>"+$.csCore.getValue("Dict_1469")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_32337")+"</td><td align='left'></td></tr></table>";
    		}else if(id =="0BAA"){//半手工半毛衬（0BAA）
    			str ="<table id='mrgy6000'>"+
    			"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_6769")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_178")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_6742")+"</td><td align='left'>"+$.csCore.getValue("Dict_1380")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_30129")+"</td><td align='left'>"+$.csCore.getValue("Dict_1998")+"</td></tr>"+
    			"<tr><td align='left'>"+$.csCore.getValue("Dict_1469")+"</td><td align='left'></td></tr></table>";
    		}else{
    			str ="<table id='mrgy6000'><tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_6016")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_6030")+"</td></tr>"+
    	    	"<tr><td align='left'>"+$.csCore.getValue("Dict_6044")+"</td><td align='left'>"+$.csCore.getValue("Dict_6054")+"</td></tr>"+
    	    	"<tr><td align='left'>"+$.csCore.getValue("Dict_6126")+"</td><td align='left'>"+$.csCore.getValue("Dict_6156")+"</td></tr>"+
    	    	"<tr><td align='left'>"+$.csCore.getValue("Dict_6174")+"</td><td align='left'>"+$.csCore.getValue("Dict_6192")+"</td></tr></table>";
    		} 
    		$("#all_jbgy").html(str);
			$("#all_jbgy").css("margin-right", "120px");
    	}
    },
    setClothingXk : function(id){
    	$.csSelect.setChecked(id);
    	$.csSelect.changeTZ_Type(id);
    },
  //点击面料
    changeFabric : function(id,now,all){
    	if($("#type").val() == 1 && $("#submit_button").is(":hidden")){
    		$.csCore.alert($.csCore.getValue("Orden_SelectXK"));
		}else if($("#type").val() == 2 && $("#submit_button").is(":hidden")){
    		$.csCore.alert($.csCore.getValue("Orden_SelectProcess"));
		}else{
			$("#ml"+now).css('display','block');
	    	$("#ml_img"+now).css({border:"solid 2px","border-color":"#DF0001"});
	    	$("#ml_img"+now).addClass("commom_class");
	    	for(var i=1;i<=all;i++){
				if(i !=  now){
					$("#ml"+i).css("display","none");
					$("#ml_img"+i).css({border:"solid 1px","border-color":"#e2e1e3"});
			    	$("#ml_img"+i).removeClass("commom_class");
				}
			}
	    	//储存选中的面料
	    	var url = $.csCore.buildServicePath('/service/orden/settempfabriccode');
	    	var param = $.csControl.appendKeyValue("", "fabriccode", id);
			$.csCore.invoke(url, param);
		}
    },
    mlOver : function(now){
    	$("#ml_img"+now).css({border:"solid 2px","border-color":"#DF0001"});
    	$("#ml_img"+now).addClass("commom_class");
    },
    mlOut : function(now){
    	if($("#ml"+now).css("display") != "block"){
        	$("#ml_img"+now).css({border:"solid 1px","border-color":"#e2e1e3"});
        	$("#ml_img"+now).removeClass("commom_class");
    	}
    },
	fabric : function(id,code){//面料
		var fabricparam = $.csControl.appendKeyValue('', 'id', id);
		var fabricdata = $.csCore.invoke($.csCore.buildServicePath('/service/fix/getfabrics'), fabricparam);
    	$("#fabrics").html(fabricdata);
//    	var url = $.csCore.buildServicePath('/service/orden/settempfabriccode');
//    	var param = $.csControl.appendKeyValue("", "fabriccode", code);
//		$.csCore.invoke(url, param);
	},
	getBtk :function(){//驳头宽
		 var bt=$("#bt_val").val();
		 var kz=$("#kz_val").val();
		 var str = kz+","+bt;
		 var btk ="";
		dicts = $.csCore.getDictsByParent(1,"82");
		for(var i=0;i<dicts.length;i++){
			if(dicts[i].affectedAllow != null && dicts[i].affectedAllow.indexOf(str)>-1){
				btk +="<tr><td align='left'><label class='hand'><input type='checkbox' name='btk' onclick=$.csSelect.changeKxgy(this,'"+ dicts[i].ID +"') value='"+ dicts[i].ID +"'>"+ dicts[i].name +"</label></td></tr>";
			}
		}
		$("#btk_radio").html(btk);
		
//		$.csControl.initSingleCheck("97");
	},
	//驳头
    gyOver : function(now){
   		$("#bt"+now).css({border:"solid 2px","border-color":"#DF0001"});
       	$("#bt"+now).addClass("commom_class");
    },
    gyOut : function(now){
   		if($("#gyimg"+now).css("display") != "block"){
	   		$("#bt"+now).css({border:"solid 1px","border-color":"#e2e1e3"});
	       	$("#bt"+now).removeClass("commom_class");
       	}
    },
    changebt : function(now,vals){
    	$("#bt_val").val(vals);
    	$.csSelect.setComponentID("bt_val",vals);
    	$("#kz_val").val("37");
    	$("#gyimg"+now).css('display','block');
    	$("#bt"+now).css({border:"solid 2px","border-color":"#DF0001"});
    	$("#bt"+now).addClass("commom_class");
    	for(var i=0;i<=4;i++){
			if(i !=  now){
				$("#gyimg"+i).css("display","none");
				$("#bt"+i).css({border:"solid 1px","border-color":"#e2e1e3"});
		    	$("#bt"+i).removeClass("commom_class");
			}
		}
    	$.csSelect.getBtk();
    	var param = $.csControl.appendKeyValue("", "id", "37");
	    var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getlapelwidthid'), param);
	    $.csControl.initSingleCheck(data);
	    
    	$(".isShow").show();
		var image ="";
		var kz_img ="<div style='margin-top: 15px; width: 650px; height:50px;'><div id='kz0' class='gy' onmouseout=$.csSelect.kzOut('0') onmouseover=$.csSelect.kzOver('0') onclick=$.csSelect.changekz('0','5','36')><div class='jbpz_text'>"+$.csCore.getValue("Dict_36")+"</div><i id='kzimg0' class='gyimg'></i></div>"+
				"<div id='kz1' class='gy' style='border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;'onmouseout=$.csSelect.kzOut('1') onmouseover=$.csSelect.kzOver('1') onclick=$.csSelect.changekz('1','5','37')><div class='jbpz_text'>"+$.csCore.getValue("Dict_37")+"</div><i id='kzimg1' class='gyimg' style='display: block;'></i></div>"+
				"<div id='kz3' class='gy' onmouseout=$.csSelect.kzOut('3') onmouseover=$.csSelect.kzOver('3') onclick=$.csSelect.changekz('3','5','38')><div class='jbpz_text'>"+$.csCore.getValue("Dict_38")+"</div><i id='kzimg3' class='gyimg'></i></div>"+
				"<div id='kz2' class='gy' title='"+$.csCore.getValue("Dict_875")+"' onmouseout=$.csSelect.kzOut('2') onmouseover=$.csSelect.kzOver('2') onclick=$.csSelect.changekz('2','5','875')><div class='jbpz_text'>"+$.csCore.getValue("SSB_KZ31")+"</div><i id='kzimg2' class='gyimg'></i></div>"+
				"<div id='kz4' class='gy' title='"+$.csCore.getValue("Dict_876")+"' onmouseout=$.csSelect.kzOut('4') onmouseover=$.csSelect.kzOver('4') onclick=$.csSelect.changekz('4','5','876')><div class='jbpz_text'>"+$.csCore.getValue("SSB_KZ32")+"</div><i id='kzimg4' class='gyimg'></i></div></div>";
		if(now==0){
			image = "51_37";
			$("#qmk").html(kz_img);
		}else if(now==1){
			image = "52_37";
			kz_img = "<div style='margin-top: 25px;width: 650px; height:50px;'>"+
				  "<div id='kz0' class='gy' onmouseout=$.csSelect.kzOut('0') onmouseover=$.csSelect.kzOver('0') onclick=$.csSelect.changekz('0','10','36')><div class='jbpz_text'>"+$.csCore.getValue("Dict_36")+"</div><i id='kzimg0' class='gyimg'></i></div>"+
				  "<div id='kz1' class='gy' style='border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;'onmouseout=$.csSelect.kzOut('1') onmouseover=$.csSelect.kzOver('1') onclick=$.csSelect.changekz('1','10','37')><div class='jbpz_text'>"+$.csCore.getValue("Dict_37")+"</div><i id='kzimg1' class='gyimg' style='display: block;'></i></div>"+
				  "<div id='kz3' class='gy' onmouseout=$.csSelect.kzOut('3') onmouseover=$.csSelect.kzOver('3') onclick=$.csSelect.changekz('3','10','38')><div class='jbpz_text'>"+$.csCore.getValue("Dict_38")+"</div><i id='kzimg3' class='gyimg'></i></div>"+
				  "<div id='kz2' class='gy' title='"+$.csCore.getValue("Dict_875")+"' onmouseout=$.csSelect.kzOut('2') onmouseover=$.csSelect.kzOver('2') onclick=$.csSelect.changekz('2','10','875')><div class='jbpz_text'>"+$.csCore.getValue("SSB_KZ31")+"</div><i id='kzimg2' class='gyimg'></i></div>"+
				  "<div id='kz4' class='gy' title='"+$.csCore.getValue("Dict_876")+"' onmouseout=$.csSelect.kzOut('4') onmouseover=$.csSelect.kzOver('4') onclick=$.csSelect.changekz('4','10','876')><div class='jbpz_text'>"+$.csCore.getValue("SSB_KZ32")+"</div><i id='kzimg4' class='gyimg'></i></div>"+
				  "</div> <div style='width: 650px; height:25px;margin-bottom: 25px;'>"+
				  "<div id='kz5' class='gy' onmouseout=$.csSelect.kzOut('5') onmouseover=$.csSelect.kzOver('5') onclick=$.csSelect.changekz('5','10','44')><div class='jbpz_text'>"+$.csCore.getValue("Dict_44")+"</div><i id='kzimg5' class='gyimg'></i></div>"+
				  "<div id='kz6' class='gy' onmouseout=$.csSelect.kzOut('6') onmouseover=$.csSelect.kzOver('6') onclick=$.csSelect.changekz('6','10','45')><div class='jbpz_text'>"+$.csCore.getValue("Dict_45")+"</div><i id='kzimg6' class='gyimg'></i></div>"+
				  "<div id='kz7' class='gy' onmouseout=$.csSelect.kzOut('7') onmouseover=$.csSelect.kzOver('7') onclick=$.csSelect.changekz('7','10','41')><div class='jbpz_text'>"+$.csCore.getValue("Dict_41")+"</div><i id='kzimg7' class='gyimg'></i></div>"+
				  "<div id='kz8' class='gy' onmouseout=$.csSelect.kzOut('8') onmouseover=$.csSelect.kzOver('8') onclick=$.csSelect.changekz('8','10','42')><div class='jbpz_text'>"+$.csCore.getValue("Dict_42")+"</div><i id='kzimg8' class='gyimg'></i></div>"+
				  "<div id='kz9' class='gy' onmouseout=$.csSelect.kzOut('9') onmouseover=$.csSelect.kzOver('9') onclick=$.csSelect.changekz('9','10','46')><div class='jbpz_text'>"+$.csCore.getValue("Dict_46")+"</div><i id='kzimg9' class='gyimg'></i></div></div>";
				  $("#qmk").html(kz_img);
		}else if(now==2){
			image = "53_37";
			$("#qmk").html(kz_img);
		}else if(now==3){
			image = "54_37";
			$("#qmk").html(kz_img);
		}else if(now==4){
			image = "55_37";
			$(".isShow").hide();
			$(".isShow").hide();
			kz_img ="<div style='margin-top: 15px; width: 650px; height:50px;'><div id='kz0' class='gy' onmouseout=$.csSelect.kzOut('0') onmouseover=$.csSelect.kzOver('0') onclick=$.csSelect.changekz('0','2','36')><div class='jbpz_text'>"+$.csCore.getValue("Dict_36")+"</div><i id='kzimg0' class='gyimg'></i></div>"+
				"<div id='kz1' class='gy' style='border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;'onmouseout=$.csSelect.kzOut('1') onmouseover=$.csSelect.kzOver('1') onclick=$.csSelect.changekz('1','2','37')><div class='jbpz_text'>"+$.csCore.getValue("Dict_37")+"</div><i id='kzimg1' class='gyimg' style='display: block;'></i></div></div>";
			$("#qmk").html(kz_img);
		}
		$("#jbks_image").html("<img src='images/"+image+".png' alt='image'/>");
	},
	//前面扣
	kzOver : function(now){
   		$("#kz"+now).css({border:"solid 2px","border-color":"#DF0001"});
       	$("#kz"+now).addClass("commom_class");
    },
    kzOut : function(now){
   		if($("#kzimg"+now).css("display") != "block"){
	   		$("#kz"+now).css({border:"solid 1px","border-color":"#e2e1e3"});
	       	$("#kz"+now).removeClass("commom_class");
       	}
    },
    changekz : function(now,all,vals){
    	$("#kz_val").val(vals);
    	$.csSelect.setComponentID("kz_val",vals);
    	
    	$("#kzimg"+now).css('display','block');
    	$("#kz"+now).css({border:"solid 2px","border-color":"#DF0001"});
    	$("#kz"+now).addClass("commom_class");
    	for(var i=0;i<=all;i++){
			if(i !=  now){
				$("#kzimg"+i).css("display","none");
				$("#kz"+i).css({border:"solid 1px","border-color":"#e2e1e3"});
		    	$("#kz"+i).removeClass("commom_class");
			}
		}
		//获得默认驳头宽
    	$.csSelect.getBtk();
    	var param = $.csControl.appendKeyValue("", "id", vals);
	    var data = $.csCore.invoke($.csCore.buildServicePath('/service/orden/getlapelwidthid'), param);
	    $.csControl.initSingleCheck(data);
        //切换图片
		var bt = $("#bt_val").val();
		var images = bt+"_"+vals;
		$("#jbks_image").html("<img src='images/"+images+".png' alt='image'/>");
	},
	
	//西裤
	kzxsOver : function(now){
   		$("#kzxs"+now).css({border:"solid 2px","border-color":"#DF0001"});
       	$("#kzxs"+now).addClass("commom_class");
    },
    kzxsOut : function(now){
   		if($("#kzxsimg"+now).css("display") != "block"){
	   		$("#kzxs"+now).css({border:"solid 1px","border-color":"#e2e1e3"});
	       	$("#kzxs"+now).removeClass("commom_class");
       	}
    },
    changeKzxs : function(now,vals){//裤膝形式
    	$.csSelect.setComponentID("xk_kzxs_val",vals);
    	$("#xk_kzxs_val").val(vals);
    	$("#kzxsimg"+now).css('display','block');
    	$("#kzxs"+now).css({border:"solid 2px","border-color":"#DF0001"});
    	$("#kzxs"+now).addClass("commom_class");
    	for(var i=0;i<=4;i++){
			if(i !=  now){
				$("#kzxsimg"+i).css("display","none");
				$("#kzxs"+i).css({border:"solid 1px","border-color":"#e2e1e3"});
		    	$("#kzxs"+i).removeClass("commom_class");
			}
		}
    	var qkd1="<div style='margin-top: 15px;margin-bottom: 5px;width: 650px; height:50px;'>"+
		    	"<div id='qdxs0' class='gy' onmouseout=$.csSelect.qdxsOut('0') onmouseover=$.csSelect.qdxsOver('0')  onclick=$.csSelect.changeQdxs('0','15','2048')><div class='jbpz_text'>"+$.csCore.getValue("SSB_2XCKD")+"</div><i id='qdxsimg0' class='gyimg'></i></div>"+
		    	"<div id='qdxs1' class='gy' onmouseout=$.csSelect.qdxsOut('1') onmouseover=$.csSelect.qdxsOver('1')  onclick=$.csSelect.changeQdxs('1','15','2050')><div class='jbpz_text'>"+$.csCore.getValue("SSB_32XCKD")+"</div><i id='qdxsimg1' class='gyimg'></i></div>"+
		    	"<div id='qdxs2' class='gy' onmouseout=$.csSelect.qdxsOut('2') onmouseover=$.csSelect.qdxsOver('2')  onclick=$.csSelect.changeQdxs('2','15','2051')><div class='jbpz_text'>"+$.csCore.getValue("SSB_51XCKD")+"</div><i id='qdxsimg2' class='gyimg'></i></div>"+
		    	"<div id='qdxs3' class='gy' style='border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;'onmouseout=$.csSelect.qdxsOut('3') onmouseover=$.csSelect.qdxsOver('3')  onclick=$.csSelect.changeQdxs('3','15','2049')><div class='jbpz_text'>"+$.csCore.getValue("SSB_25XCKD")+"</div><i id='qdxsimg3' class='gyimg' style='display: block;'></i></div>"+
		    	"<div id='qdxs4' class='gy' onmouseout=$.csSelect.qdxsOut('4') onmouseover=$.csSelect.qdxsOver('4')  onclick=$.csSelect.changeQdxs('4','15','2333')><div class='jbpz_text'>"+$.csCore.getValue("Dict_2333")+"</div><i id='qdxsimg4' class='gyimg'></i></div>"+
		    	"</div>"+
		    	"<div style='width: 650px; height:50px;'>"+
		    	"<div id='qdxs5' class='gy' onmouseout=$.csSelect.qdxsOut('5') onmouseover=$.csSelect.qdxsOver('5')  onclick=$.csSelect.changeQdxs('5','15','2334')><div class='jbpz_text'>"+$.csCore.getValue("Dict_2334")+"</div><i id='qdxsimg5' class='gyimg'></i></div>"+
		    	"<div id='qdxs6' class='gy' onmouseout=$.csSelect.qdxsOut('6') onmouseover=$.csSelect.qdxsOver('6')  onclick=$.csSelect.changeQdxs('6','15','2335')><div class='jbpz_text'>"+$.csCore.getValue("Dict_2335")+"</div><i id='qdxsimg6' class='gyimg'></i></div>"+
		    	"<div id='qdxs7' class='gy' onmouseout=$.csSelect.qdxsOut('7') onmouseover=$.csSelect.qdxsOver('7')  onclick=$.csSelect.changeQdxs('7','15','2336')><div class='jbpz_text'>"+$.csCore.getValue("Dict_2336")+"</div><i id='qdxsimg7' class='gyimg'></i></div>"+
		    	"<div id='qdxs8' class='gy' onmouseout=$.csSelect.qdxsOut('8') onmouseover=$.csSelect.qdxsOver('8')  onclick=$.csSelect.changeQdxs('8','15','2054')><div class='jbpz_text'>"+$.csCore.getValue("Dict_2054")+"</div><i id='qdxsimg8' class='gyimg'></i></div>"+
		    	"<div id='qdxs9' class='gy' onmouseout=$.csSelect.qdxsOut('9') onmouseover=$.csSelect.qdxsOver('9')  onclick=$.csSelect.changeQdxs('9','15','2053')><div class='jbpz_text'>"+$.csCore.getValue("Dict_2053")+"</div><i id='qdxsimg9' class='gyimg'></i></div>"+
		    	"</div>"+
		    	"<div style='width: 650px; height:50px;'>"+
		    	"<div id='qdxs10' class='gy' onmouseout=$.csSelect.qdxsOut('10') onmouseover='$.csSelect.qdxsOver('10','3') onclick=$.csSelect.changeQdxs('10','15','2055')><div class='jbpz_text'>"+$.csCore.getValue("Dict_2055")+"</div><i id='qdxsimg10' class='gyimg'></i></div>"+
		    	"<div id='qdxs11' class='gy' onmouseout=$.csSelect.qdxsOut('11') onmouseover='$.csSelect.qdxsOver('11','3') onclick=$.csSelect.changeQdxs('11','15','2338')><div class='jbpz_text'>"+$.csCore.getValue("Dict_2338")+"</div><i id='qdxsimg11' class='gyimg'></i></div>"+
		    	"<div id='qdxs12' class='gy' onmouseout=$.csSelect.qdxsOut('12') onmouseover='$.csSelect.qdxsOver('12','3') onclick=$.csSelect.changeQdxs('12','15','2056')><div class='jbpz_text'>"+$.csCore.getValue("Dict_2056")+"</div><i id='qdxsimg12' class='gyimg'></i></div>"+
		    	"<div id='qdxs13' class='gy' onmouseout=$.csSelect.qdxsOut('13') onmouseover='$.csSelect.qdxsOver('13','3') onclick=$.csSelect.changeQdxs('13','15','2057')><div class='jbpz_text'>"+$.csCore.getValue("Dict_2057")+"</div><i id='qdxsimg13' class='gyimg'></i></div>"+
		    	"<div id='qdxs14' class='gy' onmouseout=$.csSelect.qdxsOut('14') onmouseover='$.csSelect.qdxsOver('14','3') onclick=$.csSelect.changeQdxs('14','15','2058')><div class='jbpz_text'>"+$.csCore.getValue("Dict_2058")+"</div><i id='qdxsimg14' class='gyimg'></i></div>"+
		    	"</div>";
    	var qkd2 = "<div style='margin-top: 15px;margin-bottom: 5px;width: 650px; height:50px;'>"+
		    	"<div id='qdxs0' class='gy' onmouseout=$.csSelect.qdxsOut('0') onmouseover=$.csSelect.qdxsOver('0')  onclick=$.csSelect.changeQdxs('0','10','2048')><div class='jbpz_text'>"+$.csCore.getValue("SSB_2XCKD")+"</div><i id='qdxsimg0' class='gyimg'></i></div>"+
		    	"<div id='qdxs1' class='gy' onmouseout=$.csSelect.qdxsOut('1') onmouseover=$.csSelect.qdxsOver('1')  onclick=$.csSelect.changeQdxs('1','10','2050')><div class='jbpz_text'>"+$.csCore.getValue("SSB_32XCKD")+"</div><i id='qdxsimg1' class='gyimg'></i></div>"+
		    	"<div id='qdxs2' class='gy' onmouseout=$.csSelect.qdxsOut('2') onmouseover=$.csSelect.qdxsOver('2')  onclick=$.csSelect.changeQdxs('2','10','2051')><div class='jbpz_text'>"+$.csCore.getValue("SSB_51XCKD")+"</div><i id='qdxsimg2' class='gyimg'></i></div>"+
		    	"<div id='qdxs3' class='gy' style='border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;'onmouseout=$.csSelect.qdxsOut('3') onmouseover=$.csSelect.qdxsOver('3')  onclick=$.csSelect.changeQdxs('3','10','2049')><div class='jbpz_text'>"+$.csCore.getValue("SSB_25XCKD")+"</div><i id='qdxsimg3' class='gyimg' style='display: block;'></i></div>"+
		    	"<div id='qdxs4' class='gy' onmouseout=$.csSelect.qdxsOut('4') onmouseover=$.csSelect.qdxsOver('4')  onclick=$.csSelect.changeQdxs('4','10','2333')><div class='jbpz_text'>"+$.csCore.getValue("Dict_2333")+"</div><i id='qdxsimg4' class='gyimg'></i></div>"+
		    	"</div>"+
		    	"<div style='margin-bottom: 5px;width: 650px; height:50px;'>"+
		    	"<div id='qdxs5' class='gy' onmouseout=$.csSelect.qdxsOut('5') onmouseover=$.csSelect.qdxsOver('5')  onclick=$.csSelect.changeQdxs('5','10','2334')><div class='jbpz_text'>"+$.csCore.getValue("Dict_2334")+"</div><i id='qdxsimg5' class='gyimg'></i></div>"+
		    	"<div id='qdxs6' class='gy' onmouseout=$.csSelect.qdxsOut('6') onmouseover=$.csSelect.qdxsOver('6')  onclick=$.csSelect.changeQdxs('6','10','2335')><div class='jbpz_text'>"+$.csCore.getValue("Dict_2335")+"</div><i id='qdxsimg6' class='gyimg'></i></div>"+
		    	"<div id='qdxs7' class='gy' onmouseout=$.csSelect.qdxsOut('7') onmouseover=$.csSelect.qdxsOver('7')  onclick=$.csSelect.changeQdxs('7','10','2336')><div class='jbpz_text'>"+$.csCore.getValue("Dict_2336")+"</div><i id='qdxsimg7' class='gyimg'></i></div>"+
		    	"<div id='qdxs8' class='gy' onmouseout=$.csSelect.qdxsOut('8') onmouseover=$.csSelect.qdxsOver('8')  onclick=$.csSelect.changeQdxs('8','10','2054')><div class='jbpz_text'>"+$.csCore.getValue("Dict_2054")+"</div><i id='qdxsimg8' class='gyimg'></i></div>"+
		    	"<div id='qdxs9' class='gy' onmouseout=$.csSelect.qdxsOut('9') onmouseover=$.csSelect.qdxsOver('9')  onclick=$.csSelect.changeQdxs('9','10','2053')><div class='jbpz_text'>"+$.csCore.getValue("Dict_2053")+"</div><i id='qdxsimg9' class='gyimg'></i></div>"+
		    	"</div>";
    	
    	var images ="";
    	if(now==0){
    		$("#kdxs").html(qkd1);
    		images = "2033_2049";
		}else if(now==1){
    		$("#kdxs").html(qkd2);
    		images = "2034_2049";
		}else if(now==2){
    		$("#kdxs").html(qkd2);
    		images = "2035_2049";
		}else if(now==3){
    		$("#kdxs").html(qkd2);
    		images = "2036_2049";
		}else if(now==4){
    		$("#kdxs").html(qkd2);
    		images = "2037_2049";
		}
    	$("#jbks_XKimage").html("<img src='images/"+images+".png' alt='image'/>");
	},
	qdxsOver : function(now,qd){
   		$("#qdxs"+now).css({border:"solid 2px","border-color":"#DF0001"});
       	$("#qdxs"+now).addClass("commom_class");
    },
    qdxsOut : function(now,qd){
   		if($("#qdxsimg"+now).css("display") != "block"){
	   		$("#qdxs"+now).css({border:"solid 1px","border-color":"#e2e1e3"});
	       	$("#qdxs"+now).removeClass("commom_class");
       	}
    },
    changeQdxs : function(now,all,vals){//前口袋形式
    	$.csSelect.setComponentID("xk_kzqdxs_val",vals);
    	$("#xk_kzqdxs_val").val(vals);
    	$("#qdxsimg"+now).css('display','block');
    	$("#qdxs"+now).css({border:"solid 2px","border-color":"#DF0001"});
    	$("#qdxs"+now).addClass("commom_class");
    	for(var i=0;i<=all;i++){
			if(i !=  now){
				$("#qdxsimg"+i).css("display","none");
				$("#qdxs"+i).css({border:"solid 1px","border-color":"#e2e1e3"});
		    	$("#qdxs"+i).removeClass("commom_class");
			}
		}
    	
    	var xk_kzxs = $("#xk_kzxs_val").val();
    	var images=xk_kzxs+"_"+vals;
    	$("#jbks_XKimage").html("<img src='images/"+images+".png' alt='image'/>");
	},
	//衬衣
	//门襟形式
    lxOver : function(now){
   		$("#lx"+now).css({border:"solid 2px","border-color":"#DF0001"});
       	$("#lx"+now).addClass("commom_class");
    },
    lxOut : function(now){
   		if($("#lximg"+now).css("display") != "block"){
	   		$("#lx"+now).css({border:"solid 1px","border-color":"#e2e1e3"});
	       	$("#lx"+now).removeClass("commom_class");
       	}
    },
    changeLx : function(now,vals){
    	$("#cy_lx0_val").val(vals);
    	$.csSelect.setComponentID("cy_lx0_val",vals);
    	$("#lximg"+now).css('display','block');
    	$("#lx"+now).css({border:"solid 2px","border-color":"#DF0001"});
    	$("#lx"+now).addClass("commom_class");
    	for(var i=0;i<=15;i++){
			if(i !=  now){
				$("#lximg"+i).css("display","none");
				$("#lx"+i).css({border:"solid 1px","border-color":"#e2e1e3"});
		    	$("#lx"+i).removeClass("commom_class");
			}
		}
    	
	    var cy_mjxs_img ="<div id='mjxs0' class='gy' style='border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;'  "+
					    "onmouseout=$.csSelect.MjxsOut('0') onmouseover=$.csSelect.MjxsOver('0') onclick=$.csSelect.changeMjxs('0','5','3040')><div class='jbpz_text'>"+$.csCore.getValue("Dict_3040")+"</div> "+
					    "<i id='mjxsimg0' class='gyimg'  style='display: block;'></i></div> "+
					    "<div id='mjxs1' class='gy'  "+
					    "onmouseout=$.csSelect.MjxsOut('1') onmouseover=$.csSelect.MjxsOver('1') onclick=$.csSelect.changeMjxs('1','5','3041')><div class='jbpz_text'>"+$.csCore.getValue("Dict_3041")+"</div>"+
					    "<i id='mjxsimg1' class='gyimg'></i></div> "+
					    "<div id='mjxs3' class='gy'  "+
					    "onmouseout=$.csSelect.MjxsOut('3') onmouseover=$.csSelect.MjxsOver('3') onclick=$.csSelect.changeMjxs('3','5','3042')><div class='jbpz_text'>"+$.csCore.getValue("Dict_3042")+"</div> "+
					    "<i id='mjxsimg3' class='gyimg'></i></div> "+
					    "<div id='mjxs2' class='gy' "+
					    "onmouseout=$.csSelect.MjxsOut('2') onmouseover=$.csSelect.MjxsOver('2') onclick=$.csSelect.changeMjxs('2','5','3045')><div class='jbpz_text'>"+$.csCore.getValue("Dict_3045")+" </div>"+
					    "<i id='mjxsimg2' class='gyimg'></i></div> "+
					    "<div id='mjxs4' class='gy' "+
					    "onmouseout=$.csSelect.MjxsOut('4') onmouseover=$.csSelect.MjxsOver('4') onclick=$.csSelect.changeMjxs('4','5','3043')><div class='jbpz_text'>"+$.csCore.getValue("Dict_3043")+"</div> "+
					    "<i id='mjxsimg4' class='gyimg'></i></div>";
		$("#mjxs").html(cy_mjxs_img);
		
		var images = vals +"_3040";
	    $("#jbks_CYimage").html("<img src='images/"+images+".png' alt='image'/>");
	},
	//门襟形式
	MjxsOver : function(now,kz){
   		$("#mjxs"+now).css({border:"solid 2px","border-color":"#DF0001"});
       	$("#mjxs"+now).addClass("commom_class");
    },
    MjxsOut : function(now,kz){
   		if($("#mjxsimg"+now).css("display") != "block"){
	   		$("#mjxs"+now).css({border:"solid 1px","border-color":"#e2e1e3"});
	       	$("#mjxs"+now).removeClass("commom_class");
       	}
    },
    changeMjxs : function(now,all,vals){
    	$("#cy_mjxs_val").val(vals);
    	$.csSelect.setComponentID("cy_mjxs_val",vals);
    	
    	$("#mjxsimg"+now).css('display','block');
    	$("#mjxs"+now).css({border:"solid 2px","border-color":"#DF0001"});
    	$("#mjxs"+now).addClass("commom_class");
    	for(var i=0;i<=all;i++){
			if(i !=  now){
				$("#mjxsimg"+i).css("display","none");
				$("#mjxs"+i).css({border:"solid 1px","border-color":"#e2e1e3"});
		    	$("#mjxs"+i).removeClass("commom_class");
			}
		}
	      var cy_lx_val= $("#cy_lx0_val").val();
	      var images = cy_lx_val +"_"+vals;
	      $("#jbks_CYimage").html("<img src='images/"+images+".png' alt='image'/>");	
	},
	//马夹驳头型
	mjbtOver : function(now){
   		$("#mjbt"+now).css({border:"solid 2px","border-color":"#DF0001"});
       	$("#mjbt"+now).addClass("commom_class");
    },
    mjbtOut : function(now){
   		if($("#mjbtimg"+now).css("display") != "block"){
	   		$("#mjbt"+now).css({border:"solid 1px","border-color":"#e2e1e3"});
	       	$("#mjbt"+now).removeClass("commom_class");
       	}
    },
    changeMjbt : function(now,vals){
    	$("#mjbt_val").val(vals);
    	$.csSelect.setComponentID("mjbt_val",vals);
    	$("#mjbtimg"+now).css('display','block');
    	$("#mjbt"+now).css({border:"solid 2px","border-color":"#DF0001"});
    	$("#mjbt"+now).addClass("commom_class");
    	for(var i=0;i<=15;i++){
			if(i !=  now){
				$("#mjbtimg"+i).css("display","none");
				$("#mjbt"+i).css({border:"solid 1px","border-color":"#e2e1e3"});
		    	$("#mjbt"+i).removeClass("commom_class");
			}
		}

		var mj_mjxs_img = "<div id='mjqmk' style='margin-top: 15px; width: 650px; height:50px;'>"+
								"<div id='mjqmk0' class='gy' onmouseout=$.csSelect.mjqmkOut('0') onmouseover=$.csSelect.mjqmkOver('0') onclick=$.csSelect.changeMjqmk('0','3','4036')>"+
									"<div class='jbpz_text'>"+$.csCore.getValue("Dict_4036")+"</div><i id='mjqmkimg0' class='gyimg'></i></div>"+
								"<div id='mjqmk1' class='gy' onmouseout=$.csSelect.mjqmkOut('1') onmouseover=$.csSelect.mjqmkOver('1') onclick=$.csSelect.changeMjqmk('1','3','4037')>"+
									"<div class='jbpz_text'>"+$.csCore.getValue("Dict_4037")+"</div><i id='mjqmkimg1' class='gyimg'></i></div>"+
								"<div id='mjqmk2' class='gy' style='border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;' onmouseout=$.csSelect.dyqmkOut('2') onmouseover=$.csSelect.dyqmkOver('2') onclick=$.csSelect.changeMjqmk('2','3','4038')>"+
									"<div class='jbpz_text'>"+$.csCore.getValue("Dict_4038")+"</div><i id='mjqmkimg2' class='gyimg'  style='display: block;'></i></div>"+
							"</div>";

    	if(vals==4023 || vals==4029 || vals==4030){
			mj_mjxs_img = "<div id='mjqmk' style='margin-top: 15px; width: 650px; height:50px;'>"+
								"<div id='mjqmk0' class='gy' onmouseout=$.csSelect.mjqmkOut('0') onmouseover=$.csSelect.mjqmkOver('0') onclick=$.csSelect.changeMjqmk('0','5','4036')>"+
									"<div class='jbpz_text'>"+$.csCore.getValue("Dict_4036")+"</div><i id='mjqmkimg0' class='gyimg'></i></div>"+
								"<div id='mjqmk1' class='gy' onmouseout=$.csSelect.mjqmkOut('1') onmouseover=$.csSelect.mjqmkOver('1') onclick=$.csSelect.changeMjqmk('1','5','4037')>"+
									"<div class='jbpz_text'>"+$.csCore.getValue("Dict_4037")+"</div><i id='mjqmkimg1' class='gyimg'></i></div>"+
								"<div id='mjqmk2' class='gy' style='border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;' onmouseout=$.csSelect.mjqmkOut('2') onmouseover=$.csSelect.mjqmkOver('2') onclick=$.csSelect.changeMjqmk('2','5','4038')>"+
									"<div class='jbpz_text'>"+$.csCore.getValue("Dict_4038")+"</div><i id='mjqmkimg2' class='gyimg'  style='display: block;'></i></div>"+
								"<div id='mjqmk3' class='gy'  onmouseout=$.csSelect.mjqmkOut('3') onmouseover=$.csSelect.mjqmkOver('3') onclick=$.csSelect.changeMjqmk('3','5','4260')>"+
									"<div class='jbpz_text'>"+$.csCore.getValue("Dict_4260")+"</div><i id='mjqmkimg3' class='gyimg'></i></div>"+
								"<div id='mjqmk4' class='gy'  onmouseout=$.csSelect.mjqmkOut('4') onmouseover=$.csSelect.mjqmkOver('4') onclick=$.csSelect.changeMjqmk('4','5','4264')>"+
									"<div class='jbpz_text'>"+$.csCore.getValue("Dict_4264")+"</div><i id='mjqmkimg4' class='gyimg'></i></div>"+
							"</div>";
		}
		
		$("#mjqmk").html(mj_mjxs_img);
		
		var images = vals +"_4038";
	    $("#jbks_MJimage").html("<img src='images/"+images+".png' alt='image'/>");
	},
	//前门扣
	mjqmkOver : function(now){
   		$("#mjqmk"+now).css({border:"solid 2px","border-color":"#DF0001"});
       	$("#mjqmk"+now).addClass("commom_class");
    },
    mjqmkOut : function(now){
   		if($("#mjqmkimg"+now).css("display") != "block"){
	   		$("#mjqmk"+now).css({border:"solid 1px","border-color":"#e2e1e3"});
	       	$("#mjqmk"+now).removeClass("commom_class");
       	}
    },
    changeMjqmk : function(now,all,vals){
    	$("#mjkz_val").val(vals);
    	$.csSelect.setComponentID("mjkz_val",vals);
    	
    	$("#mjqmkimg"+now).css('display','block');
    	$("#mjqmk"+now).css({border:"solid 2px","border-color":"#DF0001"});
    	$("#mjqmk"+now).addClass("commom_class");
    	for(var i=0;i<=all;i++){
			if(i !=  now){
				$("#mjqmkimg"+i).css("display","none");
				$("#mjqmk"+i).css({border:"solid 1px","border-color":"#e2e1e3"});
		    	$("#mjqmk"+i).removeClass("commom_class");
			}
		}
	      var mj_dybt_val= $("#mjbt_val").val();
	      var images = mj_dybt_val +"_"+vals;
	      $("#jbks_MJimage").html("<img src='images/"+images+".png' alt='image'/>");	
	},
	//大衣驳头型
	dybtOver : function(now){
   		$("#dybt"+now).css({border:"solid 2px","border-color":"#DF0001"});
       	$("#dybt"+now).addClass("commom_class");
    },
    dybtOut : function(now){
   		if($("#dybtimg"+now).css("display") != "block"){
	   		$("#dybt"+now).css({border:"solid 1px","border-color":"#e2e1e3"});
	       	$("#dybt"+now).removeClass("commom_class");
       	}
    },
    changeDybt : function(now,vals){
    	$("#dybt_val").val(vals);
    	$.csSelect.setComponentID("dybt_val",vals);
    	$("#dybtimg"+now).css('display','block');
    	$("#dybt"+now).css({border:"solid 2px","border-color":"#DF0001"});
    	$("#dybt"+now).addClass("commom_class");
    	for(var i=0;i<=15;i++){
			if(i !=  now){
				$("#dybtimg"+i).css("display","none");
				$("#dybt"+i).css({border:"solid 1px","border-color":"#e2e1e3"});
		    	$("#dybt"+i).removeClass("commom_class");
			}
		}
    	
	    var dy_mjxs_img = "<div id='dyqmk' style='margin-top: 15px; width: 650px; height:50px;'>"+
								"<div id='dyqmk0' class='gy' onmouseout=$.csSelect.dyqmkOut('0') onmouseover=$.csSelect.dyqmkOver('0') onclick=$.csSelect.changeDyqmk('0','5','6137')>"+
									"<div class='jbpz_text'>"+$.csCore.getValue("Dict_6137")+"</div><i id='dyqmkimg0' class='gyimg'></i></div>"+
								"<div id='dyqmk1' class='gy' style='border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;' onmouseout=$.csSelect.dyqmkOut('1') onmouseover=$.csSelect.dyqmkOver('1') onclick=$.csSelect.changeDyqmk('1','5','6016')>"+
									"<div class='jbpz_text'>"+$.csCore.getValue("Dict_6016")+"</div><i id='dyqmkimg1' class='gyimg'  style='display: block;'></i></div>"+
								"<div id='dyqmk2' class='gy' onmouseout=$.csSelect.dyqmkOut('2') onmouseover=$.csSelect.dyqmkOver('2') onclick=$.csSelect.changeDyqmk('2','5','60506')>"+
									"<div class='jbpz_text'>"+$.csCore.getValue("Dict_60506")+"</div><i id='dyqmkimg2' class='gyimg'></i></div>"+
								"<div id='dyqmk3' class='gy'  onmouseout=$.csSelect.dyqmkOut('3') onmouseover=$.csSelect.dyqmkOver('3') onclick=$.csSelect.changeDyqmk('3','5','6020')>"+
									"<div class='jbpz_text'>"+$.csCore.getValue("Dict_6020")+"</div><i id='dyqmkimg3' class='gyimg'></i></div>"+
								"<div id='dyqmk4' class='gy'  onmouseout=$.csSelect.dyqmkOut('4') onmouseover=$.csSelect.dyqmkOver('4') onclick=$.csSelect.changeDyqmk('4','5','6024')>"+
									"<div class='jbpz_text'>"+$.csCore.getValue("Dict_6024")+"</div><i id='dyqmkimg4' class='gyimg'></i></div>"+
							"</div>";
		if(vals==6477){
			dy_mjxs_img = "<div id='dyqmk' style='margin-top: 15px; width: 650px; height:50px;'>"+
								"<div id='dyqmk0' class='gy' style='border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;' onmouseout=$.csSelect.dyqmkOut('0') onmouseover=$.csSelect.dyqmkOver('0') onclick=$.csSelect.changeDyqmk('0','2','6018')>"+
									"<div class='jbpz_text'>"+$.csCore.getValue("Dict_6018")+"</div><i id='dyqmkimg0' class='gyimg'  style='display: block;'></i></div>"+
								"<div id='dyqmk1' class='gy' onmouseout=$.csSelect.dyqmkOut('1') onmouseover=$.csSelect.dyqmkOver('1') onclick=$.csSelect.changeDyqmk('1','2','60038')>"+
									"<div class='jbpz_text'>"+$.csCore.getValue("Dict_60038")+"</div><i id='dyqmkimg1' class='gyimg'></i></div>"+
							"</div>";
		}else if(vals==6475){
			dy_mjxs_img = "<div id='dyqmk' style='margin-top: 15px; width: 650px; height:50px;'>"+
								"<div id='dyqmk0' class='gy' style='border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;' onmouseout=$.csSelect.dyqmkOut('0') onmouseover=$.csSelect.dyqmkOver('0') onclick=$.csSelect.changeDyqmk('0','4','6016')>"+
									"<div class='jbpz_text'>"+$.csCore.getValue("Dict_6016")+"</div><i id='dyqmkimg0' class='gyimg' style='display: block;'></i></div>"+
								"<div id='dyqmk1' class='gy' onmouseout=$.csSelect.dyqmkOut('1') onmouseover=$.csSelect.dyqmkOver('1') onclick=$.csSelect.changeDyqmk('1','4','6017')>"+
									"<div class='jbpz_text'>"+$.csCore.getValue("Dict_6017")+"</div><i id='dyqmkimg1' class='gyimg'></i></div>"+
								"<div id='dyqmk2' class='gy' onmouseout=$.csSelect.dyqmkOut('2') onmouseover=$.csSelect.dyqmkOver('2') onclick=$.csSelect.changeDyqmk('2','4','6020')>"+
									"<div class='jbpz_text'>"+$.csCore.getValue("Dict_6020")+"</div><i id='dyqmkimg2' class='gyimg'></i></div>"+
								"<div id='dyqmk3' class='gy'  onmouseout=$.csSelect.dyqmkOut('3') onmouseover=$.csSelect.dyqmkOver('3') onclick=$.csSelect.changeDyqmk('3','4','6024')>"+
									"<div class='jbpz_text'>"+$.csCore.getValue("Dict_6024")+"</div><i id='dyqmkimg3' class='gyimg'></i></div>"+
							"</div>";
		}

		$("#dyqmk").html(dy_mjxs_img);
		
		var images = vals +"_6016";
		if(vals==6477){
			images = vals +"_6018";
		}
	    $("#jbks_DYimage").html("<img src='images/"+images+".png' alt='image'/>");
	},
	//前门扣
	dyqmkOver : function(now){
   		$("#dyqmk"+now).css({border:"solid 2px","border-color":"#DF0001"});
       	$("#dyqmk"+now).addClass("commom_class");
    },
    dyqmkOut : function(now){
   		if($("#dyqmkimg"+now).css("display") != "block"){
	   		$("#dyqmk"+now).css({border:"solid 1px","border-color":"#e2e1e3"});
	       	$("#dyqmk"+now).removeClass("commom_class");
       	}
    },
    changeDyqmk : function(now,all,vals){
    	$("#dykz_val").val(vals);
    	$.csSelect.setComponentID("dykz_val",vals);
    	
    	$("#dyqmkimg"+now).css('display','block');
    	$("#dyqmk"+now).css({border:"solid 2px","border-color":"#DF0001"});
    	$("#dyqmk"+now).addClass("commom_class");
    	for(var i=0;i<=all;i++){
			if(i !=  now){
				$("#dyqmkimg"+i).css("display","none");
				$("#dyqmk"+i).css({border:"solid 1px","border-color":"#e2e1e3"});
		    	$("#dyqmk"+i).removeClass("commom_class");
			}
		}
	      var dy_dybt_val= $("#dybt_val").val();
	      var images = dy_dybt_val +"_"+vals;
	      $("#jbks_DYimage").html("<img src='images/"+images+".png' alt='image'/>");	
	},
	//公共方法
	setComponentID : function(names,values){
        var url = $.csCore.buildServicePath('/service/fix/settempcomponentid');
		var param = $.csControl.appendKeyValue("", "type", names);
		param = $.csControl.appendKeyValue(param, "id", values);
		$.csCore.invoke(url, param);
	},
	changeKxgy : function(gy){//可选工艺
	    var checked = gy.checked;
        $("input[name='" + gy.name + "']").attr("checked", false);
        gy.checked = checked;
        var vals = $.csControl.getCheckedValue(gy.name);
        if(gy.checked == true){
        	$("#"+gy.name+"_val").val(vals);
        }else{
        	$("#"+gy.name+"_val").val("");
        }
	},
	changeKhzd : function(gy){//客户指定（扣子、调节扦子）
		var checked = gy.checked;
        $("input[name='" + gy.name + "']").attr("checked", false);
        gy.checked = checked;
        var vals = $.csControl.getCheckedValue(gy.name);
        if(gy.checked == true){
        	var strSelect ="";
    		var dicts ="";
    		if(gy.name == "kzl"){//上衣扣子
    			if(vals == "375"){//上衣指定扣子
    				strSelect ="<select onclick=$.csSelect.setKhzd('kzl',this.value)><option value='0'>"+$.csCore.getValue("SSB_SELECT")+"</option>";
    				dicts = $.csCore.getDictsByParent(1,"375");
    				for(var i=0;i<dicts.length;i++){
    					if(dicts[i].ecode != null){
    						strSelect +="<option value='"+ dicts[i].ID+"'>"+ dicts[i].name +"</option>";
    					}
    				}
    				strSelect +="</select>";
    				$("#kzl_375").html(strSelect);
    			}else if(vals == "1923"){//上衣指定面料包扣
    				$("#kzl_375").html("");
    			}else{
    				$("#kzl_375").html("");
    				$("#kzl_val").val(vals);
    			}
    		}
    		if(gy.name == "xk_kzl"){//西裤扣子
    			if(vals == "2192"){//西裤指定扣子
    				strSelect ="<select onclick=$.csSelect.setKhzd('xk_kzl',this.value)><option value='0'>"+$.csCore.getValue("SSB_SELECT")+"</option>";
    				dicts = $.csCore.getDictsByParent(1,"2192");
    				for(var i=0;i<dicts.length;i++){
    					if(dicts[i].ecode != null){
    						strSelect +="<option value='"+ dicts[i].ID+"'>"+ dicts[i].name +"</option>";
    					}
    				}
    				strSelect +="</select>";
    				$("#xk_kzl_2192").html(strSelect);
    			}else if(vals == "2965"){//西裤指定面料包扣
    				$("#xk_kzl_2192").html("");
    			}else{
    				$("#xk_kzl_2192").html("");
    				$("#xk_kzl_val").val(vals);
    			}
    		}
    		if(gy == "xk_kytjxs"){//西裤 裤腰调节形式
    			if(vals == ""){//西裤腰间加调节钎子
    				
    			}else if(vals == ""){///西裤后中缝加调节钎子
    				
    			}else{
    				$("#xk_kytjxs_val").val(vals);
    			}
    		}
        }else{
    		if(gy.name == "kzl"){//上衣扣子
				$("#kzl_375").html("");
				$("#kzl_val").val("");
    		}
    		if(gy.name == "xk_kzl"){//西裤扣子
				$("#xk_kzl_2192").html("");
				$("#xk_kzl_val").val("");
    		}
    		if(gy == "xk_kytjxs"){//西裤 裤腰调节形式
				$("#xk_kytjxs_val").val();
    		}
        }
	},
	setKhzd : function(gy,vals){//客户指定 赋值
		$("#"+gy+"_val").val(vals);
	},
	setMrgy : function(vals){//设置默认值
		/*if($.cookie("logo") == 20138 || $.cookie("logo") == 20144 || $.cookie("logo") == 20140){//凯妙、瑞璞
			var mrgy= "";
			if(vals == "1"){//套装
				mrgy="2113,2119,2529,2093,2098,2635,2124,2689,2155,2590,433,132,178,1379,1014,1185;2354,2356,2353,2990,2639,2355,2986,1889,1381,1382,1378,1380,1965,1963";
			}
			if(vals == "3"){//西服
				mrgy="433,132,178,1379,1014,1185;1889,1381,1382,1378,1380,1965,1963";
			}
			if(vals == "2000"){//西裤
				mrgy="2113,2119,2529,2093,2098,2635,2124,2689,2155,2590;2354,2356,2353,2990,2639,2355,2986";
			}
			if(mrgy != ""){
				$.csSelect.setComponentID("mrgy_val",mrgy);
			}
		}else */if($.cookie("logo") == 0){//联翔服装设计有限公司
			var mrgy= "";
			if(vals == "1"){//套装
				mrgy="2147,2033,2124,2689,2155,2093,2098,2334,2635,1379,52,432,36,92,1768,215,178,220,1779,565,1926,20111;2856,1473,1474,2681,2680,2682,2683,2356,2353,2679,1378,1381,1385,1950,20112;20112:MINGTH,20111:MINGTH,2679:KYFTC-CQXMYL,1473:MINGTH";
			}
			if(vals == "3"){//西服
				 mrgy="52,432,36,92,1768,215,178,220,1779,565,1926,1379,20111;1474,1378,1381,1385,1473,1950;20111:MINGTH,1473:MINGTH";
			}
			if(vals == "2000"){//西裤
				mrgy="2147,2033,2093,2124,2689,2155,2098,2334,2635;2856,2356,2353,2679,2680,2681,2682,2683,20112;20112:MINGTH,2679:KYFTC-CQXMYL";
			}
			if(vals == "3000"){//衬衣
				mrgy="3055,3066,3086,7012,3803,3119,3284,20113;7072;20113:MINGTH(白底)";
			}
			$.csSelect.setComponentID("mrgy_val",mrgy);
		}
	},
	setMrgyAndKxgy : function(){//提交时设置凯妙默认值+可选工艺（扣子、调节扦子）
		var clothingID = $.csCore.invoke($.csCore.buildServicePath('/service/orden/gettempclothingid'));
		
		var kzl = $("#kzl_val").val();
		var xk_kzl = $("#xk_kzl_val").val();
		var xk_kytjxs = $("#xk_kytjxs_val").val();
		if(kzl != "" && (clothingID ==1 || clothingID ==3)){
			$.csSelect.setComponentID("kzl_val",kzl);
		}
		if(xk_kzl != "" && (clothingID ==1 || clothingID ==2000)){
			$.csSelect.setComponentID("xk_kzl_val",xk_kzl);
		}
		if(xk_kytjxs != "" && (clothingID ==1 || clothingID ==2000)){
			$.csSelect.setComponentID("xk_kytjxs_val",xk_kytjxs);
		}
		/*if($.cookie("logo") == 20138 || $.cookie("logo") == 20144 || $.cookie("logo") == 20140){//凯妙、瑞璞
			if($("#bt_val").val() != 55 && (clothingID ==1 || clothingID ==3)){//不为青果领
//				var mrgy = "79,999;1952,1998";//1952手工缝串口BL已关闭
				var mrgy = "79,999;1998";
				$.csSelect.setComponentID("mrgy_val",mrgy);
			}
		}*/
		if(clothingID == 3000){//衬衣客户指定扣（单独）
			var str ="";
			if($("#cy_3092").val() != null && $("#cy_3092").val() != ""){
				str = "3092:"+$("#cy_3092").val();
				$.csSelect.setComponentID("khzd",str);
			}
			if($("#cy_3030").val() != null && $("#cy_3030").val() != ""){
				str = "3030:"+$("#cy_3030").val();
				$.csSelect.setComponentID("khzd",str);
			}
			if($("#cy_3090").val() != null && $("#cy_3090").val() != ""){
				str = "3090:"+$("#cy_3090").val();
				$.csSelect.setComponentID("khzd",str);
			}
			if($("#cy_3091").val() != null && $("#cy_3091").val() != ""){
				str = "3091:"+$("#cy_3091").val();
				$.csSelect.setComponentID("khzd",str);
			}
			if($("#cy_7045").val() != null && $("#cy_7045").val() != ""){
				str = "7045:"+$("#cy_7045").val();
				$.csSelect.setComponentID("khzd",str);
			}
		}
	},
	changeType : function(id){//切换服装分类
		if(id==-1){
			return;
		}
		$.csCore.invoke($.csCore.buildServicePath('/service/orden/cleartempdesigns'));
		$.csCore.invoke($.csCore.buildServicePath('/service/orden/settempclothingid'), $.csControl.appendKeyValue("", "clothingid",id));
		$("#TZ").html("");
		if(id=="1"){
			var submit_vals ="<tr><td>胸袋形式<input id='xdxs_val' type='text'/></td></tr>"+
			"<tr><td>后背开衩形式<input id='hbkcxs_val' type='text'/></td></tr><tr><td>后开衩调整<input id='hbkctz_val' type='text'/></td></tr>"+
			"<tr><td>袖衩形式<input id='xksl_val' type='text'/></td></tr><tr><td>驳头眼形式<input id='btyxs_val' type='text'/></td></tr>"+
			"<tr><td>驳头宽<input id='btk_val' type='text' type='text'/></td></tr><tr><td>下口袋形式<input id='xkdxs_val' type='text'/></td></tr>"+
			"<tr><td>挂面形式<input id='gmxs_val' type='text'/></td></tr><tr><td>里子造型与下口<input id='lzzxyxk_val' type='text'/></td></tr>"+
			"<tr><td>底襟形式<input id='xk_djxs_val' type='text'/></td></tr><tr><td>脚口形式<input id='xk_jkxs_val' type='text'/></td></tr>"+
			"<tr><td>宝剑头形式<input id='xk_bjtxs_val' type='text'/></td></tr><tr><td>表袋形式<input id='xk_bdxs_val' type='text'/></td></tr>"+
			"<tr><td>宝剑头长度<input id='xk_bjtcd_val' type='text'/></td></tr><tr><td>后袋形式<input id='xk_hdxs_val' type='text' type='text'/></td></tr>";
			$("#submit_vals").html(submit_vals);//提交文本框
			
			$.csSelect.getBtk();//上衣驳头宽
			$.csControl.initSingleCheck("97");
			$.csSelect.setMrgy(id);//默认工艺
			$.csSelect.changeTZ_Type("3");//服装分类
			$.csSelect.cancelKxgy(id);//可选工艺默认
			$.csSelect.fabric("1","DBK053A");//设置面料
			var tz = "<label class='hand'><input type='radio' name='type' value='3' checked='checked' onclick=$.csSelect.changeTZ_Type('3') /> "+$.csCore.getValue("Dict_3")+" </label>"+
					"<label class='hand'><input type='radio' name='type' value='2000' onclick=$.csSelect.changeTZ_Type('2000') />"+$.csCore.getValue("Dict_2000")+"</label>";
			$("#TZ").html(tz);//服装分类切换
		}if(id=="2"){
			var submit_vals ="<tr><td>胸袋形式<input id='xdxs_val' type='text'/></td></tr>"+
			"<tr><td>后背开衩形式<input id='hbkcxs_val' type='text'/></td></tr><tr><td>后开衩调整<input id='hbkctz_val' type='text'/></td></tr>"+
			"<tr><td>袖衩形式<input id='xksl_val' type='text'/></td></tr><tr><td>驳头眼形式<input id='btyxs_val' type='text'/></td></tr>"+
			"<tr><td>驳头宽<input id='btk_val' type='text' type='text'/></td></tr><tr><td>下口袋形式<input id='xkdxs_val' type='text'/></td></tr>"+
			"<tr><td>挂面形式<input id='gmxs_val' type='text'/></td></tr><tr><td>里子造型与下口<input id='lzzxyxk_val' type='text'/></td></tr>"+
			"<tr><td>底襟形式<input id='xk_djxs_val' type='text'/></td></tr><tr><td>脚口形式<input id='xk_jkxs_val' type='text'/></td></tr>"+
			"<tr><td>宝剑头形式<input id='xk_bjtxs_val' type='text'/></td></tr><tr><td>表袋形式<input id='xk_bdxs_val' type='text'/></td></tr>"+
			"<tr><td>宝剑头长度<input id='xk_bjtcd_val' type='text'/></td></tr><tr><td>后袋形式<input id='xk_hdxs_val' type='text' type='text'/></td></tr>"+
			"<tr><td>驳头眼形式<input id='mj_btyxs_val' type='text'/></td></tr>"+
			"<tr><td>胸袋形式<input id='mj_xdxs_val' type='text'/></td></tr><tr><td>下口袋形式<input id='mj_xkdxs_val' type='text'/></td></tr>"+
			"<tr><td>后背形式<input id='mj_hbxs_val' type='text'/></td></tr><tr><td>扣种类<input id='mj_kzl_val' type='text'/></td></tr>"+
			"<tr><td>下口形式<input id='mj_xkxs_val' type='text' type='text'/></td></tr><tr><td></td></tr>";
			$("#submit_vals").html(submit_vals);//提交文本框
			
			$.csSelect.getBtk();//上衣驳头宽
			$.csControl.initSingleCheck("97");
			$.csSelect.setMrgy(id);//默认工艺
			$.csSelect.changeTZ_Type("3");//服装分类
			$.csSelect.cancelKxgy(id);//可选工艺默认
			$.csSelect.fabric("1","DBK053A");//设置面料
			var tz = "<label class='hand'><input type='radio' name='type' value='3' checked='checked' onclick=$.csSelect.changeTZ_Type('3') /> "+$.csCore.getValue("Dict_3")+" </label>"+
					"<label class='hand'><input type='radio' name='type' value='2000' onclick=$.csSelect.changeTZ_Type('2000') /> "+$.csCore.getValue("Dict_2000")+" </label>"+
					"<label class='hand'><input type='radio' name='type' value='4000' onclick=$.csSelect.changeTZ_Type('4000') /> "+$.csCore.getValue("Dict_4000")+" </label>";
			$("#TZ").html(tz);//服装分类切换
		}else if(id=="3"){
			var submit_vals ="<tr><td>胸袋形式<input id='xdxs_val' type='text'/></td></tr>"+
			"<tr><td>后背开衩形式<input id='hbkcxs_val' type='text'/></td></tr><tr><td>后开衩调整<input id='hbkctz_val' type='text'/></td></tr>"+
			"<tr><td>袖衩形式<input id='xksl_val' type='text'/></td></tr><tr><td>驳头眼形式<input id='btyxs_val' type='text'/></td></tr>"+
			"<tr><td>驳头宽<input id='btk_val' type='text' type='text'/></td></tr><tr><td>下口袋形式<input id='xkdxs_val' type='text'/></td></tr>"+
			"<tr><td>挂面形式<input id='gmxs_val' type='text'/></td></tr><tr><td>里子造型与下口<input id='lzzxyxk_val' type='text'/></td></tr>";
			$("#submit_vals").html(submit_vals);

			$.csSelect.getBtk();
			$.csControl.initSingleCheck("97");
			$.csSelect.setMrgy(id);
			$.csSelect.changeTZ_Type(id);
			$.csSelect.cancelKxgy(id);
			$.csSelect.fabric("3","DBK053A");
			
		}else if(id=="2000"){
			var submit_vals ="<tr><td>底襟形式<input id='xk_djxs_val' type='text'/></td></tr><tr><td>脚口形式<input id='xk_jkxs_val' type='text'/></td></tr>"+
			"<tr><td>宝剑头形式<input id='xk_bjtxs_val' type='text'/></td></tr><tr><td>表袋形式<input id='xk_bdxs_val' type='text'/></td></tr>"+
			"<tr><td>宝剑头长度<input id='xk_bjtcd_val' type='text'/></td></tr><tr><td>后袋形式<input id='xk_hdxs_val' type='text' type='text'/></td></tr>";
			$("#submit_vals").html(submit_vals);

			$.csSelect.setMrgy(id);
			$.csSelect.changeTZ_Type(id);
			$.csSelect.cancelKxgy(id);
			$.csSelect.fabric("2000","DBK053A");
		}else if(id=="3000"){
			var submit_vals ="<tr><td>过肩形式<input id='cy_gjxs_val' type='text'/></td></tr>"+
			"<tr><td>下摆形式<input id='cy_xbxs_val' type='text'/></td></tr><tr><td>门襟宽度<input id='cy_mjkd_val' type='text'/></td></tr>"+
			"<tr><td>前片形式<input id='cy_qpxs_val' type='text'/></td></tr><tr><td>后背形式<input id='cy_hbxs_val' type='text'/></td></tr>"+
			"<tr><td>袖头<input id='cy_xt_val' type='text' type='text'/></td></tr><tr><td>袖头高度<input id='cy_xtgd_val' type='text'/></td></tr>"+
			"<tr><td>口袋<input id='cy_kd_val' type='text'/></td></tr><tr><td>领形<input id='cy_lx_val' type='text'/></td></tr><tr><td>袖子<input id='cy_xz_val' type='text'/></td></tr>"+
			"<tr><td>领子明线0.15<input id='cy_lzmx_val' type='text'/></td></tr><tr><td>门襟明线0.15<input id='cy_mjmx_val' type='text'/></td></tr>"+
			"<tr><td>领中线斜拐<input id='cy_lzxxg_val' type='text' type='text'/></td></tr><tr><td>普通袖口单折<input id='cy_xkdz_val' type='text'/></td></tr>"+
			"<tr><td>门襟最后一眼锁横眼<input id='cy_mjhy_val' type='text'/></td></tr><tr><td>领台第一个眼锁45度斜眼<input id='cy_ltxy_val' type='text'/></td></tr>";
			$("#submit_vals").html(submit_vals);

			$.csSelect.setMrgy(id);
			$.csSelect.changeTZ_Type(id);
			$.csSelect.cancelKxgy(id);
			$.csSelect.fabric("3000","SAF191A");
		}else if(id=="4000"){
			var submit_vals ="<tr><td>驳头眼形式<input id='mj_btyxs_val' type='text'/></td></tr>"+
			"<tr><td>胸袋形式<input id='mj_xdxs_val' type='text'/></td></tr><tr><td>下口袋形式<input id='mj_xkdxs_val' type='text'/></td></tr>"+
			"<tr><td>后背形式<input id='mj_hbxs_val' type='text'/></td></tr><tr><td>扣种类<input id='mj_kzl_val' type='text'/></td></tr>"+
			"<tr><td>下口形式<input id='mj_xkxs_val' type='text' type='text'/></td></tr><tr><td></td></tr>";
			$("#submit_vals").html(submit_vals);

			$.csSelect.setMrgy(id);
			$.csSelect.changeTZ_Type(id);
			$.csSelect.cancelKxgy(id);
			$.csSelect.fabric("4000","DBL625A");
		}else if(id=="6000"){
			var submit_vals ="<tr><td>驳头眼形式<input id='dy_btyxs_val' type='text'/></td></tr>"+
			"<tr><td>扣种类<input id='dy_kzl_val' type='text'/></td></tr><tr><td>胸袋形式<input id='dy_xdxs_val' type='text'/></td></tr>"+
			"<tr><td>后背开衩形式<input id='dy_hbkcxs_val' type='text'/></td></tr><tr><td>下口袋形式<input id='dy_xkdxs_val' type='text'/></td></tr>"+
			"<tr><td>挂面形式<input id='dy_gmxs_val' type='text' type='text'/></td></tr><tr><td>袖扣数量<input id='dy_xksl_val' type='text'/></td></tr>"+
			"<tr><td>袖衩形式<input id='dy_xcxs_val' type='text'/></td></tr><tr><td>里子造型与下口<input id='dy_lzzxyxk_val' type='text'/></td></tr>";
			$("#submit_vals").html(submit_vals);

			$.csSelect.setMrgy(id);
			$.csSelect.changeTZ_Type(id);
			$.csSelect.cancelKxgy(id);
			$.csSelect.fabric("6000","DBL510A");
		}
	},
	changeTZ_Type : function(id){//切换西服、西裤、衬衣
		$.csSelect.showJbgy($.cookie("logo"));//基本工艺
		 if(id=="3"){
			$("#jbpz3").show();
			$("#jbpz2000").hide();
			$("#jbpz3000").hide();
			$("#jbpz4000").hide();
			$("#jbpz6000").hide();
			$("#mrgy3").show();
			$("#mrgy2000").hide();
			$("#mrgy3000").hide();
			$("#mrgy4000").hide();
			$("#mrgy6000").hide();
			$("#jbgy_img").html("<img src='images/51_37.png' alt='image'/>");
			$("#kx_gyxz3").show();
			$("#kx_gyxz2000").hide();
			$("#kx_gyxz3000").hide();
			$("#kx_gyxz4000").hide();
			$("#kx_gyxz6000").hide();
			$("#mrgy_1").show();
			$("#mrgy_2000").hide();
			$("#mrgy_3000").hide();
			$("#mrgy_4000").hide();
			$("#mrgy_6000").hide();
			if($("#type").val() == 1 || $("#type").val() == 2){
				$("#submit_button").css("display","none");
				$("#2pcs_2000fabric").css("display","none");
				$("#2pcs_3fabric").css("display","block");
			}else{
				$("#submit_button").css("display","block");
				$("#2pcs_2000fabric").css("display","block");
				$("#2pcs_3fabric").css("display","none");
			}
		}else if(id=="2000"){
			$("#jbpz3").hide();
			$("#jbpz2000").show();
			$("#jbpz3000").hide();
			$("#jbpz4000").hide();
			$("#jbpz6000").hide();
			$("#mrgy3").hide();
			$("#mrgy2000").show();
			$("#mrgy3000").hide();
			$("#mrgy4000").hide();
			$("#mrgy6000").hide();
			$("#jbgy_img").html("<img src='images/2034_2049.png' alt='image'/>");
			$("#kx_gyxz3").hide();
			$("#kx_gyxz2000").show();
			$("#kx_gyxz3000").hide();
			$("#kx_gyxz4000").hide();
			$("#kx_gyxz6000").hide();
			$("#mrgy_3000").hide();
			$("#mrgy_4000").hide();
			$("#mrgy_6000").hide();
			$("#submit_button").css("display","block");
			$("#2pcs_2000fabric").css("display","block");
			$("#2pcs_3fabric").css("display","none");
			if($("#type").val() == 1 ||$("#type").val() == 2){
				$("#mrgy_1").show();
				$("#mrgy_2000").hide();
			}else if($("#type").val() == 2000){
				$("#mrgy_1").hide();
				$("#mrgy_2000").show();
			}
			if($("#type").val() == 2){
				$("#submit_button").css("display","none");
				$("#2pcs_2000fabric").css("display","none");
				$("#2pcs_3fabric").css("display","none");
				$("#3pcs_2000fabric").css("display","block");
			}else{
				$("#submit_button").css("display","block");
				$("#2pcs_2000fabric").css("display","block");
				$("#2pcs_3fabric").css("display","none");
			}
		}else if(id=="3000"){
			$("#jbpz3").hide();
			$("#jbpz2000").hide();
			$("#jbpz3000").show();
			$("#mrgy3").hide();
			$("#mrgy2000").hide();
			$("#mrgy3000").show();
			$("#jbgy_img").html("<img src='images/3063_3040.png' alt='image'/>");
			$("#kx_gyxz3").hide();
			$("#kx_gyxz2000").hide();
			$("#kx_gyxz3000").show();
			$("#kx_gyxz4000").hide();
			$("#kx_gyxz6000").hide();
			$("#mrgy_1").hide();
			$("#mrgy_2000").hide();
			$("#mrgy_3000").show();
			$("#mrgy_4000").hide();
			$("#mrgy_6000").hide();
			$("#submit_button").css("display","block");
			$("#2pcs_2000fabric").css("display","block");
			$("#2pcs_3fabric").css("display","none");
		}else if(id=="4000"){
			$("#jbpz3").hide();
			$("#jbpz2000").hide();
			$("#jbpz3000").hide();
			$("#jbpz4000").show();
			$("#jbpz6000").hide();
			$("#mrgy3").hide();
			$("#mrgy2000").hide();
			$("#mrgy3000").hide();
			$("#mrgy4000").show();
			$("#mrgy6000").hide();
			$("#jbgy_img").html("<img src='images/4023_4038.png' alt='image'/>");
			$("#kx_gyxz3").hide();
			$("#kx_gyxz2000").hide();
			$("#kx_gyxz3000").hide();
			$("#kx_gyxz4000").show();
			$("#kx_gyxz6000").hide();
			if($("#type").val() == 2){
				$("#mrgy_1").show();
				$("#mrgy_4000").hide();
			}else if($("#type").val() == 4000){
				$("#mrgy_1").hide();
				$("#mrgy_4000").show();
			}
			$("#mrgy_2000").hide();
			$("#mrgy_3000").hide();
			$("#mrgy_6000").hide();
			$("#submit_button").css("display","block");
			$("#2pcs_2000fabric").css("display","block");
			$("#2pcs_3fabric").css("display","none");
		}else if(id=="6000"){
			$("#jbpz3").hide();
			$("#jbpz2000").hide();
			$("#jbpz3000").hide();
			$("#jbpz4000").hide();
			$("#jbpz6000").show();
			$("#mrgy3").hide();
			$("#mrgy2000").hide();
			$("#mrgy3000").hide();
			$("#mrgy4000").hide();
			$("#mrgy6000").show();
			$("#jbgy_img").html("<img src='images/6030_6016.png' alt='image'/>");
			$("#kx_gyxz3").hide();
			$("#kx_gyxz2000").hide();
			$("#kx_gyxz3000").hide();
			$("#kx_gyxz4000").hide();
			$("#kx_gyxz6000").show();
			$("#mrgy_1").hide();
			$("#mrgy_2000").hide();
			$("#mrgy_3000").hide();
			$("#mrgy_4000").hide();
			$("#mrgy_6000").show();
			$("#submit_button").css("display","block");
			$("#2pcs_2000fabric").css("display","block");
			$("#2pcs_3fabric").css("display","none");
		}
	},
	cancelKxgy : function(type){
		//cameo 默认
		if(type == 1 || type == 2 || type ==3){
			$.csSelect.cancelChecked('kzl');
			$.csSelect.cancelChecked('xdxs');
//			$.csSelect.cancelChecked('hbkcxs');
			$.csSelect.cancelChecked('hbkctz');
			$.csSelect.cancelChecked('xcxs');
			$.csSelect.cancelChecked('xksl');
			$.csSelect.cancelChecked('btyxs');
			$.csSelect.cancelChecked('xkdxs');
			$.csSelect.cancelChecked('gmxs');
			$.csSelect.cancelChecked('lzzxyxk');
			//默认可选工艺
			$.csSelect.setChecked('1379');
			$.csSelect.setChecked('132');
//			$.csSelect.setChecked('216');
			$.csSelect.setChecked('178');
			$.csSelect.setChecked('194');
			$.csSelect.setChecked('79');
			$.csSelect.setChecked('145_160');
			$.csSelect.setChecked('219');
			$.csSelect.setChecked('201_226');
		}
		if(type == 1 || type == 2 || type ==2000){
			$.csSelect.cancelChecked('xk_kzl');
			$.csSelect.cancelChecked('xk_kytjxs');
			$.csSelect.cancelChecked('xk_djxs');
			$.csSelect.cancelChecked('xk_jkxs');
			$.csSelect.cancelChecked('xk_bjtxs');
			$.csSelect.cancelChecked('xk_bdxs');
			$.csSelect.cancelChecked('xk_bjtcd');
//			$.csSelect.cancelChecked('xk_hdxs');
			//默认可选工艺
			$.csSelect.setChecked('2635');
			$.csSelect.setChecked('2957');
			$.csSelect.setChecked('2146');
			$.csSelect.setChecked('2093_2098');
			$.csSelect.setChecked('2101');
//			$.csSelect.setChecked('2081_2088');
		}
		if(type ==3000){
			$.csSelect.cancelChecked('cy_gjxs');
			$.csSelect.cancelChecked('cy_xbxs');
			$.csSelect.cancelChecked('cy_mjkd');
			$.csSelect.cancelChecked('cy_qpxs');
			$.csSelect.cancelChecked('cy_hbxs');
			$.csSelect.cancelChecked('cy_xt');
			$.csSelect.cancelChecked('cy_xtgd');
			$.csSelect.cancelChecked('cy_kd');
			$.csSelect.cancelChecked('cy_lx');
			$.csSelect.cancelChecked('cy_lzmx');
			$.csSelect.cancelChecked('cy_xz');
			//默认可选工艺
			$.csSelect.setChecked('3051');
			$.csSelect.setChecked('3175');
			$.csSelect.setChecked('3866');
			$.csSelect.setChecked('3355');
			$.csSelect.setChecked('3095');
			$.csSelect.setChecked('3028');
			$("#cy_3092").val("");
			$("#cy_3030").val("");
			$("#cy_3091").val("");
			$("#cy_7045").val("");
			$("#cy_3090").val("");
		}
		if(type == 2 || type ==4000){
			$.csSelect.cancelChecked('mj_btyxs');
			$.csSelect.cancelChecked('mj_xdxs');
			$.csSelect.cancelChecked('mj_xkdxs');
			$.csSelect.cancelChecked('mj_hbxs');
			$.csSelect.cancelChecked('mj_kzl');
			$.csSelect.cancelChecked('mj_xkxs');
		}
		if(type ==6000){
			$.csSelect.cancelChecked('dy_btyxs');
			$.csSelect.cancelChecked('dy_kzl');
			$.csSelect.cancelChecked('dy_xdxs');
			$.csSelect.cancelChecked('dy_hbkcxs');
			$.csSelect.cancelChecked('dy_xkdxs');
			$.csSelect.cancelChecked('dy_gmxs');
			$.csSelect.cancelChecked('dy_xksl');
			$.csSelect.cancelChecked('dy_xcxs');
			$.csSelect.cancelChecked('dy_lzzxyxk');
		}
//		if($.cookie("logo") != 20138 && $.cookie("logo") != 20144 && $.cookie("logo") != 20140){//不为凯妙、瑞璞
			if($.cookie("logo") == 0){//联翔服装设计有限公司
				if(type == 1 || type ==3){//套装、上衣
					//全毛衬
					$.csSelect.cancelChecked('mc');
					$.csSelect.setChecked('000A');
					//默认可选工艺
					$.csSelect.cancelChecked('kzl');
					$.csSelect.setChecked('1379');
					$.csSelect.cancelChecked('hbkcxs');
					$.csSelect.setChecked('215');
					$.csSelect.cancelChecked('xcxs');
					$.csSelect.setChecked('178');
					$.csSelect.cancelChecked('xdxs');
					$.csSelect.setChecked('130');
					$.csSelect.cancelChecked('gmxs');
					$.csSelect.setChecked('220');
					$.csSelect.cancelChecked('btyxs');
					//联翔服装设计有限公司-- 戗驳头、单排一粒扣7.6
					$.csSelect.gyOut('1');
					$.csSelect.gyOver('1');
					$.csSelect.changebt('1','52');
					$.csSelect.kzOut('0');
					$.csSelect.kzOver('0');
					$.csSelect.changekz('0','10','36');
					$.csSelect.cancelChecked('btk');
					$.csSelect.setChecked('92');
					$("#btk_val").val('92');
				}
				if(type == 1 || type ==2000){//套装、西裤
					//全毛衬
					$.csSelect.cancelChecked('mc');
					$.csSelect.setChecked('000A');
					//默认可选工艺
					$.csSelect.cancelChecked('xk_kzl');
					$.csSelect.setChecked('2635');
					$.csSelect.cancelChecked('xk_hdxs');
					$.csSelect.setChecked('2345_2088');
					$.csSelect.cancelChecked('xk_jkxs');
					$.csSelect.setChecked('2147');
					//联翔服装设计有限公司-- 无褶裤
					$.csSelect.kzxsOut('0');
					$.csSelect.kzxsOver('0');
					$.csSelect.changeKzxs('0','2033');
				}
				if(type ==3000){//衬衣
					//默认可选工艺
					$.csSelect.cancelChecked('cy_hbxs');
					$.csSelect.setChecked('3055');
					$.csSelect.cancelChecked('cy_xtgd');
					$.csSelect.setChecked('7012');
					$.csSelect.cancelChecked('cy_xt');
					$.csSelect.setChecked('3119');
					//联翔服装设计有限公司--中方领
					$.csSelect.lxOut('3');
					$.csSelect.lxOver('3');
					$.csSelect.changeLx('3','3066');
				}
			}else{//红领
				if(type == 1 || type ==3){//套装、上衣
					//半毛衬
					$.csSelect.cancelChecked('mc');
					$.csSelect.setChecked('000B');
					//默认可选工艺
					$.csSelect.cancelChecked('kzl');
					$.csSelect.cancelChecked('xcxs');
					$.csSelect.setChecked('179');
					$.csSelect.cancelChecked('xdxs');
					$.csSelect.setChecked('130');
					$.csSelect.cancelChecked('btyxs');
					$.csSelect.cancelChecked('hbkcxs');
					$.csSelect.setChecked('213');
					//平驳头
					$.csSelect.gyOut('0');
					$.csSelect.gyOver('0');
					$.csSelect.changebt('0','51');
				}
				if(type == 1 || type ==2000){//套装、西裤
					$.csSelect.cancelChecked('mc');
					$.csSelect.setChecked('000B');
					//默认可选工艺
					$.csSelect.cancelChecked('xk_kzl');
					$.csSelect.cancelChecked('xk_bjtxs');
					$.csSelect.setChecked('2094_2098');
					$.csSelect.cancelChecked('xk_hdxs');
					$.csSelect.setChecked('2345_2088');
					//单褶褶向侧缝
					$.csSelect.kzxsOut('1');
					$.csSelect.kzxsOver('1');
					$.csSelect.changeKzxs('1','2034');
				}
				if(type ==3000){//衬衣
					//大尖领
					$.csSelect.lxOut('0');
					$.csSelect.lxOver('0');
					$.csSelect.changeLx('0','3063');
				}
			}
		/*}else{//凯秒
			if(type == 1 || type ==3){//套装、上衣
				//半毛衬
				$.csSelect.cancelChecked('mc');
				$.csSelect.setChecked('000B');
				//平驳头
				$.csSelect.gyOut('0');
				$.csSelect.gyOver('0');
				$.csSelect.changebt('0','51');
			}
			if(type == 1 || type ==2000){//套装、西裤
				//半毛衬
				$.csSelect.cancelChecked('mc');
				$.csSelect.setChecked('000B');
				//单褶褶向侧缝
				$.csSelect.kzxsOut('1');
				$.csSelect.kzxsOver('1');
				$.csSelect.changeKzxs('1','2034');
			}
			if(type ==3000){//衬衣
				//大尖领
				$.csSelect.lxOut('0');
				$.csSelect.lxOver('0');
				$.csSelect.changeLx('0','3063');
			}
		}*/
		
	},
	cancelChecked: function (chkRow) {//取消选中
        $('[name=' + chkRow + ']').each(function () {
            if (this.checked == true) {
            	this.checked = false;
            }
        });
    },
    setChecked: function (value) {//选中
    	var radio = $("input[value='" + value + "']");
        if (radio.length > 0) {
            radio.attr("checked", "checked");
        }
    },
	showJbgy : function(logoId){
		/*var str ="<table id='mrgy3'>"+
		"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_132")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_1889")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_6769")+"</td><td align='left'>"+$.csCore.getValue("Dict_82071")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_70049")+"</td><td align='left'>"+$.csCore.getValue("Dict_82077")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_60897")+"</td><td align='left'>"+$.csCore.getValue("Dict_6087")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_60883")+"</td><td align='left'>"+$.csCore.getValue("Dict_2639")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_178")+"</td><td align='left'>"+$.csCore.getValue("Dict_32334")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_32335")+"</td><td align='left'>"+$.csCore.getValue("Dict_30252")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_40641")+"</td><td align='left'>"+$.csCore.getValue("Dict_32336")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_60892")+"</td><td align='left'>"+$.csCore.getValue("Dict_32338")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_60867")+"</td><td align='left'>"+$.csCore.getValue("Dict_1961")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_60894")+"</td><td align='left'>"+$.csCore.getValue("Dict_30253")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_32340")+"</td></tr></table>"+
		"<table id='mrgy2000' style='display: none;'>"+
		"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("SSB_QZFH")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_2356")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("SSB_3611")+"</td><td align='left'>"+$.csCore.getValue("Dict_40057")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_2994")+"</td><td align='left'>"+$.csCore.getValue("Dict_6075")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_6185")+"</td><td align='left'>"+$.csCore.getValue("Dict_60033")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_40640")+"</td><td align='left'>"+$.csCore.getValue("SSB_KDQMZB")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_1469")+"</td><td align='left'>"+$.csCore.getValue("Dict_2353")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("SSB_345M")+"</td><td align='left'>"+$.csCore.getValue("Dict_2682")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_2808")+"</td><td align='left'>"+$.csCore.getValue("Dict_40041")+"</td></tr>"+
		"<tr><td align='left' width=132>"+$.csCore.getValue("Dict_2355")+"</td></tr></table>"+
		"<table id='mrgy3000' style='display: none;'><tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_3085")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("SSB_DJL345")+"</td></tr>"+
    	"<tr><td align='left'>"+$.csCore.getValue("Dict_3355")+"</td><td align='left'>"+$.csCore.getValue("Dict_3076")+"</td></tr>"+
    	"<tr><td align='left'>"+$.csCore.getValue("Dict_3175")+"</td><td align='left'>"+$.csCore.getValue("SSB_YYY")+"</td></tr>"+
    	"<tr><td align='left'>"+$.csCore.getValue("Dict_3040")+"</td><td align='left'>"+$.csCore.getValue("Dict_3866")+"</td></tr>"+
    	"<tr><td align='left'>"+$.csCore.getValue("Dict_2047")+"</td><td align='left'>"+$.csCore.getValue("SSB_ZCGJ")+"</td></tr></table>"+
    	"<table id='mrgy4000' style='display: none;'>"+
		"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_4280")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_2661")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_40639")+"</td><td align='left'>"+$.csCore.getValue("Dict_2639")+"</td></tr>"+
		"<tr><td align='left' width=132>"+$.csCore.getValue("Dict_40641")+"</td></tr></table>"+
		"<table id='mrgy6000' style='display: none;'>"+
		"<tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_6769")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_6767")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_6742")+"</td><td align='left'>"+$.csCore.getValue("Dict_1380")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_30129")+"</td><td align='left'>"+$.csCore.getValue("Dict_1998")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_1483")+"</td><td align='left'>"+$.csCore.getValue("Dict_1482")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_1965")+"</td><td align='left'>"+$.csCore.getValue("Dict_178")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_32335")+"</td><td align='left'>"+$.csCore.getValue("Dict_32334")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_30252")+"</td><td align='left'>"+$.csCore.getValue("Dict_1469")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_32336")+"</td><td align='left'>"+$.csCore.getValue("Dict_32337")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_32339")+"</td><td align='left'>"+$.csCore.getValue("Dict_32340")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_30253")+"</td><td align='left'>"+$.csCore.getValue("Dict_30254")+"</td></tr>"+
		"<tr><td align='left' width=132>"+$.csCore.getValue("Dict_32338")+"</td></tr></table>";*/
		var str ="<table id='mrgy3'><tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_51")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("SSB_BTK83")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_37")+"</td><td align='left'>"+$.csCore.getValue("Dict_6054")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("SSB_QLZ")+"</td><td align='left'>"+$.csCore.getValue("Dict_219")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_6191")+"</td><td align='left'>"+$.csCore.getValue("Dict_194")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("SSB_YXBXK")+"</td><td align='left'>"+$.csCore.getValue("Dict_3229")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("SSB_XCSY")+"</td><td align='left'>"+$.csCore.getValue("SSB_WZBS")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("SSB_SYSML")+"</td><td align='left'>"+$.csCore.getValue("SSB_SMLSLB")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("SSB_BSYLB")+"</td><td align='left'>"+$.csCore.getValue("SSB_SJHT")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_6244")+"</td><td align='left'>"+$.csCore.getValue("Dict_1934")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("SSB_NZBSML")+"</td></tr></table>"+
		"<table id='mrgy2000' style='display: none;'><tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_2034")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("SSB_SKXSYDK")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("SSB_ZS25")+"</td><td align='left'>"+$.csCore.getValue("SSB_JBJT")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_2113")+"</td><td align='left'>"+$.csCore.getValue("SSB_BJTC55")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("SSB_25XCKD")+"</td><td align='left'>"+$.csCore.getValue("SSB_NLLL")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("SSB_ZCCD")+"</td><td align='left'>"+$.csCore.getValue("SSB_QBKL")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_2957")+"</td><td align='left'>"+$.csCore.getValue("SSB_SYSML")+"</td></tr>"+
		"<tr><td align='left'>"+$.csCore.getValue("Dict_3229")+"</td><td align='left'>"+$.csCore.getValue("SSB_KJNZ5")+"</td></tr>"+
		"<tr><td align='left' width=132>"+$.csCore.getValue("Dict_2666")+"</td></tr></table>"+
		"<table id='mrgy3000' style='display: none;'><tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_3085")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("SSB_DJL345")+"</td></tr>"+
    	"<tr><td align='left'>"+$.csCore.getValue("Dict_3355")+"</td><td align='left'>"+$.csCore.getValue("Dict_3076")+"</td></tr>"+
    	"<tr><td align='left'>"+$.csCore.getValue("Dict_3175")+"</td><td align='left'>"+$.csCore.getValue("SSB_YYY")+"</td></tr>"+
    	"<tr><td align='left'>"+$.csCore.getValue("Dict_3040")+"</td><td align='left'>"+$.csCore.getValue("Dict_3866")+"</td></tr>"+
    	"<tr><td align='left'>"+$.csCore.getValue("Dict_2047")+"</td><td align='left'>"+$.csCore.getValue("SSB_ZCGJ")+"</td></tr></table>"+
		"<table id='mrgy4000' style='display: none;'><tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_4023")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_40")+"</td></tr>"+
    	"<tr><td align='left'>"+$.csCore.getValue("Dict_4638")+"</td><td align='left'>"+$.csCore.getValue("Dict_4070")+"</td></tr>"+
    	"<tr><td align='left'>"+$.csCore.getValue("Dict_4066")+"</td><td align='left'>"+$.csCore.getValue("Dict_4050")+"</td></tr></table>"+
		"<table id='mrgy6000' style='display: none;'><tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_6016")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_6030")+"</td></tr>"+
    	"<tr><td align='left'>"+$.csCore.getValue("Dict_6044")+"</td><td align='left'>"+$.csCore.getValue("Dict_6054")+"</td></tr>"+
    	"<tr><td align='left'>"+$.csCore.getValue("Dict_6126")+"</td><td align='left'>"+$.csCore.getValue("Dict_6156")+"</td></tr>"+
    	"<tr><td align='left'>"+$.csCore.getValue("Dict_6174")+"</td><td align='left'>"+$.csCore.getValue("Dict_6192")+"</td></tr></table>";
		/*var str ="<table id='mrgy3'><tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_51")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("SSB_BTK83")+"</td></tr>"+
				"<tr><td align='left'>"+$.csCore.getValue("Dict_37")+"</td><td align='left'>"+$.csCore.getValue("Dict_6054")+"</td></tr>"+
				"<tr><td align='left'>"+$.csCore.getValue("SSB_QLZ")+"</td><td align='left'>"+$.csCore.getValue("Dict_219")+"</td></tr>"+
				"<tr><td align='left'>"+$.csCore.getValue("Dict_6191")+"</td><td align='left'>"+$.csCore.getValue("Dict_194")+"</td></tr>"+
				"<tr><td align='left'>"+$.csCore.getValue("SSB_YXBXK")+"</td><td align='left'>"+$.csCore.getValue("Dict_3229")+"</td></tr>"+
				"<tr><td align='left'>"+$.csCore.getValue("SSB_XCSY")+"</td><td align='left'>"+$.csCore.getValue("SSB_WZBS")+"</td></tr>"+
				"<tr><td align='left'>"+$.csCore.getValue("SSB_SYSML")+"</td><td align='left'>"+$.csCore.getValue("SSB_SMLSLB")+"</td></tr>"+
				"<tr><td align='left'>"+$.csCore.getValue("SSB_BSYLB")+"</td><td align='left'>"+$.csCore.getValue("SSB_SJHT")+"</td></tr>"+
				"<tr><td align='left'>"+$.csCore.getValue("Dict_6244")+"</td><td align='left'>"+$.csCore.getValue("Dict_1934")+"</td></tr>"+
				"<tr><td align='left'>"+$.csCore.getValue("SSB_NZBSML")+"</td></tr></table>"+
				"<table id='mrgy2000' style='display: none;'><tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_2034")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("SSB_SKXSYDK")+"</td></tr>"+
				"<tr><td align='left'>"+$.csCore.getValue("SSB_ZS25")+"</td><td align='left'>"+$.csCore.getValue("SSB_JBJT")+"</td></tr>"+
				"<tr><td align='left'>"+$.csCore.getValue("Dict_2113")+"</td><td align='left'>"+$.csCore.getValue("SSB_BJTC55")+"</td></tr>"+
				"<tr><td align='left'>"+$.csCore.getValue("SSB_25XCKD")+"</td><td align='left'>"+$.csCore.getValue("SSB_NLLL")+"</td></tr>"+
				"<tr><td align='left'>"+$.csCore.getValue("SSB_ZCCD")+"</td><td align='left'>"+$.csCore.getValue("SSB_QBKL")+"</td></tr>"+
				"<tr><td align='left'>"+$.csCore.getValue("Dict_2957")+"</td><td align='left'>"+$.csCore.getValue("SSB_SYSML")+"</td></tr>"+
				"<tr><td align='left'>"+$.csCore.getValue("Dict_3229")+"</td><td align='left'>"+$.csCore.getValue("SSB_KJNZ5")+"</td></tr>"+
				"<tr><td align='left' width=132>"+$.csCore.getValue("Dict_2666")+"</td></tr></table>"+
				"<table id='mrgy3000' style='display: none;'><tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_3085")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("SSB_DJL345")+"</td></tr>"+
	        	"<tr><td align='left'>"+$.csCore.getValue("Dict_3355")+"</td><td align='left'>"+$.csCore.getValue("Dict_3076")+"</td></tr>"+
	        	"<tr><td align='left'>"+$.csCore.getValue("Dict_3175")+"</td><td align='left'>"+$.csCore.getValue("SSB_YYY")+"</td></tr>"+
	        	"<tr><td align='left'>"+$.csCore.getValue("Dict_3040")+"</td><td align='left'>"+$.csCore.getValue("Dict_3866")+"</td></tr>"+
	        	"<tr><td align='left'>"+$.csCore.getValue("Dict_2047")+"</td><td align='left'>"+$.csCore.getValue("SSB_ZCGJ")+"</td></tr></table>";
		if(logoId == 20138 || logoId == 20144 || logoId == 20140){//凯妙、瑞璞
			 str ="<table id='mrgy3'><tr><td align='left' class='cameoXF'>"+$.csCore.getValue("Dict_6110")+"</td><td align='left' class='cameoXF'>"+$.csCore.getValue("Dict_4996")+"</td></tr>"+
	        	"<tr class='isShow'><td align='left' class='cameoXF'>"+$.csCore.getValue("Dict_1379")+"</td><td align='left' class='cameoXF'>"+$.csCore.getValue("SSB_YZKKY")+"</td></tr>"+
	        	"<tr class='isShow'><td align='left' class='cameoXF'>"+$.csCore.getValue("Dict_1998")+"</td><td align='left' class='cameoXF'>"+$.csCore.getValue("Dict_999")+"</td></tr>"+
	        	"<tr><td align='left' class='cameoXF'>"+$.csCore.getValue("Dict_1381")+"</td><td align='left' class='cameoXF'>"+$.csCore.getValue("Dict_2990")+"</td></tr>"+
	        	"<tr><td align='left' class='cameoXF'>"+$.csCore.getValue("Dict_178")+"</td><td align='left' style='width:180px;height:20px;'>"+$.csCore.getValue("SSB_LDTJNZB")+"</td></tr>"+
	        	"<tr><td align='left' class='cameoXF'>"+$.csCore.getValue("SSB_DKDK")+"</td><td align='left' class='cameoXF'>"+$.csCore.getValue("Dict_1963")+"</td></tr>"+
	        	"<tr><td align='left' class='cameoXF'>"+$.csCore.getValue("Dict_2639")+"</td><td align='left' class='cameoXF'></td></tr></table>"+
	            "<table id='mrgy2000' style='display: none;'><tr><td align='left' class='cameoXK'>"+$.csCore.getValue("Dict_2354")+"</td><td align='left' class='cameoXK'>"+$.csCore.getValue("Dict_2356")+"</td></tr>"+
	        	"<tr><td align='left' class='cameoXK'>"+$.csCore.getValue("SSB_QZFH")+"</td><td align='left' class='cameoXK'>"+$.csCore.getValue("SSB_KDQMZB")+"</td></tr>"+
	        	"<tr><td align='left' class='cameoXK'>"+$.csCore.getValue("Dict_2353")+"</td><td align='left' class='cameoXK'>"+$.csCore.getValue("SSB_YBJT")+"</td></tr>"+
	        	"<tr><td align='left' class='cameoXK'>"+$.csCore.getValue("Dict_2990")+"</td><td align='left' class='cameoXK'>"+$.csCore.getValue("Dict_1379")+"</td></tr>"+
	        	"<tr><td align='left' class='cameoXK'>"+$.csCore.getValue("SSB_34A8")+"</td><td align='left' class='cameoXK'>"+$.csCore.getValue("Dict_2639")+"</td></tr>"+
	        	"<tr><td colspan='2' align='left' style='height:20px;'>"+$.csCore.getValue("SSB_XKCAMEOSB")+"</td></tr>"+
	        	"<tr><td colspan='2' align='left' style='height:20px;'>"+$.csCore.getValue("Dict_2986")+"</td></tr>"+
	        	"<tr><td colspan='2' align='left' style='height:20px;'>"+$.csCore.getValue("Dict_2355")+" </td></tr></table>"+
	        	"<table id='mrgy3000' style='display: none;'><tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_3085")+"</td><td align='left' class='mr_GY'>"+$.csCore.getValue("SSB_DJL345")+"</td></tr>"+
	        	"<tr><td align='left'>"+$.csCore.getValue("Dict_3355")+"</td><td align='left'>"+$.csCore.getValue("Dict_3076")+"</td></tr>"+
	        	"<tr><td align='left'>"+$.csCore.getValue("Dict_3175")+"</td><td align='left'>"+$.csCore.getValue("SSB_YYY")+"</td></tr>"+
	        	"<tr><td align='left'>"+$.csCore.getValue("Dict_3040")+"</td><td align='left'>"+$.csCore.getValue("Dict_3866")+"</td></tr>"+
	        	"<tr><td align='left'>"+$.csCore.getValue("Dict_2047")+"</td><td align='left'>"+$.csCore.getValue("SSB_ZCGJ")+"</td></tr></table>";
			 $("#all_jbgy").html(str);
		}else */if(logoId == 0){//联翔服装设计有限公司
			str ="<table id='mrgy3'><tr><td align='left' class='clxXF'>"+$.csCore.getValue("Dict_52")+"</td><td align='left' class='clxXF'>"+$.csCore.getValue("Dict_432")+"</td></tr>"+
					"<tr><td align='left' class='clxXF'>"+$.csCore.getValue("Dict_220")+"</td><td align='left' class='clxXF'>"+$.csCore.getValue("SSB_BTK76")+"</td></tr>"+
					"<tr><td align='left' class='clxXF'>"+$.csCore.getValue("Dict_215")+"</td><td align='left' class='clxXF'>"+$.csCore.getValue("Dict_178")+"</td></tr>"+
					"<tr><td align='left' class='clxXF'>"+$.csCore.getValue("Dict_1378")+"</td><td align='left' class='clxXF'>"+$.csCore.getValue("Dict_36")+"</td></tr>"+
					"<tr><td align='left' class='clxXF'>"+$.csCore.getValue("Dict_1381")+"</td><td align='left' class='clxXF'>"+$.csCore.getValue("Dict_1474")+"</td></tr>"+
					"<tr><td align='left' class='clxXF'>"+$.csCore.getValue("Dict_1926")+"</td><td align='left' class='clxXF'>"+$.csCore.getValue("Dict_1950")+"</td></tr>"+
					"<tr><td align='left' class='clxXF'>"+$.csCore.getValue("Dict_1379")+"</td><td align='left' class='clxXF'>"+$.csCore.getValue("Dict_1385")+"</td></tr>"+
					"<tr><td colspan='2' align='left' class='clxXF'>"+$.csCore.getValue("Dict_1768")+"</td></tr>"+
					"<tr><td colspan='2' align='left' class='clxXF'>"+$.csCore.getValue("Dict_1473")+" -MINGTH</td></tr>"+
					"<tr><td colspan='2' align='left' class='clxXF'>"+$.csCore.getValue("Dict_1779")+"</td></tr>"+
					"<tr><td colspan='2' align='left'>"+$.csCore.getValue("Dict_565")+" -MINGTH</td></tr></table>"+
					"<table id='mrgy2000' style='display: none;'><tr><td colspan='2' align='left' class='mr_GY'>"+$.csCore.getValue("Dict_2033")+"</td></tr>"+
					"<tr><td align='left'>"+$.csCore.getValue("Dict_2635")+"</td></tr>"+
					"<tr><td align='left'>"+$.csCore.getValue("Dict_2681")+"</td></tr>"+
					"<tr><td align='left'>"+$.csCore.getValue("Dict_2147")+"</td></tr>"+
					"<tr><td align='left'>"+$.csCore.getValue("Dict_2356")+"</td></tr>"+
					"<tr><td align='left'>"+$.csCore.getValue("Dict_2353")+"</td></tr>"+
					"<tr><td align='left'>"+$.csCore.getValue("Dict_2334")+"</td></tr>"+
					"<tr><td align='left'>"+$.csCore.getValue("SSB_YBJT")+"</td></tr>"+
					"<tr><td align='left'>"+$.csCore.getValue("SSB_34A8")+"</td></tr>"+
					"<tr><td align='left'>"+$.csCore.getValue("Dict_2680")+"</td></tr>"+
					"<tr><td align='left'>"+$.csCore.getValue("Dict_2682")+"</td></tr>"+
					"<tr><td align='left'>"+$.csCore.getValue("Dict_2856")+"</td></tr>"+
					"<tr><td align='left'>"+$.csCore.getValue("Dict_2683")+" MINGTH</td></tr>"+
					"<tr><td align='left'>"+$.csCore.getValue("Dict_2679")+" KYFTC-CQXMYL</td></tr></table>"+
					"<table id='mrgy3000' style='display: none;'><tr><td align='left' class='mr_GY'>"+$.csCore.getValue("Dict_3055")+"</td></tr>"+
		        	"<tr><td align='left'>"+$.csCore.getValue("Dict_3066")+"</td></tr>"+
		        	"<tr><td align='left'>"+$.csCore.getValue("Dict_3086")+"</td></tr>"+
		        	"<tr><td align='left'>"+$.csCore.getValue("Dict_7012")+"</td></tr>"+
					"<tr><td align='left'>"+$.csCore.getValue("Dict_7072")+"</td></tr>"+
					"<tr><td align='left'>"+$.csCore.getValue("Dict_3119")+"</td></tr>"+
					"<tr><td align='left'>"+$.csCore.getValue("Dict_3803")+"</td></tr>"+
		        	"<tr><td align='left' style='width:180px;'>"+$.csCore.getValue("SSB_CLXCYSB")+"</td></tr></table>";
			$("#all_jbgy").html(str);
			$("#all_jbgy").css("margin-right", "120px");
		}else{
			$("#all_jbgy").html(str);
			$("#all_jbgy").css("margin-right", "120px");
		}
	},
	init:function(){
		var member = $.csCore.getCurrentMember();
//		var memberType=member.businessUnit;
		var memberType=member.logo;
		if(member.username == 'CLX'){//联翔服装设计有限公司
			memberType = 0;
		}else if(member.username != 'CLS' && member.username != 'OHDC' && member.username != 'OHDA' && member.username != 'OMS' && member.username != 'OMSA' && member.username != 'Client' && member.username != 'OSP' && member.username != 'NAGT' && member.username != 'TNMK' && member.username != 'TNMKA' && member.username != 'TNMKB'){//无logo
//			if(member.businessUnit == 20138 || member.businessUnit == 20144 || member.businessUnit == 20140){//凯妙、瑞璞
			if(memberType==20138){//凯妙
				$("#change_logo").html("<img src='images/cameo.png'></img>");
			}else{//RCMTM
				$("#change_logo").html("<img src='images/rcmtm.png'></img>");
			}
		}
		$.cookie("logo",memberType);
		$(".clothing_type").html("<select id='type' onchange='$.csSelect.changeType(this.value)'><option value='-1'>"+$.csCore.getValue("SSB_SELECT")+"</option><option value='1' selected='selected'>"+$.csCore.getValue("Dict_1")+"</option><option value='2'>"+$.csCore.getValue("Dict_2")+"</option><option value='3'>"+$.csCore.getValue("Dict_3")+"</option><option value='2000'>"+$.csCore.getValue("Dict_2000")+"</option><option value='3000'>"+$.csCore.getValue("Dict_3000")+"</option><option value='4000'>"+$.csCore.getValue("Dict_4000")+"</option><option value='6000'>"+$.csCore.getValue("Dict_6000")+"</option></select>");
		$.csSelect.bindLabel();
		$.csSelect.bindEvent();
		$.csSelect.changeType("1");//服装分类
		$.csSelect.showJbgy(memberType);//基本工艺
		$.csSelect.loadVersions();
	}
};