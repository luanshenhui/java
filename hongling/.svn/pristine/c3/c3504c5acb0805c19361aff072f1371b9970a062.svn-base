$(document).ready(function (){
	jQuery.csSelect.init();
});
jQuery.csSelect={
	bindLabel:function(){
		$.csCore.getValue("Label_Professional",null,"#professional_edition");
		$.csCore.getValue("Button_MyOrder",null,"#myorden");
		$.csCore.getValue("Button_FabricSearch",null,"#myfabric");
		$.csCore.getValue("Dict_10309",null,"#blDelivery");
		$.csCore.getValue("Dict_10305",null,"#blCash");
		$.csCore.getValue("Dict_10308",null,"#mymessage");
		$.csCore.getValue("Button_User",null,"#myuser");
		$.csCore.getValue("Button_MyInformation",null,"#myinformation");
		$.csCore.getValue("Button_Coder",null,"#coder");
		$.csCore.getValue("Button_Exit",null,"#signOut");
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
	},
	//深入设计
	save : function (){
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
    },
    //点击图片 选择毛衬类型
    changeMC : function(id,vals){
    	$.csControl.initSingleCheck(id);
    	$("#mc_val").val(vals);
    	$.csSelect.setComponentID("mc_val",vals);
    },
  //点击面料
    changeFabric : function(id,now,all){
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
    	var url = $.csCore.buildServicePath('/service/orden/settempfabriccode');
    	var param = $.csControl.appendKeyValue("", "fabriccode", code);
		$.csCore.invoke(url, param);
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
		
		$.csControl.initSingleCheck("97");
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
    	$(".isShow").show();
		var image ="";
		var kz_img ="<div style='margin-top: 15px; width: 650px; height:50px;'><div id='kz0' class='gy' onmouseout=$.csSelect.kzOut('0') onmouseover=$.csSelect.kzOver('0') onclick=$.csSelect.changekz('0','5','36')><div class='jbpz_text'>单排一粒扣</div><i id='kzimg0' class='gyimg'></i></div>"+
				"<div id='kz1' class='gy' style='border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;'onmouseout=$.csSelect.kzOut('1') onmouseover=$.csSelect.kzOver('1') onclick=$.csSelect.changekz('1','5','37')><div class='jbpz_text'>单排二粒扣</div><i id='kzimg1' class='gyimg' style='display: block;'></i></div>"+
				"<div id='kz3' class='gy' onmouseout=$.csSelect.kzOut('3') onmouseover=$.csSelect.kzOver('3') onclick=$.csSelect.changekz('3','5','38')><div class='jbpz_text'>单排三粒扣</div><i id='kzimg3' class='gyimg'></i></div>"+
				"<div id='kz2' class='gy' title='单排三粒扣、驳头翻到第二粒扣' onmouseout=$.csSelect.kzOut('2') onmouseover=$.csSelect.kzOver('2') onclick=$.csSelect.changekz('2','5','875')><div class='jbpz_text'>单排三粒扣1</div><i id='kzimg2' class='gyimg'></i></div>"+
				"<div id='kz4' class='gy' title='单排三粒扣、驳头翻到第一粒扣与第二粒扣中间' onmouseout=$.csSelect.kzOut('4') onmouseover=$.csSelect.kzOver('4') onclick=$.csSelect.changekz('4','5','876')><div class='jbpz_text'>单排三粒扣2</div><i id='kzimg4' class='gyimg'></i></div></div>";
		if(now==0){
			image = "51_37";
			$("#qmk").html(kz_img);
		}else if(now==1){
			image = "52_37";
			kz_img = "<div style='margin-top: 25px;width: 650px; height:50px;'>"+
				  "<div id='kz0' class='gy' onmouseout=$.csSelect.kzOut('0') onmouseover=$.csSelect.kzOver('0') onclick=$.csSelect.changekz('0','10','36')><div class='jbpz_text'>单排一粒扣</div><i id='kzimg0' class='gyimg'></i></div>"+
				  "<div id='kz1' class='gy' style='border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;'onmouseout=$.csSelect.kzOut('1') onmouseover=$.csSelect.kzOver('1') onclick=$.csSelect.changekz('1','10','37')><div class='jbpz_text'>单排二粒扣</div><i id='kzimg1' class='gyimg' style='display: block;'></i></div>"+
				  "<div id='kz3' class='gy' onmouseout=$.csSelect.kzOut('3') onmouseover=$.csSelect.kzOver('3') onclick=$.csSelect.changekz('3','10','38')><div class='jbpz_text'>单排三粒扣</div><i id='kzimg3' class='gyimg'></i></div>"+
				  "<div id='kz2' class='gy' title='单排三粒扣、驳头翻到第二粒扣' onmouseout=$.csSelect.kzOut('2') onmouseover=$.csSelect.kzOver('2') onclick=$.csSelect.changekz('2','10','875')><div class='jbpz_text'>单排三粒扣1</div><i id='kzimg2' class='gyimg'></i></div>"+
				  "<div id='kz4' class='gy' title='单排三粒扣、驳头翻到第一粒扣与第二粒扣中间' onmouseout=$.csSelect.kzOut('4') onmouseover=$.csSelect.kzOver('4') onclick=$.csSelect.changekz('4','10','876')><div class='jbpz_text'>单排三粒扣2</div><i id='kzimg4' class='gyimg'></i></div>"+
				  "</div> <div style='width: 650px; height:25px;margin-bottom: 25px;'>"+
				  "<div id='kz5' class='gy' onmouseout=$.csSelect.kzOut('5') onmouseover=$.csSelect.kzOver('5') onclick=$.csSelect.changekz('5','10','44')><div class='jbpz_text'>双排四扣一</div><i id='kzimg5' class='gyimg'></i></div>"+
				  "<div id='kz6' class='gy' onmouseout=$.csSelect.kzOut('6') onmouseover=$.csSelect.kzOver('6') onclick=$.csSelect.changekz('6','10','45')><div class='jbpz_text'>双排六扣一</div><i id='kzimg6' class='gyimg'></i></div>"+
				  "<div id='kz7' class='gy' onmouseout=$.csSelect.kzOut('7') onmouseover=$.csSelect.kzOver('7') onclick=$.csSelect.changekz('7','10','41')><div class='jbpz_text'>双排四扣二</div><i id='kzimg7' class='gyimg'></i></div>"+
				  "<div id='kz8' class='gy' onmouseout=$.csSelect.kzOut('8') onmouseover=$.csSelect.kzOver('8') onclick=$.csSelect.changekz('8','10','42')><div class='jbpz_text'>双排六扣二</div><i id='kzimg8' class='gyimg'></i></div>"+
				  "<div id='kz9' class='gy' onmouseout=$.csSelect.kzOut('9') onmouseover=$.csSelect.kzOver('9') onclick=$.csSelect.changekz('9','10','46')><div class='jbpz_text'>双排六扣三</div><i id='kzimg9' class='gyimg'></i></div></div>";
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
			kz_img ="<div style='margin-top: 15px; width: 650px; height:50px;'><div id='kz0' class='gy' onmouseout=$.csSelect.kzOut('0') onmouseover=$.csSelect.kzOver('0') onclick=$.csSelect.changekz('0','2','36')><div class='jbpz_text'>单排一粒扣</div><i id='kzimg0' class='gyimg'></i></div>"+
				"<div id='kz1' class='gy' style='border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;'onmouseout=$.csSelect.kzOut('1') onmouseover=$.csSelect.kzOver('1') onclick=$.csSelect.changekz('1','2','37')><div class='jbpz_text'>单排二粒扣</div><i id='kzimg1' class='gyimg' style='display: block;'></i></div></div>";
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
		    	"<div id='qdxs0' class='gy' onmouseout=$.csSelect.qdxsOut('0') onmouseover=$.csSelect.qdxsOver('0')  onclick=$.csSelect.changeQdxs('0','15','2048')><div class='jbpz_text'>2.0斜插口袋</div><i id='qdxsimg0' class='gyimg'></i></div>"+
		    	"<div id='qdxs1' class='gy' onmouseout=$.csSelect.qdxsOut('1') onmouseover=$.csSelect.qdxsOver('1')  onclick=$.csSelect.changeQdxs('1','15','2050')><div class='jbpz_text'>3.2斜插口袋</div><i id='qdxsimg1' class='gyimg'></i></div>"+
		    	"<div id='qdxs2' class='gy' onmouseout=$.csSelect.qdxsOut('2') onmouseover=$.csSelect.qdxsOver('2')  onclick=$.csSelect.changeQdxs('2','15','2051')><div class='jbpz_text'>5.1斜插袋</div><i id='qdxsimg2' class='gyimg'></i></div>"+
		    	"<div id='qdxs3' class='gy' style='border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;'onmouseout=$.csSelect.qdxsOut('3') onmouseover=$.csSelect.qdxsOver('3')  onclick=$.csSelect.changeQdxs('3','15','2049')><div class='jbpz_text'>2.5斜插袋</div><i id='qdxsimg3' class='gyimg' style='display: block;'></i></div>"+
		    	"<div id='qdxs4' class='gy' onmouseout=$.csSelect.qdxsOut('4') onmouseover=$.csSelect.qdxsOver('4')  onclick=$.csSelect.changeQdxs('4','15','2333')><div class='jbpz_text'>2.0斜插袋加条</div><i id='qdxsimg4' class='gyimg'></i></div>"+
		    	"</div>"+
		    	"<div style='width: 650px; height:50px;'>"+
		    	"<div id='qdxs5' class='gy' onmouseout=$.csSelect.qdxsOut('5') onmouseover=$.csSelect.qdxsOver('5')  onclick=$.csSelect.changeQdxs('5','15','2334')><div class='jbpz_text'>3.2斜插袋加条</div><i id='qdxsimg5' class='gyimg'></i></div>"+
		    	"<div id='qdxs6' class='gy' onmouseout=$.csSelect.qdxsOut('6') onmouseover=$.csSelect.qdxsOver('6')  onclick=$.csSelect.changeQdxs('6','15','2335')><div class='jbpz_text'>5.1斜插袋加条</div><i id='qdxsimg6' class='gyimg'></i></div>"+
		    	"<div id='qdxs7' class='gy' onmouseout=$.csSelect.qdxsOut('7') onmouseover=$.csSelect.qdxsOver('7')  onclick=$.csSelect.changeQdxs('7','15','2336')><div class='jbpz_text'>2.5斜插袋加条</div><i id='qdxsimg7' class='gyimg'></i></div>"+
		    	"<div id='qdxs8' class='gy' onmouseout=$.csSelect.qdxsOut('8') onmouseover=$.csSelect.qdxsOver('8')  onclick=$.csSelect.changeQdxs('8','15','2054')><div class='jbpz_text'>前双开线口袋</div><i id='qdxsimg8' class='gyimg'></i></div>"+
		    	"<div id='qdxs9' class='gy' onmouseout=$.csSelect.qdxsOut('9') onmouseover=$.csSelect.qdxsOver('9')  onclick=$.csSelect.changeQdxs('9','15','2053')><div class='jbpz_text'>前单开线口袋</div><i id='qdxsimg9' class='gyimg'></i></div>"+
		    	"</div>"+
		    	"<div style='width: 650px; height:50px;'>"+
		    	"<div id='qdxs10' class='gy' onmouseout=$.csSelect.qdxsOut('10') onmouseover='$.csSelect.qdxsOver('10','3') onclick=$.csSelect.changeQdxs('10','15','2055')><div class='jbpz_text'>前方形牛仔口袋</div><i id='qdxsimg10' class='gyimg'></i></div>"+
		    	"<div id='qdxs11' class='gy' onmouseout=$.csSelect.qdxsOut('11') onmouseover='$.csSelect.qdxsOver('11','3') onclick=$.csSelect.changeQdxs('11','15','2338')><div class='jbpz_text'>前DL牛仔口袋</div><i id='qdxsimg11' class='gyimg'></i></div>"+
		    	"<div id='qdxs12' class='gy' onmouseout=$.csSelect.qdxsOut('12') onmouseover='$.csSelect.qdxsOver('12','3') onclick=$.csSelect.changeQdxs('12','15','2056')><div class='jbpz_text'>前菱形牛仔口袋</div><i id='qdxsimg12' class='gyimg'></i></div>"+
		    	"<div id='qdxs13' class='gy' onmouseout=$.csSelect.qdxsOut('13') onmouseover='$.csSelect.qdxsOver('13','3') onclick=$.csSelect.changeQdxs('13','15','2057')><div class='jbpz_text'>前弧形牛仔口袋</div><i id='qdxsimg13' class='gyimg'></i></div>"+
		    	"<div id='qdxs14' class='gy' onmouseout=$.csSelect.qdxsOut('14') onmouseover='$.csSelect.qdxsOver('14','3') onclick=$.csSelect.changeQdxs('14','15','2058')><div class='jbpz_text'>前圆形牛仔口袋</div><i id='qdxsimg14' class='gyimg'></i></div>"+
		    	"</div>";
    	var qkd2 = "<div style='margin-top: 15px;margin-bottom: 5px;width: 650px; height:50px;'>"+
		    	"<div id='qdxs0' class='gy' onmouseout=$.csSelect.qdxsOut('0') onmouseover=$.csSelect.qdxsOver('0')  onclick=$.csSelect.changeQdxs('0','10','2048')><div class='jbpz_text'>2.0斜插口袋</div><i id='qdxsimg0' class='gyimg'></i></div>"+
		    	"<div id='qdxs1' class='gy' onmouseout=$.csSelect.qdxsOut('1') onmouseover=$.csSelect.qdxsOver('1')  onclick=$.csSelect.changeQdxs('1','10','2050')><div class='jbpz_text'>3.2斜插口袋</div><i id='qdxsimg1' class='gyimg'></i></div>"+
		    	"<div id='qdxs2' class='gy' onmouseout=$.csSelect.qdxsOut('2') onmouseover=$.csSelect.qdxsOver('2')  onclick=$.csSelect.changeQdxs('2','10','2051')><div class='jbpz_text'>5.1斜插袋</div><i id='qdxsimg2' class='gyimg'></i></div>"+
		    	"<div id='qdxs3' class='gy' style='border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;'onmouseout=$.csSelect.qdxsOut('3') onmouseover=$.csSelect.qdxsOver('3')  onclick=$.csSelect.changeQdxs('3','10','2049')><div class='jbpz_text'>2.5斜插袋</div><i id='qdxsimg3' class='gyimg' style='display: block;'></i></div>"+
		    	"<div id='qdxs4' class='gy' onmouseout=$.csSelect.qdxsOut('4') onmouseover=$.csSelect.qdxsOver('4')  onclick=$.csSelect.changeQdxs('4','10','2333')><div class='jbpz_text'>2.0斜插袋加条</div><i id='qdxsimg4' class='gyimg'></i></div>"+
		    	"</div>"+
		    	"<div style='margin-bottom: 5px;width: 650px; height:50px;'>"+
		    	"<div id='qdxs5' class='gy' onmouseout=$.csSelect.qdxsOut('5') onmouseover=$.csSelect.qdxsOver('5')  onclick=$.csSelect.changeQdxs('5','10','2334')><div class='jbpz_text'>3.2斜插袋加条</div><i id='qdxsimg5' class='gyimg'></i></div>"+
		    	"<div id='qdxs6' class='gy' onmouseout=$.csSelect.qdxsOut('6') onmouseover=$.csSelect.qdxsOver('6')  onclick=$.csSelect.changeQdxs('6','10','2335')><div class='jbpz_text'>5.1斜插袋加条</div><i id='qdxsimg6' class='gyimg'></i></div>"+
		    	"<div id='qdxs7' class='gy' onmouseout=$.csSelect.qdxsOut('7') onmouseover=$.csSelect.qdxsOver('7')  onclick=$.csSelect.changeQdxs('7','10','2336')><div class='jbpz_text'>2.5斜插袋加条</div><i id='qdxsimg7' class='gyimg'></i></div>"+
		    	"<div id='qdxs8' class='gy' onmouseout=$.csSelect.qdxsOut('8') onmouseover=$.csSelect.qdxsOver('8')  onclick=$.csSelect.changeQdxs('8','10','2054')><div class='jbpz_text'>前双开线口袋</div><i id='qdxsimg8' class='gyimg'></i></div>"+
		    	"<div id='qdxs9' class='gy' onmouseout=$.csSelect.qdxsOut('9') onmouseover=$.csSelect.qdxsOver('9')  onclick=$.csSelect.changeQdxs('9','10','2053')><div class='jbpz_text'>前单开线口袋</div><i id='qdxsimg9' class='gyimg'></i></div>"+
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
    	$("#cy_lx_val").val(vals);
    	$.csSelect.setComponentID("cy_lx_val",vals);
    	$("#lximg"+now).css('display','block');
    	$("#lx"+now).css({border:"solid 2px","border-color":"#DF0001"});
    	$("#lx"+now).addClass("commom_class");
    	for(var i=0;i<=14;i++){
			if(i !=  now){
				$("#lximg"+i).css("display","none");
				$("#lx"+i).css({border:"solid 1px","border-color":"#e2e1e3"});
		    	$("#lx"+i).removeClass("commom_class");
			}
		}
    	
	    var cy_mjxs_img ="<div id='mjxs0' class='gy'  "+
					    "onmouseout=$.csSelect.MjxsOut('0') onmouseover=$.csSelect.MjxsOver('0') onclick=$.csSelect.changeMjxs('0','5','3040')><div class='jbpz_text'>挂边门襟</div> "+
					    "<i id='mjxsimg0' class='gyimg'></i></div> "+
					    "<div id='mjxs1' class='gy'  "+
					    "onmouseout=$.csSelect.MjxsOut('1') onmouseover=$.csSelect.MjxsOver('1') onclick=$.csSelect.changeMjxs('1','5','3041')><div class='jbpz_text'>里三折门襟</div>"+
					    "<i id='mjxsimg1' class='gyimg'></i></div> "+
					    "<div id='mjxs3' class='gy'  "+
					    "onmouseout=$.csSelect.MjxsOut('3') onmouseover=$.csSelect.MjxsOver('3') onclick=$.csSelect.changeMjxs('3','5','3042')><div class='jbpz_text'>暗门襟</div> "+
					    "<i id='mjxsimg3' class='gyimg'></i></div> "+
					    "<div id='mjxs2' class='gy' style='border: 2px solid #DF0001;cursor: pointer;float: left;margin-right: 5px;' "+
					    "onmouseout=$.csSelect.MjxsOut('2') onmouseover=$.csSelect.MjxsOver('2') onclick=$.csSelect.changeMjxs('2','5','3045')><div class='jbpz_text'>左右挂边 </div>"+
					    "<i id='mjxsimg2' class='gyimg' style='display: block;'></i></div> "+
					    "<div id='mjxs4' class='gy'  "+
					    "onmouseout=$.csSelect.MjxsOut('4') onmouseover=$.csSelect.MjxsOver('4') onclick=$.csSelect.changeMjxs('4','5','3043')><div class='jbpz_text'>左右里三折</div> "+
					    "<i id='mjxsimg4' class='gyimg'></i></div>";
		$("#mjxs").html(cy_mjxs_img);
		
		var images = vals +"_3045";
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
	      var cy_lx_val= $("#cy_lx_val").val();
	      var images = cy_lx_val +"_"+vals;
	      $("#jbks_CYimage").html("<img src='images/"+images+".png' alt='image'/>");	
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
    				strSelect ="<select onclick=$.csSelect.setKhzd('kzl',this.value)><option value='0'>请选择</option>";
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
    				strSelect ="<select onclick=$.csSelect.setKhzd('xk_kzl',this.value)><option value='0'>请选择</option>";
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
		if($.cookie("logo") == 20138){//凯妙
			var mrgy= "";
			if(vals == "1"){//套装
				mrgy="2113,2119,2529,2081,2088,2093,2098,2635,2124,2098,2513,2590,433,132,178,1379,565,577,1014,1185;2354,2356,2353,2990,2639,2355,2968,20112,1889,1381,1382,1385,1378,1380,1977,1965,1963,20111,20114;20112:钉凯妙商标,20111:钉凯妙商标,20114:钉凯妙面料标";
			}
			if(vals == "3"){//西服
				 mrgy="433,132,178,1379,565,577,1014,1185;1889,1381,1382,1385,1378,1380,1977,1965,1963,20111;20112:钉凯妙商标,20111:钉凯妙商标";
			}
			if(vals == "2000"){//西裤
				mrgy="2113,2119,2529,2081,2088,2093,2098,2635,2124,2098,2513,2590;2354,2356,2353,2990,2639,2355,2968,20112;20112:钉凯妙商标,20111:钉凯妙商标,20114:钉凯妙面料标";
			}
			$.csSelect.setComponentID("mrgy_val",mrgy);
		}else if($.cookie("logo") == 20139){//红领
			
		}else{//RCMTM
			
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
		if($.cookie("logo") == 20138){//凯妙
			if($("#bt_val").val() != 55 && (clothingID ==1 || clothingID ==3)){//不为青果领
				var mrgy = "79,999;1952,1998";
				$.csSelect.setComponentID("mrgy_val",mrgy);
			}
		}
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
		$.csCore.invoke($.csCore.buildServicePath('/service/orden/cleartempdesigns'));
		$.csCore.invoke($.csCore.buildServicePath('/service/orden/settempclothingid'), $.csControl.appendKeyValue("", "clothingid",id));
		$("#TZ").html("");
		if(id=="1"){
			$.csSelect.getBtk();//上衣驳头宽
			$.csSelect.setMrgy(id);//默认工艺
			$.csSelect.changeTZ_Type("3");//服装分类
			$.csSelect.cancelKxgy(id);//可选工艺默认
			$.csSelect.fabric("1","DBK053A");//设置面料
			var tz = "<label class='hand'><input type='radio' name='type' value='3' checked='checked' onclick=$.csSelect.changeTZ_Type('3') /> 西服 </label>"+
					"<label class='hand'><input type='radio' name='type' value='2000' onclick=$.csSelect.changeTZ_Type('2000') />西裤</label>";
			$("#TZ").html(tz);//服装分类切换
			var submit_vals ="<tr><td>胸袋形式<input id='xdxs_val' type='text'/></td></tr>"+
							"<tr><td>后背开衩形式<input id='hbkcxs_val' type='text'/></td></tr><tr><td>后开衩调整<input id='hbkctz_val' type='text'/></td></tr>"+
							"<tr><td>袖衩形式<input id='xksl_val' type='text'/></td></tr><tr><td>驳头眼形式<input id='btyxs_val' type='text'/></td></tr>"+
							"<tr><td>驳头宽<input id='btk_val' type='text' type='text'/></td></tr><tr><td>下口袋形式<input id='xkdxs_val' type='text'/></td></tr>"+
							"<tr><td>挂面形式<input id='gmxs_val' type='text'/></td></tr><tr><td>里子造型与下口<input id='lzzxyxk_val' type='text'/></td></tr>"+
							"<tr><td>底襟形式<input id='xk_djxs_val' type='text'/></td></tr><tr><td>脚口形式<input id='xk_jkxs_val' type='text'/></td></tr>"+
							"<tr><td>宝剑头形式<input id='xk_bjtxs_val' type='text'/></td></tr><tr><td>表袋形式<input id='xk_bdxs_val' type='text'/></td></tr>"+
							"<tr><td>宝剑头长度<input id='xk_bjtcd_val' type='text'/></td></tr><tr><td>后袋形式<input id='xk_hdxs_val' type='text' type='text'/></td></tr>";
			$("#submit_vals").html(submit_vals);//提交文本框
		}else if(id=="3"){
			$.csSelect.getBtk();
			$.csSelect.setMrgy(id);
			$.csSelect.changeTZ_Type(id);
			$.csSelect.cancelKxgy(id);
			$.csSelect.fabric("3","DBK053A");
			var submit_vals ="<tr><td>胸袋形式<input id='xdxs_val' type='text'/></td></tr>"+
							"<tr><td>后背开衩形式<input id='hbkcxs_val' type='text'/></td></tr><tr><td>后开衩调整<input id='hbkctz_val' type='text'/></td></tr>"+
							"<tr><td>袖衩形式<input id='xksl_val' type='text'/></td></tr><tr><td>驳头眼形式<input id='btyxs_val' type='text'/></td></tr>"+
							"<tr><td>驳头宽<input id='btk_val' type='text' type='text'/></td></tr><tr><td>下口袋形式<input id='xkdxs_val' type='text'/></td></tr>"+
							"<tr><td>挂面形式<input id='gmxs_val' type='text'/></td></tr><tr><td>里子造型与下口<input id='lzzxyxk_val' type='text'/></td></tr>";
			$("#submit_vals").html(submit_vals);
		}else if(id=="2000"){
			$.csSelect.setMrgy(id);
			$.csSelect.changeTZ_Type(id);
			$.csSelect.cancelKxgy(id);
			$.csSelect.fabric("2000","DBK053A");
			var submit_vals ="<tr><td>底襟形式<input id='xk_djxs_val' type='text'/></td></tr><tr><td>脚口形式<input id='xk_jkxs_val' type='text'/></td></tr>"+
							"<tr><td>宝剑头形式<input id='xk_bjtxs_val' type='text'/></td></tr><tr><td>表袋形式<input id='xk_bdxs_val' type='text'/></td></tr>"+
							"<tr><td>宝剑头长度<input id='xk_bjtcd_val' type='text'/></td></tr><tr><td>后袋形式<input id='xk_hdxs_val' type='text' type='text'/></td></tr>";
			$("#submit_vals").html(submit_vals);
		}else if(id=="3000"){
			$.csSelect.changeTZ_Type(id);
			$.csSelect.fabric(id,"SAF191A");
			var submit_vals ="<tr><td>过肩形式<input id='cy_gjxs_val' type='text'/></td></tr>"+
							"<tr><td>下摆形式<input id='cy_xbxs_val' type='text'/></td></tr><tr><td>门襟宽度<input id='cy_mjkd_val' type='text'/></td></tr>"+
							"<tr><td>前片形式<input id='cy_qpxs_val' type='text'/></td></tr><tr><td>后背形式<input id='cy_hbxs_val' type='text'/></td></tr>"+
							"<tr><td>袖头<input id='cy_xt_val' type='text' type='text'/></td></tr><tr><td>袖头高度<input id='cy_xtgd_val' type='text'/></td></tr>"+
							"<tr><td>口袋<input id='cy_kd_val' type='text'/></td></tr><tr><td>领形<input id='cy_lx_val' type='text'/></td></tr>"+
							"<tr><td>领子明线0.15<input id='cy_lzmx_val' type='text'/></td></tr><tr><td>门襟明线0.15<input id='cy_mjmx_val' type='text'/></td></tr>"+
							"<tr><td>领中线斜拐<input id='cy_lzxxg_val' type='text' type='text'/></td></tr><tr><td>普通袖口单折<input id='cy_xkdz_val' type='text'/></td></tr>"+
							"<tr><td>门襟最后一眼锁横眼<input id='cy_mjhy_val' type='text'/></td></tr><tr><td>领台第一个眼锁45度斜眼<input id='cy_ltxy_val' type='text'/></td></tr>";
			$("#submit_vals").html(submit_vals);
		}
	},
	changeTZ_Type : function(id){//切换西服、西裤、衬衣
		 if(id=="3"){
			$("#jbpz3").show();
			$("#jbpz2000").hide();
			$("#jbpz3000").hide();
			$("#mrgy3").show();
			$("#mrgy2000").hide();
			$("#mrgy3000").hide();
			$("#jbgy_img").html("<img src='images/51_37.png' alt='image'/>");
			$("#kx_gyxz3").show();
			$("#kx_gyxz2000").hide();
			$("#kx_gyxz3000").hide();
			$("#mrgy_1").show();
			$("#mrgy_3000").hide();
			if($("#type").val() == 1){
				$("#submit_button").css("display","none");
			}else{
				$("#submit_button").css("display","block");
			}
		}else if(id=="2000"){
			$("#jbpz3").hide();
			$("#jbpz2000").show();
			$("#jbpz3000").hide();
			$("#mrgy3").hide();
			$("#mrgy2000").show();
			$("#mrgy3000").hide();
			$("#jbgy_img").html("<img src='images/2034_2049.png' alt='image'/>");
			$("#kx_gyxz3").hide();
			$("#kx_gyxz2000").show();
			$("#kx_gyxz3000").hide();
			$("#mrgy_1").show();
			$("#mrgy_3000").hide();
			$("#submit_button").css("display","block");
		}
		else if(id=="3000"){
			$("#jbpz3").hide();
			$("#jbpz2000").hide();
			$("#jbpz3000").show();
			$("#mrgy3").hide();
			$("#mrgy2000").hide();
			$("#mrgy3000").show();
			$("#jbgy_img").html("<img src='images/3063_3045.png' alt='image'/>");
			$("#kx_gyxz3").hide();
			$("#kx_gyxz2000").hide();
			$("#kx_gyxz3000").show();
			$("#mrgy_1").hide();
			$("#mrgy_3000").show();
			$("#submit_button").css("display","block");
		}
	},
	cancelKxgy : function(type){
		if($.cookie("logo") != 20138){//不为凯妙
			if(type == 1 || type ==3){//套装、上衣
				$.csSelect.cancelChecked('kzl');
				$.csSelect.cancelChecked('xcxs');
				$.csSelect.setChecked('179');
				$.csSelect.cancelChecked('xdxs');
				$.csSelect.setChecked('130');
				$.csSelect.cancelChecked('btyxs');
			}
			if(type == 1 || type ==2000){//套装、西裤
				$.csSelect.cancelChecked('xk_kzl');
				$.csSelect.cancelChecked('xk_bjtxs');
				$.csSelect.setChecked('2094_2098');
			}
		}
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
		var str ="<table id='mrgy3'><tr><td align='left' class='mr_GY'>平驳头</td><td align='left' class='mr_GY'>驳头宽8.3cm</td></tr><tr><td align='left'>单排二粒扣</td><td align='left'>四粒平扣</td></tr><tr><td align='left'>全里子</td><td align='left'>直挂面</td></tr><tr><td align='left'>后背无开衩</td><td align='left'>正常直驳头眼</td></tr><tr><td align='left'>正常圆下摆下口</td><td align='left'>外珠边线-顺面料色</td></tr><tr><td align='left'>正常袖衩正常锁眼</td><td align='left'> ‘ = ’钉扣形式</td></tr><tr><td align='left'>锁眼线顺面料色</td><td align='left'>顺面料色里布</td></tr><tr><td align='left'>白色条纹袖里布</td><td align='left'>小三角汗托</td></tr><tr><td align='left'>左下名片袋</td><td align='left'>内珠边顺面料色</td></tr><tr><td align='left'>里袋-D型套结封口</td><td></td></tr></table>"+
				"<table id='mrgy2000' style='display: none;'><tr><td align='left' class='mr_GY'>单褶褶向侧缝</td><td align='left' class='mr_GY'>双开线锁眼钉扣后口袋</td></tr><tr><td align='left'>褶深2.5cm</td><td align='left'>尖宝剑头、锁钉单挂钩</td></tr><tr><td align='left'>群褶腰里</td><td align='left'>宝剑头长5.5cm</td></tr><tr><td align='left'>2.5斜插袋</td><td align='left'>门襟尼龙拉链</td></tr><tr><td align='left'>正常串带</td><td align='left'>前半裤里、袋布在外</td></tr><tr><td align='left'>鱼嘴底襟</td><td align='left'>锁眼线顺面料色</td></tr><tr><td align='left'> ‘ = ’钉扣形式</td><td align='left'>裤脚口内折边5.0cm</td></tr></table>"+
				"<table id='mrgy3000' style='display: none;'><tr><td align='left' class='mr_GY'>大尖领  编号34号领</td><td align='left' class='mr_GY'>活领签</td></tr><tr><td align='left'>圆领台一粒扣</td><td align='left'>后背双折</td></tr><tr><td align='left'>圆袖头一眼一扣</td><td align='left'>普通园摆</td></tr><tr><td align='left'>门襟宽3.5cm</td><td align='left'>挂边门襟</td></tr><tr><td align='left'>正常过肩</td><td align='left'>无口袋</td></tr></table>";
		if(logoId == 20138){
			 str ="<table id='mrgy3'><tr><td align='left' class='cameoXF'>船型胸袋</td><td align='left' class='cameoXF'>外口袋-D型套结封口</td></tr>"+
	        	"<tr class='isShow'><td align='left' class='cameoXF'>手工缝串口</td><td align='left' class='cameoXF'>驳头圆头真开扣眼</td></tr>"+
	        	"<tr class='isShow'><td align='left' class='cameoXF'>驳头手工锁眼</td><td align='left' class='cameoXF'>驳头眼2.5CM</td></tr>"+
	        	"<tr><td align='left' class='cameoXF'>里袋开线用面料</td><td align='left' class='cameoXF'>里袋套结顺内珠边(或沿条)色</td></tr>"+
	        	"<tr><td align='left' class='cameoXF'>真开袖衩真开眼</td><td align='left' style='width:180px;height:20px;'>U形面料汗托、汗托外包沿条</td></tr>"+
	        	"<tr><td align='left' class='cameoXF'>加垫扣钉扣</td><td align='left' class='cameoXF'>爪型钉扣形式</td></tr>"+
	        	"<tr><td align='left' class='cameoXF'>牛角扣</td><td align='left' class='cameoXF'>标志领标领脚上</td></tr>"+
	        	"<tr><td align='left' class='cameoXF'>手工钉标牌</td><td align='left' class='cameoXF'>客户名牌左里袋上2cm处</td></tr>"+
	        	"<tr><td colspan='2' align='left' style='height:20px;'>商标左笔袋下5cm处（里口袋下10cm左右居中）--CAMEO</td></tr>"+
	        	"<tr><td colspan='2' align='left' style='height:20px;'>面料标右里袋下10cm处（里口袋下10cm左右居中）-CAMEO</td></tr></table>"+
	            "<table id='mrgy2000' style='display: none;'><tr><td align='left' class='cameoXK'>门襟金属拉链</td><td align='left' class='cameoXK'>串带夹在腰里面</td></tr>"+
	        	"<tr><td align='left' class='cameoXK'>裙褶腰里加防滑皮垫</td><td align='left' class='cameoXK'>口袋、前门珠边</td></tr>"+
	        	"<tr><td align='left' class='cameoXK'>后腰缝I型开口</td><td align='left' class='cameoXK'>圆宝剑头、挂钩钉扣</td></tr>"+
	        	"<tr><td align='left' class='cameoXK'>爪形钉扣形式</td><td align='left' class='cameoXK'>牛角扣</td></tr>"+
	        	"<tr><td align='left' class='cameoXK'>正常串带,裤脚口加防磨带</td><td align='left' class='cameoXK'>手工钉标牌</td></tr>"+
	        	"<tr><td colspan='2' align='left' style='height:20px;'>左前裤腰里中间钉商标- CAMEO</td></tr>"+
	        	"<tr><td colspan='2' align='left' style='height:20px;'>双开线加尖扣袢锁眼钉扣后袋</td></tr>"+
	        	"<tr><td colspan='2' align='left' style='height:20px;'>方袋布里勾外0.5CM珠边、底襟布带尾巴</td></tr>"+
	        	"<tr><td colspan='2' align='left' style='height:20px;'>侧缝、里缝、后裆缝三线包边时一律夹网状沿条 </td></tr></table>"+
	        	"<table id='mrgy3000' style='display: none;'><tr><td align='left' class='mr_GY'>大尖领  编号34号领</td><td align='left' class='mr_GY'>活领签</td></tr><tr><td align='left'>圆领台一粒扣</td><td align='left'>后背双折</td></tr><tr><td align='left'>圆袖头一眼一扣</td><td align='left'>普通园摆</td></tr><tr><td align='left'>门襟宽3.5cm</td><td align='left'>挂边门襟</td></tr><tr><td align='left'>正常过肩</td><td align='left'>无口袋</td></tr></table>";
			 $("#all_jbgy").html(str);
		}else if(logoId == 20139){
			$("#all_jbgy").html(str);
			$("#all_jbgy").css("margin-right", "120px");
		}else{
			$("#all_jbgy").html(str);
			$("#all_jbgy").css("margin-right", "120px");
		}
	},
	init:function(){
		var member = $.csCore.getCurrentMember();
		$.cookie("logo",member.businessUnit);
		if(member.businessUnit == 20139){//RCMTM
			$("#change_logo").html("<img src='images/rcmtm.png'></img>");
		}else if(member.businessUnit == 20138 || member.businessUnit == 20140){//凯妙、瑞璞
			$("#change_logo").html("<img src='images/cameo.png'></img>");
		}else{//红领
			$("#change_logo").html("<img src='images/hongling.png'></img>");
		}
		$(".clothing_type").html("<select id='type' onchange='$.csSelect.changeType(this.value)'><option value='1'>套装</option><option value='3'>西服</option><option value='2000'>西裤</option><option value='3000'>衬衣</option></select>");
		$.csSelect.bindLabel();
		$.csSelect.bindEvent();
		$.csSelect.changeType("1");//服装分类
		$.csSelect.showJbgy(member.businessUnit);//基本工艺
	}
};