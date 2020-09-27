/* JS程序简要描述信息
**************************************************************
* 程序名	: index.js
* 建立日期: 2010-07-21
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
    $($("button", $("#PopupBox_L2").parent())[1]).text("保存");
    $($("button", $("#PopupBox_L2").parent())[0]).text("关闭");
    
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
	    window.document.getElementById("PopupBox_L3").innerHTML="<iframe id='PopupBoxIframe_L3' src='' ></iframe>";
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
    $($("button", $("#PopupBox_L3").parent())[1]).text("保存");
    $($("button", $("#PopupBox_L3").parent())[0]).text("关闭");
    
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
