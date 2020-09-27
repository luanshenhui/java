var exportTemp = '';
exportTemp+='<div class="modal-dialog">';
exportTemp+='<div class="modal-content">';
exportTemp+='<div class="modal-header modal-header-primary">';
exportTemp+='<button type="button" data-dismiss="modal" aria-hidden="true" class="close">x</button>';
exportTemp+='<h4 id="modal-header-primary-label" class="modal-title">导出EXCEL</h4>';
exportTemp+='</div>';
exportTemp+='<div class="modal-body">';
exportTemp+='<form id="formShopTypeSelect" role="form" action="#" class="form-horizontal">';
exportTemp+='<div class="row">';
exportTemp+='<div class="form-group">';
exportTemp+='<div class="container-fluid">';
exportTemp+='<div class="btn-group btn-group-sm mbm" style="margin-left: 15px;">';
exportTemp+='<a id="select-all" href="#" class="btn btn-default">全选择</a>';
exportTemp+='<a id="deselect-all" href="#" class="btn btn-default">全清除</a>';
exportTemp+='<a id="refresh" href="#" class="btn btn-default">刷新</a>';
exportTemp+='</div>';
exportTemp+='<select id="public-methods" multiple="multiple" style="position: absolute; left: -9999px;">';
exportTemp+='</select>';
exportTemp+='</div>';
exportTemp+='</div>';
exportTemp+='</div>';
exportTemp+='</form>';
exportTemp+='<iframe id="exportFrame" style= "display   :none "></iframe>';
exportTemp+='</div>';
exportTemp+='<div class="modal-footer">';
exportTemp+='<button type="button" data-dismiss="modal" class="btn btn-default">关闭</button>';
exportTemp+='<button id="btnExportList" type="button" class="btn btn-primary">导出</button>';
exportTemp+='</div>';
exportTemp+='</div>';
exportTemp+='</div>';

var tableColNm=[];		//画面table的头的项目名称
var tableColVal=[];		//画面table的头的项目名称对应的英文字段
var action = "";		//做导出的ajax check的URL
var actionExport="";    //真正导出EXCEL的URL
var exportStatement=""; //导出的SQL语句对应的配置文件的ID
var formId = "";
var fileName = "";
/**
 * 页面初始化
 */
$(function () {
	//装载导出页面
	$("#exportList").html(exportTemp);
	// 店铺导出，导出按钮点击事件绑定 
    $("#btnExportList").click(function(){
    	exportExcel();
    });
    // 店铺导出关闭事件发生
    $('#exportList').on('hide.bs.modal', function () {
    	// 父窗体归还本页的编辑对话框
    	window.top.window.returnCustomModalDialog();
    })
});

/**
 * 导出店铺弹出页面 
 * @param tableId         导出的基本的列名的来源
 * @param url			  导出前的check的url
 * @param urlExport       导出的url
 * @param exportIndex     导出的SQL的Index
 * @param fileNm          导出的文件名字
 * @param formCd          导出的高级查询的控件的id
 * @param extraFieldJson  额外追加的导出的字段名字的json
 * @returns
 */
