/* JS程序简要描述信息
**************************************************************
* 程序名	: index.js
* 建立日期: 2010-07-21
* 版权声明:
* 模块		: 系统主页面
* 描述		: 提供主页面的页面特效
* 备注		: 
* ------------------------------------------------------------
* 修改历史
* 序号	日期		         修改人		修改原因
* 1   
* 2
**************************************************************
*/
$(function() {	
	$('body').bind('keydown',shieldCommon);
	var webPath = $("#webpath").val();	
//	appendMenu();
	
//动态调整top菜单的div宽度，以满足所有的菜单在一行显示
	getTopMenuWidth();	
//top隐藏及显示事件绑定，以switchPoint为锚点				 
	switchPointToggle();
//右侧快捷菜单导航下拉块隐藏显示事件绑定
	//qButtonDivToggle();
//顶部快捷区事件绑定
	topMenuClickBand();
//一级菜单事件绑定	
	sysMenuChange();
//左边菜单折叠栏事件绑定
	$("#activeMenuNum").val(0);//初始化当前激活的菜单栏位为第一个
	leftMenuAccordionClickBand();
	setLeftMenuDivHeight(0);	


//左边菜单隐藏显示事件绑定
	leftarDivToggle();

//右边快捷菜单事件绑定
	qMenuClickBand();
	
	setHeight();
	setUserShowInfo();
		
});
setUserShowInfo = function(){
	var webpath = $("#webpath").val();	
	var sessionId = $("#sessionId").val();	
	jQuery.ajax({
		url:webpath + "/MainAction.do?method=getUserShowInfo",
		type:"post",
		async: false,
		dataType:"text",
		success:function(msg) {			
			if (msg == null) {	
				
			} else {				
				if(msg.length<200){
					$("#userShowInfo").text(msg);
				}				
			}
        }
	});
};
setHeight = function(){
	var workHeight = $("#work").height();
	var navHeight= $("#navId").height();
	var frameHeigh = workHeight-navHeight-148;	
	$("#left-ar").css({"height":workHeight});
	
	
};
//一级菜单事件绑定	
sysMenuChange = function(){
	$("#menuDiv li").each(
		function(i){
			$(this).click(
				function(){
					if (i==0) {
						window.location = "\index.jsp";
					}
					doSysMenuClassChange(i,$(this));
					leftActiveMenuChange(i,$(this));
							});
					});	
	$("#menuDiv on").each(
			function(i){
				$(this).click(
					function(){
						if (i==0) {
							window.location = "\index.jsp";
						}
						doSysMenuClassChange(i,$(this));
						leftActiveMenuChange(i,$(this));
								});
						});	
	};
	
doSysMenuClassChange =  function(i,obj){	
		//改变选中div的样式
			var hotMenu = $("#menuDiv .on");			
			hotMenu.removeClass("on");
			hotMenu.addClass("li");
		//改变原选中div的样式	
			obj.removeClass("li");
			obj.addClass("on");				
			};
leftActiveMenuChange = function(i,obj){
	var hotqMenuId;
	var hotMenuNum=0;
	//原选中的一级菜单
	var hotSysMenuObj;
	var oldActiveNum=0;
	var dataNum=0;
	oldActiveNum = $("#activeMenuNum").attr("value");	
	hotMenuNum = i;	
	
	dataNum = hotMenuNum*1+1;
	if(oldActiveNum!=hotMenuNum&&hotMenuNum!=0){					
		$("#activeMenu").text(obj.text());
		$("#activeMenu").show();
		TreeBuild('tree_zone', jsonData[dataNum].ChildNodes);
		if(oldActiveNum!=0){
			$("#leftMenu_"+oldActiveNum).show();
		}					
		setLeftMenuDivHeight(hotMenuNum);									
		$("#activeMenuNum").val(hotMenuNum);						
		}	
};			
//一级菜单单击事件：菜单变色（变class=off改为on） 二级菜单栏刷新内容
doSysMenuChange =  function(i,obj){	
//改变选中div的样式
	var hotMenu = $("#menuDiv .on");
	hotMenu.removeClass("on");
	hotMenu.addClass("li");
//改变原选中div的样式	
	obj.removeClass("li");
	obj.addClass("on");	
//刷新二级菜单栏
//隐藏旧的二级菜单
	//取原激活的菜单编号，截取出后缀编号
	var oldmenuid = hotMenu.attr("id");	
	var numIdStart = 0;
	var numIdEnd = 0;
	var oldnumId = 0;	
	oldnumId = getIdNumber(oldmenuid);	
	//隐藏未激活的二级菜单		
	var subMenuOff = $("#submenu_"+oldnumId);	
	//subMenuOff.hide();
	subMenuOff.removeClass("menu2 on2");
	subMenuOff.addClass("menu2");
	//显示激活的二级菜单	
	var subMenuOn = $("#submenu_"+i);	
	subMenuOn.removeClass("menu2");
	subMenuOn.addClass("menu2 on2");
	};




