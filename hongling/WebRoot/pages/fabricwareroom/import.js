$.csImportFabricWareroom={
	bindLabel : function() {
		$.csCore.getValue("Button_Submit", null, "#btnSave");
		$.csCore.getValue("Button_Cancel", null, "#btnCancel");
	},
	bindEvent : function() {
		$("#btnSave").click($.csImportFabricWareroom.save);
		$("#btnCancel").click($.csCore.close);
		$('#uploadFile').change(function() {
			$.csImportFabricWareroom.checkFile(this);
		});
	},
	checkFile : function(obj) {
		var filestr = $(obj).val();
		if (!/.(xls)$/.test(filestr)) {
			$.csCore.alert("请输入xls文件");
			$(obj).val("");
		} else {

		}
	},
	save : function() {
		var filestr = $('#uploadFile').val();
		if (null == filestr || "" == filestr) {
			$.csCore.alert("请先选择文件");
			return;
		}
		$('#upbar').hide();
		$('#loadShow').show();
		var requestUrl = $.csCore.buildServicePath('/service/fabricwareroom/importFabricwareroom');
		$.ajaxFileUpload({
			url : requestUrl, // 需要链接到服务器地址
			async : false,// 同步
			cache : false,// 不读缓存
			secureuri : false,
			fileElementId : 'uploadFile', // 文件选择框的id属性
			success : function(data, status) // 相当于java中try语句块的用法
			{
				$.csFabricWareroomList.list(0);
				$('#loadShow').hide();
				$('#upbar').show();
				$('#uploadFile').val('');
				$.csCore.alert("导入成功");
			}	
		});
	},
	getRootPath : function() {
		// 获取当前网址，如： http://localhost:8083/uimcardprj/share/meun.jsp
		var curWwwPath = window.document.location.href;
		// 获取主机地址之后的目录，如： uimcardprj/share/meun.jsp
		var pathName = window.document.location.pathname;
		var pos = curWwwPath.indexOf(pathName);
		// 获取主机地址，如： http://localhost:8083
		var localhostPaht = curWwwPath.substring(0, pos);
		// 获取带"/"的项目名，如：/uimcardprj
		var projectName = pathName.substring(0,
				pathName.substr(1).indexOf('/') + 1);
		return (localhostPaht + projectName);
	},
	init:function(){
		$.csImportFabricWareroom.bindLabel();
		$.csImportFabricWareroom.bindEvent();
	}
};