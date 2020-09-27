jQuery.csOrdenJhrq={
	bindLabel:function (){		
//		$.csCore.getValue("Orden_DealDate",null,".lblDealDate");
//		$.csCore.getValue("Button_Cancel",null,"#btnCancel");
//		$.csCore.getValue("Button_Submit",null,"#btnSubmit");
	},
	bindEvent:function (){
		$("#btnSubmit").click($.csOrdenJhrq.saveJhrq);
		$("#btnCancel").click($.csCore.close);
	},
	saveJhrq : function(){
		var type=$("#ordenListType").val();
//		$.csCore.confirm($.csCore.getValue('Orden_JhrqConfirm'),"$.csOrdenJhrq.save()");
		$.weeboxs.open($.csCore.getValue('Orden_JhrqConfirm'), {
            title: $.csCore.getValue("Common_Prompt"),
            okBtnName: $.csCore.getValue("Button_OK"),
            cancelBtnName: $.csCore.getValue("Button_Cancel"),
            type: 'dialog',
            onok: function () {
            	eval($.csOrdenJhrq.save(type));
//                $.csCore.close();
//            	$.csOrdenList.list(0);
            },
            oncancel: function () {
                $.csCore.close();
            }
        });
	},
	save:function (type){
	    if($.csCore.postData($.csCore.buildServicePath('/service/orden/saveordenjhrq'), 'form')){
	    	if(type==1){//快速下单
	    		if($.cookie("ordenSearchUrl") != null){
    				window.location.href='/hongling/orden/dordenPage.do?'+$.cookie("ordenSearchUrl");
    			}else{
    				window.location = this.getPath() + '/orden/ordenListPage_transitAction.do';
    			}
	    	}else if(type==2){//我的订单
	    		$.csOrdenList.list(0);
	    	}
	    	$.csCore.close();
	    }
	},
	getPath : function getRootPath() {
		// 获取当前网址，如：  http://localhost:8080/hongling/orden/meun.jsp
		var curWwwPath = window.document.location.href;
		// 获取主机地址之后的目录，如： uimcardprj/share/meun.jsp
		var pathName = window.document.location.pathname;
		var pos = curWwwPath.indexOf(pathName);
		// 获取主机地址，如： http://localhost:8080
		var localhostPaht = curWwwPath.substring(0, pos);
		// 获取带"/"的项目名，如：/hongling
		var projectName = pathName.substring(0,
				pathName.substr(1).indexOf('/') + 1);
		return (localhostPaht + projectName);
	},
	init:function(ID,jhrq,ordenListType){
		$.csOrdenJhrq.bindLabel();
		$.csOrdenJhrq.bindEvent();
//		$.csDate.datePickerTo10("jhrq",jhrq);
		$("#ID").val(ID);
		$("#ordenListType").val(ordenListType);
	}
};