//顶部快捷区事件绑定
topMenuClickBand = function(){	
	$("#toChangePassword").text(Consts.Password.title);
	$("#toChangePassword").click(
		function(){
			openChangePasswordDialog();
			});
	var webpath = $("#webpath").val();		
	jQuery.ajax({
		url:webpath + "/MainAction.do?method=getHelpLink",
		type:"post",
		async: false,
		dataType:"text",
		success:function(msg) {			
			if (msg == null) {	
				
			} else {	
				if(msg.length<200&&msg.length>2){
					var url = webpath + msg;
					$("#toHelpPage").text(Consts.Help.title);					
					$("#toHelpPage").attr("href",url);
				}				
			}
        }
	});	
	$("#toLogonPage").text(Consts.LogOut.linkText);
	$("#toLogonPage").click(
		function(){
			logOut();
			});			
	};
logOut = function() {
	var webPath = $("#webpath").val();	
	var $dialog = $("#logOut").html("<p>"+Consts.LogOut.content+"</p>")
		.dialog({
		hight: 300,
		width: 400,
		autoOpen: false,
		title: Consts.LogOut.title,
		modal: true,
		buttons: {
			"cancel": function(){
				$dialog.dialog("close");
			},
			"confirm": function(){
				$dialog.dialog("close");
				window.location=webPath+'/j_spring_security_logout';
			}
		},
		open: function(){
			$(this).parent().children().last().children("button:eq(0)").text(Consts.LogOut.button_cancel);
			$(this).parent().children().last().children("button:eq(1)").text(Consts.LogOut.button_confirm);
		},
		close: function(){
			$dialog.dialog("destroy");
		}
	}).dialog("open");
};
//top隐藏及显示，以switchPoint为锚点

switchPointToggle = function(){	
		var webPath = $("#webpath").val();
		var arrow1ImgSrc="url("+webPath+"/view/base/theme/css/redmond/images1009/frame/top_hide1.png"+")";
		var arrow2ImgSrc="url("+webPath+"/view/base/theme/css/redmond/images1009/frame/top_hide2.png"+")";
	$("#header_hide").toggle(
		function(){
			$("#header").hide();	
			$("#nav").hide();
			$("#nav_bottom").hide();
			$("#header_hide").css({"background-image":arrow2ImgSrc});
			$("#topHiddenFlag").val(1);//修改top隐藏标志为1 表示隐藏 该标志用于动态计算菜单栏高度
			window.onTopHideresize();			
			var activeNum = $("#activeMenuNum").attr("value");		
			setLeftMenuDivHeight(activeNum);
					},
		function(){
			$("#header").show();
			$("#nav").show();
			$("#nav_bottom").show();
			$("#header_hide").css({"background-image":arrow1ImgSrc});
			window.ontopresize();			
			$("#topHiddenFlag").val(0);//修改top隐藏标志为0 表示不隐藏
			var activeNum = $("#activeMenuNum").attr("value");				
			setLeftMenuDivHeight(activeNum);
					});
	
	};

