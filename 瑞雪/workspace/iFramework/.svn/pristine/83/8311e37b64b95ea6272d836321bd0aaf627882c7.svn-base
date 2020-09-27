function alert(message,title){ 
	if(title == null || title == undefined )
		title = "消息框";
    if ($("#dialogalert").length == 0) { 
        $("body").append('<div id="dialogalert"></div>'); 
        $("#dialogalert").dialog({ 
            autoOpen: false, 
            title: title, 
            modal: true, 
            resizable:false, 
            overlay: { 
                opacity: 0.5, 
                background: "black" 
            }, 
            buttons: { 
                "确定": function(){ 
                    $(this).dialog("close"); 
                } 
            } 
        }); 
    } 
     
    $("#dialogalert").html(message); 
    $("#dialogalert").dialog("open"); 
}  

function confirm(message,callback,title){ 
	if(title == null || title == undefined)
		title = "确认框";
    if ($("#dialogconfirm").length == 0) { 
        $("body").append('<div id="dialogconfirm"></div>'); 
        $("#dialogconfirm").dialog({ 
            autoOpen: false, 
            title: title, 
            modal: true, 
            resizable:false, 
            overlay: { 
                opacity: 0.5, 
                background: "black" 
            }, 
            buttons: { 
                "确定": function(){ 
                    callback(); 
                    $(this).dialog("close"); 
                }, 
                "取消": function(){ 
                    $(this).dialog("close"); 
                } 
            } 
        }); 
    } 
    $("#dialogconfirm").html(message); 
    $("#dialogconfirm").dialog("open");     
} 

