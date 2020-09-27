// 导入EXL文件的JS
jQuery.csImportStyle = {
	bindLabel : function() {
		$.csCore.getValue("Button_Submit", null, "#btnSave");
		$.csCore.getValue("Button_Cancel", null, "#btnCancel");
	},
	bindEvent : function() {
		$("#btnSave").click($.csImportStyle.save);
		$("#btnCancel").click($.csCore.close);

		$('#uploadFile').change(function() {
			$.csImportStyle.checkFile(this);
		});
	},
	checkFile : function(obj) {
		var filestr = $(obj).val();
		// xls|jpg|......
		if (!/.(xls)$/.test(filestr)) {
			$.csCore.alert("文件格式不正确");
			$(obj).val("");
		} else {
			$('#upbar').show();
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
		var requestUrl = $.csCore
				.buildServicePath('/service/assemble/importstyleprocess');
		$.ajaxFileUpload({
			url : requestUrl, // 需要链接到服务器地址
			async : false,// 同步
			cache : false,// 不读缓存
			secureuri : false,
			fileElementId : 'uploadFile', // 文件选择框的id属性
			dataType : 'json', // 服务器返回的格式，可以是json
			success : function(data, status) // 相当于java中try语句块的用法
			{
				if ((null != data && data == "") || data == "") {
					$.csAssembleList.list(0);
					$.csCore.alert("导入成功");
					$('#loadShow').hide();
					$.csCore.close();
				} else {
					$('#loadShow').hide();
					$('#upbar').show();
					$.csCore.alert(data);
				}
				// $('#result').html('添加成功');
			},
			error : function(data, status, e) // 相当于java中catch语句块的用法
			{
				$('#result').html('添加失败');
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
	init : function() {
		$.csImportStyle.bindLabel();
		$.csImportStyle.bindEvent();
	}
};