//右侧快捷菜单导航下拉块隐藏显示
qButtonDivToggle = function(){
	$("#qButtonDiv").click(function(){				
		if(document.getElementById("qMenuDiv").style.display=="none"){				
			$("#qMenuDiv").show();
			$("allo").show();
		}else{				
			$("#qMenuDiv").hide();
			$("allo").hide();
		}	
	});	
	$("#qMenuDiv .close").click(function(){
		$("#qMenuDiv").hide();
		$("allo").hide();
	});
}
//快捷菜单事件绑定	
qMenuClickBand = function(){	
	//隐藏区域事件绑定
	$("#qMenuDiv li").each(
			function(){
				$(this).click(function(){
					MenuChange($(this));
					$("#qMenuListDiv").hide();
				});
			});	
	}

//左边菜单隐藏显示
leftarDivToggle = function(){	
	var webpath = $("#webpath").val();
	var arrow1ImgSrc="url("+webpath+"/view/base/theme/css/redmond/images1009/frame/sidebar_hide_a1.png"+")";
	var arrow2ImgSrc="url("+webpath+"/view/base/theme/css/redmond/images1009/frame/sidebar_hide_a2.png"+")";
	$("#left-ar").toggle(
		function(){
			$("#left").hide();
			$("#sidebar").hide();
			$("#siteinfo").css({"margin-left":"0"});//所有浏览器
			$("#content").css({"margin-left":"0"});//所有浏览器
			$("#left-ar").css({"left":"0"});//所有浏览器
			$("#leftArrow").css({"background-image":arrow2ImgSrc});		
			},
		function(){
			$("#left").show();
			$("#sidebar").show();
			$("#siteinfo").css({"margin-left":"220px"});
			$("#content").css({"margin-left":"220px"});
			$("#left-ar").css({"left":"214px"}); 
			$("#leftArrow").css({"background-image":arrow1ImgSrc});
			
			}
						 );
	};
//左边菜单折叠栏初始化
leftMenuAccordionClickBand = function(){	
	$("#left .menu_nor").each(
		function(){
			$(this).click(function(){				
				MenuChange($(this));		
				});
			});
	$("#leftMenu_0").click(function(){		
		var dataNum = 0;
		$("#activeMenu").text($("#leftMenu_0 ul").text());
		$("#activeMenu").hide();
		var hotMenuNum = 0;
		var oldActiveNum = $("#activeMenuNum").attr("value");
		var favEditFlag = $("#favEditFlag").val();			
		if(favEditFlag!=null&&favEditFlag==1){			
			reloadFavMenu();
		}else{
			TreeBuild('tree_zone', jsonData[dataNum].ChildNodes);
		}		
		setLeftMenuDivHeight(hotMenuNum);									
		$("#activeMenuNum").val(hotMenuNum);
		$("#menu_"+hotMenuNum).removeClass("li");
		$("#menu_"+hotMenuNum).addClass("on");
		$("#menu_"+oldActiveNum).removeClass("on");
		$("#menu_"+oldActiveNum).addClass("li");
	});
	//隐藏区域事件绑定
	$("#moreMenu ul li").each(
			function(){
				$(this).click(function(){	
					MenuChange($(this));
					$("#moreMenu").hide();
				});
			});
	};
MenuChange = function (hotObj){
	var hotqMenuId;
	var hotMenuNum=0;
	//原选中的一级菜单
	var hotSysMenuObj;
	var oldActiveNum=0;
	var dataNum=0;
	oldActiveNum = $("#activeMenuNum").attr("value");
	hotqMenuId = hotObj.attr("id");
	hotMenuNum = getIdNumber(hotqMenuId);
	dataNum = hotMenuNum*1+1;
	if(oldActiveNum!=hotMenuNum){					
		$("#activeMenu").text(hotObj.text());
		$("#activeMenu").show();
		TreeBuild('tree_zone', jsonData[dataNum].ChildNodes);
		if(oldActiveNum!=0){
			$("#leftMenu_"+oldActiveNum).show();
		}					
		setLeftMenuDivHeight(hotMenuNum);									
		$("#activeMenuNum").val(hotMenuNum);					
		$("#menu_"+hotMenuNum).removeClass();
		$("#menu_"+hotMenuNum).addClass("on");
		$("#menu_"+oldActiveNum).removeClass();
		$("#menu_"+oldActiveNum).addClass("li");
		}
};
	
	//页面生成树的方法	
