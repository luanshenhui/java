jQuery.csDictPriceList={
    moduler : "DictPrice",
	checkAccsss:function(){
		if($.csCore.isAdmin() == false){
			$("#btnCreateDictPrice,#btnRemoveDictPrice,.edit,.lblEdit,.list_result .check").hide();
			$(".edit").parent().hide();
		}
	},
	bindEvent:function (){
		$.csCore.pressEnterToSubmit('keyword','btnSearch');
		$("#btnSearch").click(function(){$.csDictPriceList.list(0);});
		$("#btnRemoveDictPrice").click($.csDictPriceList.remove);
		$("#btnCreateDictPrice").click(function(){$.csDictPriceList.openPost(null);});
	},
	// js获取项目根路径，如： http://localhost:8080/hongling
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
	openPost:function (id){
//		$.csCore.loadModal('../dictprice/post.jsp',980,500,function(){$.csDictPricePost.init(id);});
		$.csCore.loadModal($.csDictPriceList.getPath()+'/pages/dictprice/post.jsp',980,300,function(){$.csDictPricePost.init(id);});
	},
	openView:function (id){
		$.csCore.loadModal($.csDictPriceList.getPath()+'/pages/dictprice/view.jsp',800,300,function(){$.csDictPriceView.init(id);});
	},
	remove:function (){
		var removedIDs = $.csControl.getCheckedValue('chkRow');
		if(""==removedIDs){
			$.csCore.alert("请选择需要删除的信息");
		}else{
			var url = $.csCore.buildServicePath('/service/dictprice/removeDictPrices');
			$.csCore.confirm($.csCore.getValue('Common_RemoveConfirm'), "$.csDictPriceList.confirmRemove('" + url + "','" + removedIDs + "')");
		}
	},
	confirmRemove: function(url, removedIDs) {
	 var param = $.csControl.appendKeyValue("", "removedIDs", removedIDs);
	    var data = $.csCore.invoke(url, param);
	    if (data != null) {
	        if (data == "OK") {
	            removedIDs = removedIDs.split(',');
	            for (var i = 0; i <= removedIDs.length - 1; i++) {
	                $('#row' + removedIDs[i]).remove();
	            }
	            $.csDictPriceList.list(0);
	        }
	        else {
	            $.csCore.alert(data);
	        }
	    }
	},
	list:function (pageIndex){
		var param = $.csControl.appendKeyValue("","pageindex",pageIndex);
		param = $.csControl.appendKeyValue(param,"keyword",$('#keyword').val());
		var data = $.csCore.invoke($.csCore.buildServicePath('/service/dictprice/getDictPrices'),param);
	    $.csCore.processList($.csDictPriceList.moduler, data);
	    if (pageIndex == 0) {
	        $.csCore.initPagination($.csDictPriceList.moduler + "Pagination", data.count, PAGE_SIZE, $.csDictPriceList.list);
	    }
	    $.csDictPriceList.checkAccsss();
	},
	init:function(){
		$.csDictPriceList.bindEvent();
		$.csDictPriceList.list(0);
	}
};