function exportList(tableId,url,urlExport,exportIndex,fileNm,formCd,extraFieldJson) {
	action = url;
	actionExport = urlExport;
	exportStatement = exportIndex;
	formId = formCd;
	fileName = fileNm;
	
	//清空select的选项
	$("#public-methods").html(''); 
	tableColNm=new Array();
	tableColVal=new Array();
	if (tableId!=''){
		$('#'+tableId+' tr:eq(0) th').each(function(){
			//不排序的项目不取得
			if ($(this).attr('class') && $(this).attr('class').indexOf('sorting_disabled')==-1){
				//取得页面的table的th，追加option项目
				$("#public-methods").append("<option value='"+$(this).attr('colValue')+"'>"+$(this).text()+"</option>"); 
				//导出项目的中文名称，字段名称集合设置
				tableColNm.push($(this).text());
				tableColVal.push($(this).attr('colValue'));
			}
			//刷新隐藏的select项目，将新的option显示到画面上
		});
	}
	//特殊情况（附加导出字段）例子
	//var obj = new Object();	
	//obj.name = "店铺名称";
//	obj.value = "shopName";
//	var obj1 = new Object();	
//	obj1.name = "所属平台";
//	obj1.value = "shopType";
//	var ob = [obj,obj1];
//	extraFieldJson = JSON.stringify(ob);
//	alert(extraFieldJson);
	
	if (extraFieldJson !== null && extraFieldJson !== undefined && extraFieldJson !== '') {
		//解析json字符串成为对象
		var extraField = jQuery.parseJSON(extraFieldJson);
		 for(var i=0;i<extraField.length;i++){
			//取得页面的table的th，追加option项目
			$("#public-methods").append("<option value='"+extraField[i].value+"'>"+extraField[i].name+"</option>"); 
			//导出项目的中文名称，字段名称集合设置
			tableColNm.push(extraField[i].name);
			tableColVal.push(extraField[i].value);
		 }
	}
	//刷新隐藏的select项目，将新的option显示到画面上
	$("#refresh").click();
	
	//清空frame的SRC，相当于重置
	$('#exportFrame').attr('src', '');
	var editDialog = window.top.window.borrowCustomModalDialog($("#exportList"));
	editDialog.modal({show:true, backdrop:'static'});
	window.top.window.$("#select-all").click();
}

/**
 * 导出店铺 
 * @returns
 */
function exportExcel(url) {
	
	// 父窗体归还本页的编辑对话框
	window.top.window.returnCustomModalDialog();
	
	//画面中选择的需要导出的项目的名字,对应的英文名字
	var selectColNm=new Array();
	var selectColVal=new Array();
	var colNm;
	//根据画面选择，抽取相应的字段名称，汉字
	$('#ms-public-methods .ms-selectable .ms-list li').each(function(){
		  if ($(this).attr('class') && $(this).attr('class').indexOf('ms-selected')>-1){
			  colNm = $(this).text();
			  $.each(tableColNm,function(key,val){ 
					if (val == colNm){
						selectColNm.push(val);
						selectColVal.push(tableColVal[key]);
					}
			  });
		  }
	});
	
	//传递参数
	var colName = encodeURI(encodeURI(selectColNm.join(',')));
	var colValue = encodeURI(encodeURI(selectColVal.join(',')));
	var quickSearch = encodeURI(encodeURI($('#quickSearch').val()));
	
	//如果没有选择项目，给出提示
	if (colName==''){
		window.top.window.showModalAlert("请选择导出项目。");
		window.top.window.borrowCustomModalDialog($("#exportList"));
		return false;
	}
	
	//高级查询的场合，生成检索条件的json
	var formJson = "";
	if (formId!=""){
		formJson = formToJson(formId);
	}
	//check的url
	url = action + "?colName="+colName+"&colValue="+colValue+"&quickSearch="+quickSearch +"&exportStatement="+exportStatement+"&formJson="+encodeURI(encodeURI(formJson));
	$.ajax({
        type: 'GET',
        url: url,
        contentType: "application/json;charset=utf-8",
        dataType: "json",
        async: false,//同步
        success: function (data) {
        	if (data.result == "success") {
	        	$('#exportList').modal('hide');
	        	//导出的URL
	        	url = actionExport + "?colName="+colName+"&colValue="+colValue+"&quickSearch="+quickSearch+"&exportStatement="+exportStatement+"&fileName="+encodeURI(encodeURI(fileName))+"&formJson="+encodeURI(encodeURI(data.formJson));
	        	$('#exportFrame').attr('src', url);
	    		return true;
        	} else {
        		window.top.window.showModalAlert(data.msg);
        		window.top.window.borrowCustomModalDialog($("#exportList"));
        		return false;
        	}
        },
        error: function () {
        	window.top.window.showModalAlert("导出失败。");
    		window.top.window.borrowCustomModalDialog($("#exportList"));
    		return false;
        }
    });
}