TreeBuild = function(treeid, treedata){	
	$("#tree_zone").html="";
		var webPath = $("#webpath").val();//局部变量
		
		var s_cbiconpath = webPath+"/view/base/theme/css/redmond/tree/images/icons/";	
		var s_emptyiconpath = webPath+"/view/base/theme/css/redmond/tree/images/s.gif";
		var o = {
			clicktoggle: true,
		    showcheck: false,
			cbiconpath: s_cbiconpath, //checkbox icon的目录位置
			emptyiconpath:s_emptyiconpath, //checkbxo三态的图片
		    //url: "http://jscs.cloudapp.net/ControlsSample/GetChildData" 
		    theme: "bbit-tree-lines", //bbit-tree-lines ,bbit-tree-no-lines,bbit-tree-arrows		    
		    theme: "bbit-tree-arrows", //bbit-tree-lines ,bbit-tree-no-lines,bbit-tree-arrows
		    onnodeclick:function(item){TreeClick(this, webPath,item.value, item.id);}
	     };				
	     o.data = treedata;
	     $("#"+treeid).treeview(o);	 
	};
	//左边菜单链接单击事件绑定jquery.tree.js onnodeclick
TreeClick = function(obj, webPath,theURL, menuId){
		var _url = webPath+theURL;				
		if (theURL!=null && theURL!='undefined' && theURL!="") {				
			document.getElementById("centreFrameId").contentWindow.document.write('');
			document.getElementById("centreFrameId").contentWindow.document.close(); 
			$("#centreFrameId").attr("src",_url);			
			targetMenuId=menuId;	
			$("#targetMenu").val(menuId);
			var linkText = $(obj).attr("title");			
			linkText = $("#activeMenu").html()+getLinkText(linkText, $(obj));			
			var link = $("#navId span");
			link.text(linkText);
			$("#navId").attr("title",linkText);
			var screen = document.body.clientWidth;
			var width = 400;
			$("#navId").width(screen-width);
		}
	};	
getLinkText = function(linkText, element) {	
		var tmpElement = element.parent().parent();	
		//下面的判断语句是针对tree组件的，判断上级是否仍是tree的一部分
		if (tmpElement.is("ul") && tmpElement.prev().is("div")) {		
			linkText = getLinkText(tmpElement.prev().attr("title") + "＞" + linkText, tmpElement.prev());			
		} else {		
			parentElement = tmpElement.parent().parent().parent().parent().prev();
			var parentElementText = "";
			if (parentElement.children("span") != 'undefined' && parentElement.children("span") != null) {
				var tmpStr = parentElement.text();
				var removeStr = parentElement.children("span").text();
				parentElementText = tmpStr.substr(0, tmpStr.length-tmpStr.indexOf(removeStr));
			} else {
				parentElementText=parentElement.text();
			}
			
			linkText = parentElementText + "＞" + linkText;
		}
		return linkText;
	}
//动态取左边菜单栏打开的高度	
//当前总菜单树+1<左栏默认显示个数   menuCount=当前总菜单树
//else menuCount=左栏默认显示个数

getLeftMenuHeight = function(){
	
	var menuDivHeight=380;
	//getSize()来源于indexSize.js
	//pageWidth,pageHeight,windowWidth,windowHeight
	var topHeight = 75;//页面top高度
	var menuBarHeight = 28;//28;
	var showMenuCount = 0;
	var sidebarHeight = 6;
	var initShowcount = getInitCountLeft(); 	
	var menuCount = $("#menuCount").val();
	var temp = menuCount*1-initShowcount;
	if(temp<0){
		showMenuCount = menuCount;
	}else{
		showMenuCount = initShowcount;
	}
	//menuCount = 1*getIdNumber($("#menuDiv li:last").attr("id"))+2;
	var oldActiveNum = $("#activeMenu").css("display");
	if(oldActiveNum!='none'){
		showMenuCount = showMenuCount*1+1;	
	}			
	var topHiddenFlag = 0;//top隐藏标志 0为不隐藏 1为隐藏 初始为0	
	topHiddenFlag = $("#topHiddenFlag").val();
	if(topHiddenFlag>0){
		menuDivHeight = getSize()[1]-menuBarHeight*showMenuCount;
		}else{
			menuDivHeight = getSize()[1]-topHeight-menuBarHeight*showMenuCount;
			}
			//alert(menuBarHeight*showMenuCount*1);
	return menuDivHeight-sidebarHeight;
	//alert(getSize()[0]+'-'+getSize()[1]+'-'+getSize()[2]+'-'+getSize()[3]+'-'+pageHeight);
	}
