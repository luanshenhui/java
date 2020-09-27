jQuery.csFashion_post={
	bindLabel:function(){
		$("#right_title").html($.csCore.getValue("Label_FashionTitle"));
		$("#fabric_title").html($.csCore.getValue("Fabric_Moduler"));
		$("#process_title").html($.csCore.getValue("Label_FashionProcessTitle"));
		$("#theme_title").html($.csCore.getValue("Label_FashionThemeTitle"));
		$("#place_title").html($.csCore.getValue("Label_FashionPlaceTitle"));
		$("#anniu").html($.csCore.getValue("Button_SaveMyDesign"));
	},
	bindEvent:function (){
		$("#more").click(function(){$.csFashion_post.openFabric();});
	},
	save:function (){
		$.cookie("fashionClothing", 1);
		$.csCore.loadModal('../size/select.htm', 998, 440,
				function() {
					$.csSizeSelect.init();
				});
    },
    openFabric : function(){
    	if($("#more_fabric").is(":visible")){
    		$("#more").html($.csCore.getValue("Label_FabricOpen"));
    		$("#more_fabric").hide();
    	}else{
    		$("#more").html($.csCore.getValue("Label_FabricClose"));
    		$("#more_fabric").show();
    	}
    },
    changebg : function(now,start,all){//点击小图
    	this.displayHtml();
    	$("#bottom_model"+now).css("background","url(../../fashionIMG/img/cp_s_now.gif)");
    	for(var i=start;i<=all;i++){
			if(i !=  now){
				$("#bottom_model"+i).css("background","");
			}
		}
    	
    	var sisplayHtml = $("#"+now).html();
    	if(sisplayHtml.length==0){
    		this.fashion_right(now);//换工艺
    	}else{
    		$("#process_table").html($("#"+now).html());
    		$("#"+now).html("");
    	}

    	$.cookie("fashion", now);
    },
    flOver : function(now,url,qh){
    	if(qh == "M"){
    		$("#small_imgM"+now).css({border:"solid 2px","border-color":"#e00001"});
        	$("#small_imgM"+now).addClass("commom_class");
        	var strhtml="<a href='../../fashionIMG/"+ url + "L" +qh+".JPG' class='jqzoom'><img src='../../fashionIMG/"+ url + "M" +qh+".JPG'/></a>";
        	$("#top_model").html(strhtml);
    	}else{
    		$("#small_img"+now).css({border:"solid 2px","border-color":"#e00001"});
        	$("#small_img"+now).addClass("commom_class");
    		var strhtml="<a href='../../fashionIMG/"+ url + "L" +qh+".JPG' class='jqzoom'><img src='../../fashionIMG/"+ url + "M" +qh+".JPG'/></a>";
        	$("#top_model").html(strhtml);
    	}
    	
    	this.jqzoom();
    },
    flOut : function(now,qh){
    	if(qh == "M"){
    		$("#small_imgM"+now).css({border:"solid 1px","border-color":"#e2e1e3"});
        	$("#small_imgM"+now).removeClass("commom_class");
    	}else{
    		$("#small_img"+now).css({border:"solid 1px","border-color":"#e2e1e3"});
        	$("#small_img"+now).removeClass("commom_class");
    	}
    	
    },
    changebg1 : function(id,now,all){//点击面料
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
//		alert(id);
    	var param = $.csControl.appendKeyValue("", "fabriccode", id);
		$.csCore.invoke(url, param);
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
    changebg2 : function(id,now,start,all){//点击工艺
    	$("#gyimg_"+start+"_"+now).css('display','block');
    	$("#gy_"+start+"_"+now).css({border:"solid 2px","border-color":"#DF0001"});
    	$("#gy_"+start+"_"+now).addClass("commom_class");
    	for(var i=1;i<=all;i++){
			if(i !=  now){
				$("#gyimg_"+start+"_"+i).css("display","none");
				$("#gy_"+start+"_"+i).css({border:"solid 1px","border-color":"#e2e1e3"});
		    	$("#gy_"+start+"_"+i).removeClass("commom_class");
			}
		}
    	
    	// 存储选中的工艺
    	//alert(id);
    	var url = $.csCore.buildServicePath('/service/orden/settempcomponentid');
		var param = $.csControl.appendKeyValue("", "id", id);
		$.csCore.invoke(url, param);
	},
    gyOver : function(now){
    	$("#gy_"+now).css({border:"solid 2px","border-color":"#DF0001"});
    	$("#gy_"+now).addClass("commom_class");
    },
    gyOut : function(now){
    	if($("#gyimg_"+now).css("display") != "block"){
        	$("#gy_"+now).css({border:"solid 1px","border-color":"#e2e1e3"});
        	$("#gy_"+now).removeClass("commom_class");
    	}
    },
    fashion_come : function(src){
    	//清空工艺、面料、服装类型
    	$.csCore.invoke($.csCore.buildServicePath('/service/orden/cleartempdesigns'));
    	
    	//alert(src);
    	var str = new Array();
    	str = src.split("/");
    	var name = str[str.length-1].split(".")[0];
    	var xl = str[str.length-2];
    	//alert(name);
    	//根据款式号获取id
    	var params = $.csControl.appendKeyValue('', 'id', xl);
    	params = $.csControl.appendKeyValue(params, 'name', name);
		var fashion_data = $.csCore.invoke($.csCore.buildServicePath('/service/fashion/getfashionbyname'), params);
		var id = fashion_data.ID;
		//alert(id);
    	this.fashion_left(id);
		this.fashion_fabric(id);
    	this.fashion_right(id,1);
		
    	//获得服装分类
		var params = $.csControl.appendKeyValue('', 'id', id);
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/fashion/getfashioncategoryidbyid'), params);
		
//		alert(JSON.stringify(data));
		var currentVersion = $.csCore.getCurrentVersion();
		var describe = data.describe;
		var occasion = data.occasion;
		if(currentVersion == VERSION_EN){
			describe = data.describeEN;
			occasion = data.occasionEN;
		}else if(currentVersion == VERSION_DE){
			describe = data.describeDE;
			occasion = data.occasionDE;
		}else if(currentVersion == VERSION_FR){
			describe = data.describeFR;
			occasion = data.occasionFR;
		}else if(currentVersion == VERSION_JA){
			describe = data.describeJA;
			occasion = data.occasionJA;
		}
    	$("#des_theme").html(describe);//款式描述
		$("#des_place").html(occasion);//适合场合
		
		//储存选中的服装分类
		var url = $.csCore.buildServicePath('/service/orden/settempclothingid');
		var clothingParam = $.csControl.appendKeyValue("", "clothingid", data.code);
		$.csCore.invoke(url, clothingParam);
		
		//储存默认面料
		var fabricUrl = $.csCore.buildServicePath('/service/orden/settempfabriccode');
    	var fabricParam = $.csControl.appendKeyValue("", "fabriccode", fashion_data.extension);
		$.csCore.invoke(fabricUrl, fabricParam);
		
		//获取默认工艺
		var params = $.csControl.appendKeyValue('', 'id', id);
		var default_data = $.csCore.invoke($.csCore.buildServicePath('/service/fashion/getfashiondefaultprocess'), params);
//		alert(default_data);
		//储存默认工艺
		var arrStr = new Array();
		arrStr = default_data.split(";");
		if(arrStr.length >0){
			var arr = new Array();
			var str = arrStr[0];
			arr = str.split(",");
			for(var i=0;i<arr.length-1;i++){
//				alert(arr[i]);
				var processUrl = $.csCore.buildServicePath('/service/orden/settempcomponentid');
				var processParam = $.csControl.appendKeyValue("", "id", arr[i]);
				$.csCore.invoke(processUrl, processParam);
			}
			if(arrStr.length == 2 || arrStr.length == 3){
				var arrParam = new Array();
				var strParam = arrStr[1];
				arrParam = strParam.split(",");
				for(var i=0;i<arrParam.length-1;i++){
//					alert(arr[i]);
					var processUrl = $.csCore.buildServicePath('/service/orden/settempparameterid');
					var processParam = $.csControl.appendKeyValue("", "id", arrParam[i]);
					$.csCore.invoke(processUrl, processParam);
				}
			}
			if(arrStr.length == 3){
				var arrParamkhs = new Array();
				var strParamkhs = arrStr[2];
				arrParamkhs = strParamkhs.split(",");
				for(var i=0;i<arrParamkhs.length-1;i++){
					var arrParamkh = arrParamkhs[i];
					var arrParamkhm = new Array();
					arrParamkhm = arrParamkh.split(":");
					var url = $.csCore.buildServicePath('/service/orden/settempcomponenttext');
					var param = $.csControl.appendKeyValue("", "label", arrParamkhm[0]);
					param = $.csControl.appendKeyValue(param, "value", arrParamkhm[1]);
					$.csCore.invoke(url, param);
				}
			}
			
		}
//		else{
//			var arr = new Array();
//			arr = default_data.split(",");
//			for(var i=0;i<arr.length-1;i++){
////				alert(arr[i]);
//				var processUrl = $.csCore.buildServicePath('/service/orden/settempcomponentid');
//				var processParam = $.csControl.appendKeyValue("", "id", arr[i]);
//				$.csCore.invoke(processUrl, processParam);
//			}
//		}
		
		this.jqzoom();
    },
    fashion_left : function(id){//左侧
    	//alert("big"+id);
    	var param = $.csControl.appendKeyValue('', 'id', id);
		var bigdata = $.csCore.invoke($.csCore.buildServicePath('/service/fashion/getfashionleftbyid'), param);
    	$("#left_model").html(bigdata);
    	//alert(id+1);
    	var id =parseInt(id)+1;
    	$.cookie("fashion", id);
    },
	fashion_fabric : function(id){//右侧
//		alert("ml"+id);
		//面料
		var fabricparam = $.csControl.appendKeyValue('', 'id', id);
		var fabricdata = $.csCore.invoke($.csCore.buildServicePath('/service/fashion/getfabricbyid'), fabricparam);
    	$("#fabrics").html(fabricdata);
	},
	fashion_right : function(id,start){//右侧
//		alert("gy"+id);
    	//工艺
    	var processparam = $.csControl.appendKeyValue('', 'id', id);
    	processparam = $.csControl.appendKeyValue(processparam, 'start', start);
		var processdata = $.csCore.invoke($.csCore.buildServicePath('/service/fashion/getfashionrightbyid'), processparam);
    	$("#process_table").html(processdata);
	},
	jqzoom : function(){//放大效果
    	$('.jqzoom').jqzoom({
            zoomType: 'standard',
            lens:true,
            preloadImages: false,
            alwaysOn:false
        });
	},
	displayHtml : function(){
		var fashion = $.cookie("fashion");
		$("#"+fashion).html($("#process_table").html());
	},
	init:function(src){
		$.csFashion_post.bindLabel();
		$.csFashion_post.bindEvent();
		$.csFashion_post.fashion_come(src);
		
	}
};