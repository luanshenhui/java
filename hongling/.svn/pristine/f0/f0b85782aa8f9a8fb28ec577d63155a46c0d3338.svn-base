jQuery.csStyle = {
	/*loadJS:function(url,callback,charset)
    {
    	var script = document.createElement('script');
    	script.onload = script.onreadystatechange = function ()
    	{
    		if (script && script.readyState && /^(?!(?:loaded|complete)$)/.test(script.readyState)) return;
    		script.onload = script.onreadystatechange = null;
    		script.src = '';
    		script.parentNode.removeChild(script);
    		script = null;
    		if(callback)callback();
    	};
    	script.charset=charset || document.charset || document.characterSet;
    	script.src = url;
    	try {document.getElementsByTagName("head")[0].appendChild(script);} catch (e) {}
    },*/
	bindLabel: function() {
	},
	bindEvent: function() {
	},
	//TOP服装分类
	loadClothing: function() {
		 $.ajax({
            url: $.csCore.buildServicePath('/service/orden/getclothing'),
            data: '',
            type: "post",
            dataType: "json",
            success: function (datas, textStatus, jqXHR) {
           	 if (datas != null && datas.length > 0) {
        			var clothing = "<ul>";
        			for (var i = 0; i < datas.length; i++) {
        				clothing += "<li><a id=" + datas[i].ID + " onclick='$.csStyle.loadStyleMenu(" + datas[i].ID + ")'>" + datas[i].name + "</a></li>";
        			}
        			clothing += "</ul>";
        			$('#menu').html(clothing);
        		}
            },
            error: function (xhr) {
                d = xhr.responseText;
            }
        });
	},
	//LEFT菜单栏
	loadStyleMenu : function(clothingID){
		var arr = new Array("1","2","3","2000","3000","4000","6000");
		for(var i=0;i<arr.length;i++){
			$("#"+arr[i]).css("color", "");
		}
		$("#"+clothingID).css("color", "#68d3ed");
		var newStyle="<ul>";
		var url = $.csCore.buildServicePath('/service/styleui/getstylemenus');
		var param = $.csControl.appendKeyValue("", "clothingID", clothingID);
		 $.ajax({
             url: url,
             data: { formData: param },
             type: "post",
             dataType: "json",
             success: function (datas, textStatus, jqXHR) {
         		if (!$.csValidator.isNull(datas)) {
         			var num = 9;
         			if(datas.length <= 9){
                		num = datas.length;
                	}
         			if(clothingID>2){
         				for (var i = 0; i < num; i++) {
             				var n = i+1;
             				newStyle += "<li><a onclick=$.csStyle.showStyle('"+clothingID+"','" + datas[i].code + "','" + datas[i].defaultFabric + "')>"+ datas[i].code +"_"+datas[i].defaultFabric+"</a> ("+ n +")</li>";
             			}
         			}else{
         				for (var i = 0; i < num; i++) {
             				var n = i+1;
             				newStyle += "<li><a onclick=$.csStyle.showStyle('"+clothingID+"','" + datas[i].ID + "','')>"+ datas[i].code +"</a> ("+ n +")</li>";
             			}
         			}
         			newStyle+="</ul>";
         		}
         		$('#newStyle').html(newStyle);
             },
             error: function (xhr) {
                 d = xhr.responseText;
             }
         });
		var hotStyle="<ul>";
		hotStyle+="<li><a>MXF0001</a> (1)</li><li><a>MXF0001</a> (2)</li><li><a>MXF0001</a> (3)</li><li><a>MXF0001</a> (4)</li><li><a>MXF0001</a> (5)</li><li><a>MXF0001</a> (6)</li><li><a>MXF0001</a> (7)</li><li><a>MXF0001</a> (8)</li><li><a>MXF0001</a> (9)</li>";
		hotStyle+="</ul>";
		$('#hotStyle').html(hotStyle);
		
		$.csStyle.loadStyle(clothingID);
	},
	//款式风格图片
	loadStyle : function(clothingID){
		var cloID = clothingID;
		if(clothingID ==1 || clothingID == 2){
			cloID =3;
		}
		var param = $.csControl.appendKeyValue('', 'clothingID', cloID);
		var datas = $.csCore.invoke($.csCore.buildServicePath('/service/assemble/getStyleByClothingId'),param);
		var styleImgs ="<table><tr align='center'>";
		for(var i=0; i<datas.length; i++){
			styleImgs +="<td id='"+ datas[i].ID +"' style='border: 1px solid #616161;width:155px;height:339px;background:url(img/"+clothingID+"/"+ datas[i].ID +".jpg) no-repeat;cursor:pointer;' onmouseover=$.csStyle.changeInStyleImg('"+clothingID+"','"+ datas[i].ID +"') onmouseout=$.csStyle.changeOutStyleImg('"+clothingID+"','"+ datas[i].ID +"') onclick=$.csStyle.loadStyleImg('"+clothingID+"','"+ datas[i].ID +"')><h3 style='padding-top:290px;'>"+datas[i].NAME+"</h3></td>";
		}
		styleImgs +="</tr></table>";
		$("#text_body").html(styleImgs);
	},
	//换款式风格背景图
	changeInStyleImg : function(clothingID,id){
		$("#"+id).css("background-image","url(img/"+clothingID+"/"+id+"_1.jpg)");
	},
	//还原款式风格背景图
	changeOutStyleImg : function(clothingID,id){
		$("#"+id).css("background-image","url(img/"+clothingID+"/"+id+".jpg)");
	},
	//款式图
	loadStyleImg : function(clothingID,styleID){
		var param = $.csControl.appendKeyValue('', 'clothingID', clothingID);
		param = $.csControl.appendKeyValue(param, 'styleID', styleID);
		var datas = $.csCore.invoke($.csCore.buildServicePath('/service/styleui/getstylebystyleid'),param);
		
		//搜索栏
		var searhHtm = "<div style='width:1001px;height:50px;text-align:left;'><div id='searchform' class='searchbar'>";
		//款式号
		searhHtm += "<label>"+$.csCore.getValue("Dict_1374")+"</label><select id='styleCode'><option value=''></option>";
		var arr = new Array();
		for(var i=0; i<datas.length; i++){
			arr[i]=datas[i].code;
		}
		arr = jQuery.unique(arr);
		for(var i=0; i<arr.length; i++){
			searhHtm += "<option value='"+ arr[i]+"' title='"+ arr[i]+"'>"+ arr[i]+"</option>";
		}
		searhHtm += "</select>";
		
		//工艺
		var htms = $.csCore.invoke($.csCore.buildServicePath('/service/styleui/uisearchbar'),$.csControl.appendKeyValue('', 'clothingID', clothingID));
		searhHtm += htms;
		searhHtm += "<input type='button' id='search' value='搜索' onclick=$.csStyle.seacrhStyle('"+clothingID+"','"+styleID+"')></div></div>";
		
		if(clothingID>2){//单件
			var style_img="width:168px;height:220px;";
			if(clothingID=="2000"){
				style_img="width:88px;height:220px;";
			}else if(clothingID=="4000"){
				style_img="width:118px;height:220px;";
			}else if(clothingID=="3000"){
				style_img="width:200px;height:220px;";
			}
			var styleImgs ="<div id='styleIMGs'><div id='styleImg' class='scrollCss' style='width: 979px; height: 495px;cursor:pointer;'><table><tr align='center'>";
			for(var i=0; i<datas.length; i++){
				var url = "images/"+clothingID+"/thumbnails/"+datas[i].code+"_"+datas[i].defaultFabric+"_SM_1_M.png";//外
				styleImgs += "<td valign = 'bottom' style='text-align: center;width:220px;height:242px' onclick=$.csStyle.showStyle('"+clothingID+"','"+ datas[i].code +"','"+ datas[i].defaultFabric +"')><img style='"+style_img+"'src="+url+"></img><br/>"+ datas[i].code +"_"+ datas[i].defaultFabric +"</td>";
				var n =i+1;
				if(clothingID==3000){
					if(n%4 == 0){
						styleImgs += "</tr><tr>";
					}
				}else if(clothingID==2000){
					if(n%6 == 0){
						styleImgs += "</tr><tr>";
					}
				}else{
					if(n%5 == 0){
						styleImgs += "</tr><tr>";
					}
				}
			}
			styleImgs +="</tr></table></div></div>";
			$("#text_body").html(searhHtm+styleImgs);
			
		}else{//套装
			var styleImgs = "<div id='styleImg'><div class='hl_main5_content'><div class='hl_scrool_leftbtn'></div><div class='hl_scrool_rightbtn'></div><div class='hl_main5_content1'><ul>";
			for(var i=0; i<datas.length; i++){
				styleImgs += "<li><a onclick=$.csStyle.showStyle('"+clothingID+"','"+datas[i].ID+"','') title='"+datas[i].code+"'><img src='images/"+clothingID+"/show/"+datas[i].code+"_LC.jpg' /></a></li>";
			}
			styleImgs += "</ul></div></div></div>";
			$("#text_body").html(searhHtm+styleImgs);
			$.csStyle.DY_scroll('.hl_main5_content','.hl_scrool_leftbtn','.hl_scrool_rightbtn','.hl_main5_content1',2,true);
		}
	},
	seacrhStyle : function(clothingID,styleID){//搜索内容
		var param = $.csControl.getFormData("searchform");
		param = $.csControl.appendKeyValue(param, 'clothingID', clothingID);
		param = $.csControl.appendKeyValue(param, 'styleID', styleID);
		var datas = $.csCore.invoke($.csCore.buildServicePath('/service/styleui/getstylebystyleid'),param);
		if(clothingID>2){
			var style_img="width:168px;height:220px;";
			if(clothingID =="2000"){
				style_img="width:88px;height:220px;";
			}else if(clothingID =="4000"){
				style_img="width:118px;height:220px;";
			}else if(clothingID =="3000"){
				style_img="width:200px;height:220px;";
			}
			var styleImgs ="<table><tr align='center'>";
			for(var i=0; i<datas.length; i++){
				var url = "images/"+clothingID+"/thumbnails/"+datas[i].code+"_"+datas[i].defaultFabric+"_SM_1_M.png";//外
				styleImgs += "<td valign = 'bottom' style='text-align: center;width:220px;height:242px' onclick=$.csStyle.showStyle('"+clothingID+"','"+ datas[i].code +"','"+ datas[i].defaultFabric +"')><img style='"+style_img+"'src='"+url+"'/><br/>"+ datas[i].code+"_"+ datas[i].defaultFabric +"</td>";
				var n =i+1;
				if(clothingID==3000){
					if(n%4 == 0){
						styleImgs += "</tr><tr>";
					}
				}else if(clothingID==2000){
					if(n%6 == 0){
						styleImgs += "</tr><tr>";
					}
				}else{
					if(n%5 == 0){
						styleImgs += "</tr><tr>";
					}
				}
			}
			styleImgs +="</tr></table>";
			$("#styleImg").html(styleImgs);
		}else{
			var styleImgs = "<div class='hl_main5_content'><div class='hl_scrool_leftbtn'></div><div class='hl_scrool_rightbtn'></div><div class='hl_main5_content1'><ul>";
			for(var i=0; i<datas.length; i++){
				styleImgs += "<li><a href='' onclick=$.csStyle.showStyle('"+clothingID+"','"+datas[i].ID+"','') title='"+datas[i].code+"'><img src='images/"+clothingID+"/show/"+datas[i].code+"_LC.jpg' /></a></li>";
			}
			styleImgs += "</ul></div></div>";
			$("#styleImg").html(styleImgs);
			$.csStyle.DY_scroll('.hl_main5_content','.hl_scrool_leftbtn','.hl_scrool_rightbtn','.hl_main5_content1',2,true);
		}
		
	},
	showStyle : function(clothingID,id,fabric){
		var datas = "";
		if(clothingID>2){
//			datas = $.csCore.invoke($.csCore.buildServicePath('/service/assemble/getAssembleByID?view=view'),param);
			var param = $.csControl.appendKeyValue('', 'code', id);
			param = $.csControl.appendKeyValue(param, 'fabric', fabric);
			datas = $.csCore.invoke($.csCore.buildServicePath('/service/styleui/getstylebycode'),param);
			var domProcess = "";
			if(!$.csValidator.isNull(datas.process)){
				var pro = datas.process.split(",");
				$.each(pro,function(i,detail){
					domProcess += "<span><label>"+pro[i]+"</label></span><br />";
				});
			}
			var domSpecialProcess = "";
			if(!$.csValidator.isNull(datas.specialProcess)){
				var pro = datas.specialProcess.split(",");
				$.each(pro,function(i,detail){
					domSpecialProcess += "<span><label>"+pro[i]+"</label></span><br />";
				});
			}
			var titleCn = datas.titleCn;
			if(datas.titleCn == null){
				titleCn = "";
			}
			var titleEn = datas.titleEn;
			if(datas.titleEn == null){
				titleEn = "";
			}
			var brands = datas.brands;
			if(datas.brands == null){
				brands = "";
			}
			var url = "images/"+clothingID+"/show/"+datas.code+"_"+datas.defaultFabric+"_SM_1.png";//里
			var style_img="height:320px;width:248px;";
			if(clothingID =="2000"){
				style_img="padding-left:30px;height:320px;width:128px;";
			}else if(clothingID =="4000"){
				style_img="padding-left:30px;height:320px;width:172px;";
			}else if(clothingID =="3000"){
				style_img="padding-left:30px;height:320px;width:290px;";
			}
			var style = "<div class='scroll' style='height:400px;'>"+
						"<div style='text-align: center;font-size: 14px;font-weight: bold;'>款式档案</div>"+
						"<div style='float:left;padding-top:15px;width:250px;'><img style='"+style_img+"' src="+url+"></img></div>"+
						"<div class='contents' style='float:left;padding-top:15px;padding-left:100px;'>"+
						"<table style='font-size: 12px;font-weight: bold;'>"+
						"<tr><td class='label'>组合代码</td><td class='value'>"+datas.code+"</td></tr>"+
						"<tr><td class='label'>服装分类</td><td class='value'>"+datas.clothName+"</td></tr>"+
						"<tr><td class='label'>款式风格</td><td class='value'>"+datas.styleName+"</td></tr>"+
						"<tr><td class='label'>类似品牌</td><td class='value'>"+brands+"</td></tr>"+
						"<tr><td class='label'>默认面料</td><td class='value'>"+datas.defaultFabric+"</td></tr>"+
						"<tr><td class='label'>中文标题</td><td class='value'>"+titleCn+"</td></tr>"+
						"<tr><td class='label'>英文标题</td><td class='value'>"+titleEn+"</td></tr>"+
						"<tr><td class='label'>款式工艺</td><td class='value'>"+domProcess+"</td></tr>"+
						"<tr><td class='label'>特殊工艺</td><td class='value'>"+domSpecialProcess+"</td></tr>"+
						"</table><div style='padding-top:20px;padding-left:500px;'><input type='button' value='转为订单' onclick=$.csStyle.intoOrden('"+datas.clothingID+"','"+datas.code+"','"+datas.defaultFabric+"')></div></div></div>";
			
			$("#text_body").html(style);
		}else{
			var param = $.csControl.appendKeyValue('', 'id', id);
			datas = $.csCore.invoke($.csCore.buildServicePath('/service/kitstyle/getkitstylebyid'),param);
			var category_style = new Array();
			category_style = datas.categoryID.split(",");
			var titleCn = datas.title_Cn;
			if(datas.title_Cn == null){
				titleCn = "";
			}
			var titleEn = datas.title_En;
			if(datas.title_En == null){
				titleEn = "";
			}
			var styleH ="<td class='label'>上衣组合代码</td><td class='value' style='cursor:pointer;' onclick=$.csStyle.showStyleInfo('3','"+category_style[0]+"','"+datas.defaultFabric+"') >"+category_style[0]+"</td></tr><tr><td class='label'>西裤组合代码</td><td class='value' style='cursor:pointer;' onclick=$.csStyle.showStyleInfo('2000','"+category_style[1]+"','"+datas.defaultFabric+"')>"+category_style[1]+"</td>";
			var styleH3="";
			if(category_style.length == 3){
				styleH3 ="<td class='label'>马夹组合代码</td><td class='value' style='cursor:pointer;' onclick=$.csStyle.showStyleInfo('4000','"+category_style[2]+"','"+datas.defaultFabric+"')>"+category_style[2]+"</td><td></td><td></td>";
			}
			var url = "images/"+clothingID+"/show/"+datas.code+"_LC.jpg";
			var style = "<div style='height:400px;'>"+
						"<div style='text-align: center;font-size: 14px;font-weight: bold;'>款式档案</div>"+
						"<div style='float:left;padding-top:15px;'><img style='height:320px;width:250px;' src="+url+"></img></div>"+
						"<div class='contents' style='float:left;padding-top:15px;padding-left:30px;'>"+
						"<table style='padding-left:65px;font-size: 12px;font-weight: bold;'>"+
						"<tr><td class='label'>组合代码</td><td class='value'>"+datas.code+"</td></tr>"+
						"<tr><td class='label'>服装分类</td><td class='value'>"+$.csCore.getValue("Dict_"+datas.clothingID)+"</td></tr>"+
						"<tr><td class='label'>默认面料</td><td class='value'>"+datas.defaultFabric+"</td></tr>"+
						"<tr id='category_style'>"+styleH+"</tr>"+
						"<tr id='category_style3'>"+styleH3+"</tr>"+
						"<tr><td class='label'>中文标题</td><td class='value'>"+titleCn+"</td></tr>"+
						"<tr><td class='label'>英文标题</td><td class='value'>"+titleEn+"</td></tr>"+
						"</table></div><div style='padding-top:320px;padding-left:800px;'><input type='button' value='转为订单' onclick=$.csStyle.intoOrden('"+datas.clothingID+"','"+datas.ID+"','"+datas.defaultFabric+"')></div></div>";
						
			$("#text_body").html(style);
		}
	},
	showStyleInfo : function(clothingID,code,fabric){
		var param = $.csControl.appendKeyValue('', 'code', code);
		param = $.csControl.appendKeyValue(param, 'fabric', fabric);
		datas = $.csCore.invoke($.csCore.buildServicePath('/service/styleui/getstylebycode'),param);
		var domProcess = "";
		if(!$.csValidator.isNull(datas.process)){
			var pro = datas.process.split(",");
			$.each(pro,function(i,detail){
				domProcess += "<span><label>"+pro[i]+"</label></span><br />";
			});
		}
		var domSpecialProcess = "";
		if(!$.csValidator.isNull(datas.specialProcess)){
			var pro = datas.specialProcess.split(",");
			$.each(pro,function(i,detail){
				domSpecialProcess += "<span><label>"+pro[i]+"</label></span><br />";
			});
		}
		
		var titleCn = datas.titleCn;
		if(datas.titleCn == null){
			titleCn = "";
		}
		var titleEn = datas.titleEn;
		if(datas.titleEn == null){
			titleEn = "";
		}
		var brands = datas.brands;
		if(datas.brands == null){
			brands = "";
		}
		var url = "images/"+clothingID+"/show/"+datas.code+"_"+datas.defaultFabric+"_SM_1.png";//里
		var style_img="height:320px;width:250px;";
		if(clothingID =="2000"){
			style_img="padding-left:30px;height:320px;width:150px;";
		}else if(clothingID =="4000"){
			style_img="padding-left:30px;height:320px;width:200px;";
		}
		var style = "<div class='scroll' style='width:900px;height:400px;background-color:#616161;'>"+
					"<div style='text-align: center;font-size: 14px;font-weight: bold;'>款式档案</div>"+
					"<div style='float:left;padding-top:15px;'><img style='"+style_img+"' src="+url+"></img></div>"+
					"<div class='contents' style='float:left;padding-top:15px;padding-left:100px;'>"+
					"<table style='font-size: 12px;font-weight: bold;'>"+
					"<tr><td class='label'>组合代码</td><td class='value'>"+datas.code+"</td></tr>"+
					"<tr><td class='label'>服装分类</td><td class='value'>"+datas.clothName+"</td></tr>"+
					"<tr><td class='label'>款式风格</td><td class='value'>"+datas.styleName+"</td></tr>"+
					"<tr><td class='label'>类似品牌</td><td class='value'>"+brands+"</td></tr>"+
					"<tr><td class='label'>默认面料</td><td class='value'>"+datas.defaultFabric+"</td></tr>"+
					"<tr><td class='label'>中文标题</td><td class='value'>"+titleCn+"</td></tr>"+
					"<tr><td class='label'>英文标题</td><td class='value'>"+titleEn+"</td></tr>"+
					"<tr><td class='label'>款式工艺</td><td class='value'>"+domProcess+"</td></tr>"+
					"<tr><td class='label'>特殊工艺</td><td class='value'>"+domSpecialProcess+"</td></tr>"+
					"</table></div></div>";
		
		$.csCore.alert(style);
	},
	intoOrden : function(clothingid,id,fabricCode){
		$.csCore.invoke($.csCore.buildServicePath('/service/orden/cleartempdesigns'));
		$.csCore.invoke($.csCore.buildServicePath('/service/orden/settempclothingid'), $.csControl.appendKeyValue("", "clothingid",clothingid));
		$.csStyle.fabric(fabricCode);
		var param = $.csControl.appendKeyValue('', 'clothingID', clothingid);
		param = $.csControl.appendKeyValue(param, 'id', id);
		param = $.csControl.appendKeyValue(param, 'fabric', fabricCode);
		datas = $.csCore.invoke($.csCore.buildServicePath('/service/styleui/intoorden'),param);
		
		var url = window.location.href;
		url = window.location.href.substring(0, url.length-18)+"common/orden.jsp";
		window.location.href=url;
	},
	fabric : function(code){//面料
    	var url = $.csCore.buildServicePath('/service/orden/settempfabriccode');
    	var param = $.csControl.appendKeyValue("", "fabriccode", code);
		$.csCore.invoke(url, param);
	},
	DY_scroll : function(wraper,prev,next,img,speed,or){  //套装滚动
		var flag = "left";
		var wraper = $(wraper); 
		var prev = $(prev); 
		var next = $(next); 
		var img = $(img).find('ul'); 
		var w = img.find('li').outerWidth(true); 
		var s = speed; 
		next.click(function(){ 
			img.animate({'margin-left':-w}/*,1500,'easeOutBounce'*/,function(){ 
				img.find('li').eq(0).appendTo(img); 
				img.css({'margin-left':0}); 
			}); 
			flag = "left";
		}); 
		prev.click(function(){ 
			img.find('li:last').prependTo(img); 
			img.css({'margin-left':-w}); 
			img.animate({'margin-left':0}/*,1500,'easeOutBounce'*/); 
			flag = "right";
		}); 
		if (or == true){ 
			ad = setInterval(function() { flag == "left" ? next.click() : prev.click()},s*1000); 
			wraper.hover(function(){clearInterval(ad);},function(){ad = setInterval(function() {flag == "left" ? next.click() : prev.click()},s*1000);});
		} 
	} ,
	init: function() {
		$.csStyle.loadClothing();
		$.csStyle.loadStyleMenu(1);
		$.csStyle.loadStyle(1);
	}
};
$(function() {
	$.csStyle.init();
	$.csStyle.bindLabel();
	$.csStyle.bindEvent();
});