//动态设置左边激活菜单栏的高度	
setLeftMenuDivHeight =function(_num){
	$("#tree_zone").css({"height": getLeftMenuHeight()});	
	}	
//左边菜单初始化

//动态取宽度
getTopMenuWidth = function(){
	var menuDivWidth=60;	
	var menuCount = 1;
	menuCount = 1*getIdNumber($("#menuDiv div:last").attr("id"))+1;
	var _pageWidth = getSize()[0];
	_pageWidth = _pageWidth-menuCount*14-30;
	//动态调整触发的条件是一行显示不下
	if(menuDivWidth*menuCount>_pageWidth){
		menuDivWidth = _pageWidth/menuCount;
		setTopMenuWidth(menuDivWidth,menuCount);
		//修改压缩标识
		$("#zipDivFlag").val(1);
		}	
	return menuDivWidth;
	}
//设置top menu的宽度	
setTopMenuWidth =function(_theWidth,_menuCount){
	$("#menuDiv div").each(
	   function(){
		   $(this).css({"width":_theWidth});
		   });
	}
//触发菜单提示框tip效果
activeMenuDivTip = function(){
	$("#tipjs").before("<div id=dhtmltooltip></div>");
	}
//鼠标移开右边菜单区域消失

//收藏夹edit事件绑定

//取id后缀
getIdNumber =function(theId){
	var numIdStart = 0;
	var numIdEnd = 0;
	var thenum = 0;	
	if(theId && theId.length>0){
		numIdStart = theId.lastIndexOf('_')+1
		numIdEnd = theId.length;
		thenum = theId.substring(numIdStart,numIdEnd);		
		}	
	return thenum;
	}
	
/**
 * ====2级====弹出窗口参数说明：
 * sURL ：请求目标页面的url
 * title ：弹出窗口的标题
 * height ：弹出窗口的高度
 * width ：弹出窗口的宽度
 * isModal ：是否是模态窗口
 * method_name ：保存方法的方法名
 * method_param ：保存方法的参数
 * callback_method : 保存成功后的回调方法
 */
function dialogPopup_L2(sURL,title,height,width,isModal,method_name,method_param,callback_method){
	//window.document.getElementById("PopupBoxIframe_L2").src="javascript:false";
	//window.document.getElementById("PopupBoxIframe_L2").contentWindow.document.write('');
	//window.document.getElementById("PopupBoxIframe_L2").contentWindow.document.clear();
	//window.document.getElementById("PopupBoxIframe_L2").contentWindow.document.close();
	//CollectGarbage();

	if ($('#PopupBoxIframe_L2')[0]) {
	    $('#PopupBoxIframe_L2').empty();
	    $('#PopupBoxIframe_L2').remove();
	    $('#PopupBoxIframe_L2').parent().empty();
	    $('#PopupBoxIframe_L2').parent().remove();
	    window.document.getElementById("PopupBox_L2").innerHTML="<iframe id='PopupBoxIframe_L2' src='' ></iframe>"
	}

	//$("#PopupBox_L2").dialog("destroy");
	//$("#PopupBoxIframe_L2").attr("src","#");
	var strStyle = "width: "+(width)+"px; height: "+(height-90)+"px;";
	$('#PopupBoxIframe_L2').attr("style",strStyle);
	$('#PopupBoxIframe_L2').attr("frameborder","no");
	$('#PopupBoxIframe_L2').attr("border","0");
	$('#PopupBox_L2').dialog({
		title: title,
		bgiframe: true,
		autoOpen: false,
		resizable : false,
		height: height,
		width: width,
		modal: isModal,
		buttons: {
		    '关闭': function() {
				$(this).dialog('close');
    		},
			'保存 ': function() {
    			var centreFrameObj = window.document.getElementById("PopupBoxIframe_L2"); //下面的兼容IE和firefox
	    		var returnValue;
				if (method_param)
					returnValue = centreFrameObj.contentWindow[method_name](method_param);
				else
					returnValue = centreFrameObj.contentWindow[method_name]();
	    		if(returnValue == undefined || returnValue != "false"){  //保存失败不自动关闭页面
	    			if (callback_method){
	    				callback_method(returnValue);
		    		}
	    			$(this).dialog('close');  				
	    		}
	    	}
		}
	});
    //改button文字
    $($("button", $("#PopupBox_L2").parent())[1]).text(BUTTON_SAVE);
    $($("button", $("#PopupBox_L2").parent())[0]).text(BUTTON_CLOSE);
    
	//sURL,name,height,width,bgiframe,autoOpen,resizable,modal,closeFunction,okFunction
	var popupBoxDiv = document.getElementById('PopupBox_L2');
	popupBoxDiv.children[0].src = sURL;
	$("#PopupBox_L2").dialog('open');
}

