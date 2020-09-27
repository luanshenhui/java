$(function(){
	var link = $("#navId span");
	jsonData=111;
	var targetMenuId = "";
	appendMenu();
	//topMenuTreeClickBand();
	addFavMenu();
	addFavMenuBond();
	editFavMenuBond();

	//加载菜单
	function appendMenu(){
		var sessionId = $("#sessionId").val();
		var webpath = $("#webpath").val();	
		jQuery.ajax({
			url:webpath + "/MenuTreeAction.do?method=getMenuTree",
			type:"post",
			async: false,
			dataType:"json",
			success:function(msg) {  
				if (msg == null) {
					alert(Consts.Menu.load_menu_failed);
				} else {
					jsonData = msg;
					generateMenu(msg);
				}
	        }
		});
	};
	//加载菜单
	function generateMenu(jsonMsg) {
		var webpath = $("#webpath").val();	
		//顶部菜单
		var menuDiv = $("#nav");
		var mainMenuDiv = $("#menuDiv");
		var qMenuDiv = $('#qMenuDiv');
		//左边菜单
		var leftMenuDiv = $("#left");
		//右边菜单
		//var rightMenuDiv = $("#qMenuDiv ul");
		var editImgSrc=webpath+"/view/base/theme/css/redmond/images1009/frame/ico_edit.png";
		var arrowImgSrc=webpath+"/view/base/theme/css/redmond/images1009/frame/ico_arrow2_r.png";
		var leftMenuHTML='';
		var mainMenuHTML=''
		var topMoreMenuHTML='';
		var topMenuShowCount=getInitCountTop();
		var leftMenuShowCount=getInitCountLeft();
		for (var i in jsonMsg) {
			var submenuField;
			if (i==0) {				
				leftMenuHTML = leftMenuHTML + '<div id="leftMenu_0" class="menu_favorite"><ul class="png">'+Consts.Menu.fav_menu+'</ul><div id="editfavMenu" class="ico_edit"><img src="'+editImgSrc+'"/></div></div>';
				leftMenuHTML = leftMenuHTML + '<div id="activeMenu" class="menu_nor_on png" style="display:none">'+Consts.Menu.fav_menu+'</div>';
				leftMenuHTML = leftMenuHTML + '<div class="tree_zone" id="tree_zone" style="height:380px;overflow:scroll;display:block">';								
				leftMenuHTML = leftMenuHTML + '</div>';
				leftMenuHTML = leftMenuHTML + '<div class="sidebar_menu_hide png"><div class="arrow png" style="display:none"></div></div>';
			} else {
				var x = i-1;
				if (i==1) {					
					mainMenuHTML = mainMenuHTML +'<li class="on" id="menu_'+x+'">'+jsonMsg[i].text+' </li>';
				} else{
					if(i<leftMenuShowCount){					
						leftMenuHTML = leftMenuHTML + '<div id="leftMenu_'+x+'"class=" menu_nor png">'+jsonMsg[i].text+'</div>';					
					}else if(i==leftMenuShowCount){
						
						leftMenuHTML = leftMenuHTML + '<div class="menu_more png "><div id="moreMenuSwitch" class="ico_arrow">';
						leftMenuHTML = leftMenuHTML +'<img src="'+arrowImgSrc+'" />';
						leftMenuHTML = leftMenuHTML +'</div>';
						leftMenuHTML = leftMenuHTML +'<div id="moreMenu"  class="menu_more_list Shadow png" style="display:none;">';
						leftMenuHTML = leftMenuHTML +'<ul>';
						leftMenuHTML = leftMenuHTML + '<li id="moreMenu_'+x+'" onmouseover="this.className=\'hover\'" onmouseout="this.className=\'\'" title="'+jsonMsg[i].text+'">'+jsonMsg[i].text+'</li>';									
					
					}else{
						leftMenuHTML = leftMenuHTML + '<li id="moreMenu_'+x+'" onmouseover="this.className=\'hover\'" onmouseout="this.className=\'\'" title="'+jsonMsg[i].text+'">'+jsonMsg[i].text+'</li>';								
					}
					if(i<topMenuShowCount){
						mainMenuHTML = mainMenuHTML +'<li class="li" id="menu_'+x+'">'+jsonMsg[i].text+' </li>';
					}else{
						topMoreMenuHTML = topMoreMenuHTML + '<li id="qmenu_'+x+'" onmouseover="this.className=\'hover\'" onmouseout="this.className=\'\'" title="'+jsonMsg[i].text+'">'+jsonMsg[i].text+'</li>';
					}
				} 
			}
		}
		$("#menuCount").val(i);
		if(i>leftMenuShowCount){		
			leftMenuHTML = leftMenuHTML + '</ul></div></div>';
		}
		/*if(i>topMenuShowCount){		
			leftMenuHTML = leftMenuHTML + '</ul></div></div>';
		}*/
		mainMenuDiv.append(mainMenuHTML);
		leftMenuDiv.append(leftMenuHTML);
		qMenuDiv.append(topMoreMenuHTML);		
		if (jsonMsg[0].hasChildren) {
			leftTreeBuild('tree_zone', jsonMsg[0].ChildNodes);
		}
		if(i>leftMenuShowCount-1){
			$('#moreMenuSwitch').click(function(){				
				if(document.getElementById("moreMenu").style.display=="block"){						
					document.getElementById("moreMenu").style.display = "none";
				}else{					
					document.getElementById("moreMenu").style.display ="block";
					moreMenuHideBand();
				}	
			});	
		}
		
		if(i>topMenuShowCount-1){
			$("#qButtonDiv").show();
			$("#qButtonDiv").click(function(){
				if(document.getElementById("qMenuListDiv").style.display=="block"){					
					document.getElementById("qMenuListDiv").style.display = "none";				
				}else{
					document.getElementById("qMenuListDiv").style.display ="block";
					qMenuHideBand();
				}	
			});
		}else{
			$("#qButtonDiv").hide();
		}
	};
	
	function Event(e){
        var oEvent = document.all ? window.event : e;
        if (document.all) {
            if(oEvent.type == "mouseout") {
                oEvent.relatedTarget = oEvent.toElement;
            }else if(oEvent.type == "mouseover") {
                oEvent.relatedTarget = oEvent.fromElement;
            }
        }
        return oEvent;
    }
	function Contains(a, b){
		 return a.contains ? a != b && a.contains(b) : !!(a.compareDocumentPosition(b) & 16);
	}
	function moreMenuHideBand(){
		var moreMenuDiv = document.getElementById('moreMenu');
		moreMenuDiv.onmouseout = function(e){
            var o = Event(e).relatedTarget;
            if(!Contains(this, o)){            	
                this.style.display = "none";
            }
        };
	};
	function qMenuHideBand(){
		var qMenuDiv = document.getElementById('qMenuListDiv');
		qMenuDiv.onmouseout = function(e){
            var o = Event(e).relatedTarget;
            if(!Contains(this, o)){
                this.style.display = "none";
            }
        };
	};
	//页面生成树的方法	
	function leftTreeBuild(treeid, treedata){	
		$("#tree_zone").html="";
		var webPath = $("#webpath").val();//局部变量
		
		var s_cbiconpath = webPath+"/view/base/theme/css/redmond/tree/images/icons/";	
		var s_emptyiconpath = webPath+"/view/base/theme/css/redmond/tree/images/s.gif";
		var o = {
		    showcheck: false,
			cbiconpath: s_cbiconpath, //checkbox icon的目录位置
			emptyiconpath:s_emptyiconpath, //checkbxo三态的图片
		    //url: "http://jscs.cloudapp.net/ControlsSample/GetChildData" 
		    theme: "bbit-tree-lines", //bbit-tree-lines ,bbit-tree-no-lines,bbit-tree-arrows		   
		    theme: "bbit-tree-arrows", //bbit-tree-lines ,bbit-tree-no-lines,bbit-tree-arrows
		    onnodeclick:function(item){leftTreeClick(this, webPath,item.value, item.id);}
	     };				
	     o.data = treedata;
	     $("#"+treeid).treeview(o);	 
	};	

	//顶部二级菜单点击事件
	function topMenuTreeClickBand(){
		var webpath = $("#webpath").val();	
		$(".menu2 span").each(function(i){
			$(this).click(function(){
				var subMenuId = $(this).parent().attr("id");
				var hotMenuNum = getIdNumber(subMenuId);
				var oldActiveNum = $("#activeMenuNum").attr("value");
				if(oldActiveNum!=hotMenuNum){
					$("#leftMenuDD_"+hotMenuNum).show();
					setLeftMenuDivHeight(hotMenuNum);
					$("#leftMenuDD_"+oldActiveNum).hide();									
					$("#activeMenuNum").val(hotMenuNum);						
				}
				targetUrl = $(this).children().attr("value");
				
				if (targetUrl != 'undefined' && targetUrl != null && targetUrl != "") {
					document.getElementById("centreFrameId").contentWindow.document.write('');
					document.getElementById("centreFrameId").contentWindow.document.close(); 					
					$("#centreFrameId").attr("src", webpath+targetUrl);
					targetMenuId = $(this).children().attr("id");					
					$("#targetMenu").val(targetMenuId);
					var parentName = $(".on").text();
					var childName = $(this).children().text();
					link.text(parentName + "＞" + childName);
				}
			});
		});
	};

	
	
	//左边菜单链接单击事件绑定jquery.tree.js onnodeclick
	function leftTreeClick(obj, webPath,theURL, menuId){		
		var _url = webPath+theURL;		
		if (theURL!=null && theURL!='undefined' && theURL!="") {				
			document.getElementById("centreFrameId").contentWindow.document.write('');
			document.getElementById("centreFrameId").contentWindow.document.close(); 
			$("#centreFrameId").attr("src",_url);
			targetMenuId=menuId;
			$("#targetMenu").val(menuId);
			var linkText = $(obj).attr("title");	
			var linkText = $(obj).attr("title");			
			linkText = $("#activeMenu").html()+getLinkText(linkText, $(obj));			
			var link = $("#navId span");
			link.text(linkText);
			$("#navId").attr("title",linkText);
		}
	};
	
	function getLinkText(linkText, element) {		
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
	function addFavMenu(){
		var favHTML = '<div id="addFavMenu" class="content link_01"><a href="#">'
			+'加入收藏'+'</a></div>';
			//+Consts.Menu.add_fav+'</a></div>';
		$("#favMenu").append(favHTML);
	}	
	//添加我的收藏
	function addFavMenuBond(){
	
		$("#addFavMenu").click(function(){			
				var webpath = $("#webpath").val();//局部变量
				var webpathLength = webpath.length;				
				var url = $("#centreFrameId").attr("src");
				var targetUrl = url.substr(webpathLength);				
				jQuery.ajax({
					url:webpath + "/MenuTreeAction.do?method=addFavMenu",
					type:"post",
					async: false,
					dataType:"String",
					data:{targetMenuId:$("#targetMenu").val()}, 
					success:function(msg) {  
						if (msg == null) {
							alert(Consts.Menu.add_fav_failed);
						} else {
							reFlashFavMenu();
							alert(msg);
						}
			        }
				});
			//});
		});
	}
	//编辑我的收藏
	function editFavMenuBond(){		
		$("#editfavMenu").bind('click', generateEditFavMenuDialog);
	}

	function generateEditFavMenuDialog(){
		var favEditFlag = $("#favEditFlag").val();			
		if(favEditFlag!=null&&favEditFlag==1){			
			reloadFavMenu();
		}
		$("#editFavDiv").dialog("destroy");
		var webpath = $("#webpath").val();//局部变量
		var ulInfo = $("#sortableFav");
		ulInfo.html("");
		var favData = jsonData[0].ChildNodes;		
		for (var i in favData) {
			var id = favData[i].id;
			var name = favData[i].text;
			var liInfo = $('<li class="ui-state-default" style="font-size:12px;line-height:21px" id="'+id
						+'"><span class="ui-icon ui-icon-arrowthick-2-n-s"></span><cite style="font-style:normal;float:right;"><a href="#">'+
						Consts.Menu.field_delete+'</a></cite>'+name+'</li>');
			liInfo.appendTo(ulInfo);
		}		
		
		$("#sortableFav li cite").each(function(i){
			$(this).bind('click', function(){
				$(this).parent().remove();
			});
		});
		
		var $dialog = $("#editFavDiv")
			.dialog({
			width: 400,
			autoOpen: false,
			title: Consts.Menu.edit_fav_title,
			modal: true,
			buttons: {
				"cancel":function() {
					$(this).dialog('close');
				},
				"reset": function() {
					generateEditFavMenuDialog();
				},
				"confirm":function() {
					var operateInfo = "";
					$("#sortableFav li").each(function(i) {
						var menuId = $(this).attr("id");
						var menuOrder = i+1;
						var menuInfo = menuId + ':' + menuOrder;
						operateInfo = operateInfo + menuInfo + '~';
					});
					
					jQuery.ajax({
						url:webpath + "/MenuTreeAction.do?method=updateFavMenu",
						type:"post",
						async: false,
						dataType:"String",
						data:{operateInfo:operateInfo}, 
						success:function(msg)
				        {  	
							reloadFavMenu();							
							ulInfo.html(msg);
							$dialog.dialog({
								buttons: {
									"confirm": function() {
										$(this).dialog('close');
									}
								}
							});
							$dialog.parent().children().last().children("button:eq(0)").text(Consts.Menu.button_confirm);
						}
					});
				}
			},
			open: function() {
				$(this).parent().children().last().children("button:eq(0)").text(Consts.Menu.button_cancel);
				$(this).parent().children().last().children("button:eq(1)").text(Consts.Menu.button_reset);
				$(this).parent().children().last().children("button:eq(2)").text(Consts.Menu.button_confirm);		
			},
			close: function() {
				$dialog.dialog("destroy");
			}
		}).dialog('open');
		
		$("#sortableFav").sortable();
		$("#sortableFav").disableSelection();
		
	};
	function reloadFavMenu (){		
		var webpath = $("#webpath").val();	
		jQuery.ajax({
			url:webpath + "/MenuTreeAction.do?method=getMenuTree",
			type:"post",
			async: false,
			dataType:"json",
			success:function(msg) {  
				if (msg == null) {
					alert(Consts.Menu.load_menu_failed);
				} else {
					$("#favEditFlag").val(0);
					leftTreeBuild('tree_zone', msg[0].ChildNodes);	
					jsonData = msg;						
				}
	        }
		});
	};
	function reFlashFavMenu(){	
		var hotMenuNum = $("#activeMenuNum").val();
		var favEditFlag = $("#favEditFlag").val();
		if(hotMenuNum==0&&favEditFlag!=null&&favEditFlag==1){				
			reloadFavMenu();
		}else{
			$("#favEditFlag").val(1);
		}
	};
	
	
});