/**
 * ====3====级弹出窗口参数说明：
 * sURL ：请求目标页面的url
 * title ：弹出窗口的标题
 * height ：弹出窗口的高度
 * width ：弹出窗口的宽度
 * isModal ：是否是模态窗口
 * method_name ：保存方法的方法名
 * method_param ：保存方法的参数
 * callback_method : 保存成功后的回调方法
 */
function dialogPopup_L3(sURL,title,height,width,isModal,method_name,method_param,callback_method,empty_method){
	//window.document.getElementById("PopupBoxIframe_L3").src="";
	//window.document.getElementById("PopupBoxIframe_L3").contentWindow.document.write('');
	//window.document.getElementById("PopupBoxIframe_L3").contentWindow.document.close();
	if ($('#PopupBoxIframe_L3')[0]) {
		$('#PopupBoxIframe_L3').empty();
	    $('#PopupBoxIframe_L3').remove();
	    $('#PopupBoxIframe_L3').parent().empty();
	    $('#PopupBoxIframe_L3').parent().remove();
	    window.document.getElementById("PopupBox_L3").innerHTML="<iframe id='PopupBoxIframe_L3' src='' ></iframe>"
	}
	
	//$("#PopupBox_L3").dialog("destroy");
	var strStyle = "width: "+(width)+"px; height: "+(height-90)+"px;";
	$('#PopupBoxIframe_L3').attr("style",strStyle);
	$('#PopupBoxIframe_L3').attr("frameborder","no");
	$('#PopupBoxIframe_L3').attr("border","0");
	$('#PopupBox_L3').dialog({
		title: title,
		bgiframe: true,
		autoOpen: false,
		resizable : false,
		height: height,
		width: width,
		modal: isModal,
		buttons: {
		    '关闭': function() {
				$(this).dialog('close');
    		},
			'保存 ': function() {
    			var centreFrameObj = window.document.getElementById("PopupBoxIframe_L3"); //下面的兼容IE和firefox
	    		var returnValue;
				if (method_param)
					returnValue = centreFrameObj.contentWindow[method_name](method_param);
				else
					returnValue = centreFrameObj.contentWindow[method_name]();
	    		if(returnValue == undefined || returnValue != "false"){  //保存失败不自动关闭页面
		    		if (callback_method){
	    				callback_method(returnValue);
		    		}
	    			$(this).dialog('close');  				
	    		}
	    	}
		}
	});
    //改button文字
    $($("button", $("#PopupBox_L3").parent())[1]).text(BUTTON_SAVE);
    $($("button", $("#PopupBox_L3").parent())[0]).text(BUTTON_CLOSE);
    
    //加清空按钮
    if(empty_method){
		var button = $('<button type="button"></button>')
			.text('清空')
			.click(function() { empty_method(); $("#PopupBox_L3").dialog('close');});
		$($("button", $("#PopupBox_L3").parent())[0]).parent().append(button);
		$(button).attr("class","ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only ui-state-focus");
		$(button).attr("role","button");
		$(button).attr("aria-disabled","false");
    }
    
	//sURL,name,height,width,bgiframe,autoOpen,resizable,modal,closeFunction,okFunction
	var popupBoxDiv = document.getElementById('PopupBox_L3');
	popupBoxDiv.children[0].src = sURL;
	$("#PopupBox_L3").dialog('open');
}

var alertCallback;
var alertCallbackParam;
//消息提示框
function alert(message,title,callback,param){ 
	alertCallback = callback;
	alertCallbackParam = param;
	if(title == null || title == undefined )
		title = MESSAGE_BOX;
    if ($("#dialogalert").length == 0) { 
        $("body").append('<div id="dialogalert"></div>'); 
        $("#dialogalert").dialog({ 
            autoOpen: false, 
            title: title, 
            async: false,
            modal: true, 
            resizable:false, 
            overlay: { 
                opacity: 0.5, 
                background: "black" 
            }, 
            buttons: { 
                "确定": function(){
            		if(alertCallback)
            			alertCallback(alertCallbackParam);
                    $(this).dialog("close"); 

                } 
            } 
        }); 
    }
    $($("button", $("#dialogalert").parent())[0]).text(BUTTON_OK);
    
    $("#dialogalert").html(message); 
    $("#dialogalert").dialog("open"); 
}  

//确认框
function confirm(message,callback,title){ 
	if(title == null || title == undefined)
		title = CONFIRM_BOX;
    if ($("#dialogconfirm").length == 0) { 
        $("body").append('<div id="dialogconfirm"></div>'); 
        $("#dialogconfirm").dialog({ 
            autoOpen: false, 
            title: title, 
            async: false,
            modal: true, 
            resizable:false, 
            overlay: { 
                opacity: 0.5, 
                background: "black" 
            }, 
            buttons: { 
 				"b_取消": function(){ 
                    $(this).dialog("close");
                     $(this).dialog("destroy");
                     $("#dialogconfirm").remove(); 
                },
                "a_确定": function(){ 
                	if(callback)
                		callback(); 
                    $(this).dialog("close"); 
                     $(this).dialog("destroy");
                    $("#dialogconfirm").remove();
                }
            } 
        }); 
    }
    
    $($("button", $("#dialogconfirm").parent())[0]).text(BUTTON_CANCEL);
    $($("button", $("#dialogconfirm").parent())[1]).text(BUTTON_OK);    
    $("#dialogconfirm").html(message); 
    $("#dialogconfirm").dialog("open");     
} 
function reloadFavMenu (){		
	var webpath = $("#webpath").val();	
	jQuery.ajax({
		url:webpath + "/MenuTreeAction.do?method=getMenuTree",
		type:"post",
		async: false,
		dataType:"json",
		success:function(msg) {  
			if (msg == null) {
				//alert(Consts.Menu.load_menu_failed);
			} else {	
				TreeBuild('tree_zone', msg[0].ChildNodes);
				jsonData = msg;	
				$("#favEditFlag").val(0);
			}
        }
	});
}
function shieldCommon(keyEvent){
	var theEvent;
	if (!keyEvent)
		theEvent = keyEvent;
	else
		theEvent = window.event || arguments.callee.caller.arguments[0];   
	if(theEvent.keyCode==8){      
		var actId = document.activeElement.id;
		if(actId != ""){
			var obj = $("#"+actId);
			if(obj != undefined && obj != null){
				var tagName = document.getElementById(actId).tagName;
				if(tagName != undefined){
					if(tagName == "INPUT" || tagName == "TEXTAREA"){
						return true;
					}
				}

			}
		}
		shieldBackspace();
	}
}
function shieldBackspace(){
	if(window.event)   { 	
		event.returnValue=false;// IE下的情况处理
	 	return false;   
	}   
	else  { 
		arguments.callee.caller.arguments[0].preventDefault();// FF下的情况处理 }
	}   
}