if(typeof wjUtils=='undefined'){// no conflict
	wjUtils = {};
}
$(function(){
	$.fn.richeditor=function(opts){
		$(this).click(function(){
			var target = this;
			$('body').data('currentField',target);
			wjUtils.ckeditor({
				value:$(target).val(),
				submit:function(content){
					target = $('body').data('currentField');
					$(target).val(content);
				}
			});
		});
	};
});
wjUtils.ckeditorId = '__ckeditor';
wjUtils.ckeditorDlgId = '__ckeditorDlg';
wjUtils.ckeditor = function(config){
	var width = $('body').width()*0.8;
	var height = $('body').height()*0.8;
	var settings = {
			width:width,
			height:height,
			submit:function(content){
				alert(content);
			},
			value:'<font color="green">请输入内容</font>'
	};
	config = config||{};
	settings = $.extend(true,settings,config);
	var ckeditorId = wjUtils.ckeditorId;
	var ckeditorDlgId = wjUtils.ckeditorDlgId;

	if ($('#' + ckeditorId).length == 0) {
		var editorHtml = '<textarea id="' + ckeditorId + '" name="'+ckeditorId+'"></textarea>';
		var dlgHtml = '<div id="' + ckeditorDlgId + '">' + editorHtml + '</div>';
		$(dlgHtml).appendTo('body');

		$('#' + ckeditorDlgId).easyForm({
			title : '内容编辑...',
			iconCls : 'icon-edit',
			width : settings.width,
			height : settings.height,
			buttons:[{
				iconCls:'icon-ok',
				text:'完成',
				handler:function(){
					$('#' + ckeditorDlgId).dialog('close');
					var content= $('#'+ckeditorId).val();
					settings.submit.call(this, content);
				}
			},{
				iconCls:'icon-cancel',
				text:'关闭',
				handler:function(){
					$('#' + ckeditorDlgId).dialog('close');
				}
			}]
		/*
		 * submit : function() { $('#' + ckeditorDlgId).dialog('close'); var
		 * content= $('#'+ckeditorId).val(); settings.submit.call(this,
		 * content); }
		 */
		});

		$('#'+ckeditorId).ckeditor({
			width:width-20,
			height:height-220,
			skin:'kama' ,// office2003,kama,v2
			// filebrowserUploadUrl :
			// getDomain()+'/oa/ckupload.action?type=file',
			filebrowserImageUploadUrl : getDomain()+'/product/ckUpload.action'// ,
			// filebrowserFlashUploadUrl :
			// getDomain()+'/oa/ckupload.action?type=flash'
		});
	} 
	$('#' + ckeditorDlgId).dialog('open');
	$('#'+ckeditorId).val(settings.value);
};
//获取图片url
wjUtils.getImage = function(fileName,type){
	return image_path+fileName + (typeof type == 'undefined' ? "_S" : "_"+type);
};
//删除图片
wjUtils.deleteImage = function(imageName){
	publicAjax({
		url:getDomain()+'/product/deleteImage.action',
		data:{imageName:imageName},
		success:function(r){
			
		}	
	});
};
/**
* @param
* @decribtion 通用审核控件
**/

wjUtils.checkActive_oa = function(__opts){
	var setting = $.extend({
		title:'数据审核',
		width:516,
		height:210,
		data:{},
		innerData:{},
		rb:null,
		status:{
			'1':{color:'#009819',text:'审核通过'},
			'100':{color:'#F39403',text:'一级审核'},
			'101':{color:'#DED305',text:'二级审核'},
			'102':{color:'#F5F514',text:'三级审核'},
			'109':{color:'#d10000',text:'审核拒绝'}
		},
		defaultSuggest:'请输入您的审核意见',
		isSuggestByPass:false,//设置审核通过必须有意见输入
		isSuggestByRefuse:true,//设置审核拒绝必须有意见输入
		pass:function(suggest,_dat){},
		refuse:function(suggest,_dat){},
		checkRole:function(_dat){return true;},
		isShow:function(_dat){ 
			return true;
		},
		getUserName:function(_dat){//审核人
			return _dat.UID;
		},
		getTimer:function(_dat){//审核时间
			return _dat.CTIME;
		},
		getStatus:function(_dat){//审核状态
			return _dat.STATUS;
		},
		getContent:function(_dat){//审核意见
			return _dat.REMARK;
		}
	},__opts);
	var checkActiveTmpData = $.extend({},setting.innerData);
	if($('.auto_wjUtils_checkActive_oa').length==0){
		$('<div class="auto_wjUtils_checkActive_oa"><div id="checkActionContent_oa"></div><div style="width:100%;height:90%"><textarea id="suggestion_oa" style="width:'+(setting.width-22)+'px;height:100%;"></textarea></div></div>').appendTo('body').dialog({
				title : setting.title,
				iconCls : 'icon-checkActivity',
				width : setting.width,
				height : setting.height,
				resizable : true,
				closed : true,
				modal : true,
				buttons:[{
					text : '审核拒绝',
					iconCls : 'icon-no',
					handler : function() {	
						var suggest = $('#suggestion_oa','.auto_wjUtils_checkActive_oa').val();
						if(suggest==setting.defaultSuggest)suggest='';
						if(setting.isSuggestByRefuse && suggest==''){
							tipMsg('<span style="color:red">对不起，您必须输入审核意见才能提交审核</span>','审核异常操作提醒',5);
							return;
						}
						if(suggest=='')suggest='默认审核拒绝';
						setting.refuse.call(this,suggest,checkActiveTmpData);
						$('.auto_wjUtils_checkActive_oa').dialog('close');
					}
				},{
					text : '审核通过',
					iconCls : 'icon-ok',
					handler : function() {	
						var suggest = $('#suggestion_oa','.auto_wjUtils_checkActive_oa').val();
						if(suggest==setting.defaultSuggest)suggest='';
						if(setting.isSuggestByPass && suggest==''){
							tipMsg('<span style="font-color:red">对不起，您必须输入审核意见才能提交审核</span>','审核异常操作提醒',5);
							return;
						}
						
						if(suggest=='')suggest='默认审核通过';
						setting.pass.call(this,suggest,checkActiveTmpData);
						$('.auto_wjUtils_checkActive_oa').dialog('close');
					}
				},{
					text : '关  闭',
					iconCls : 'icon-cancel',
					handler : function() {	
						$('.auto_wjUtils_checkActive_oa').dialog('close');
					}
				}]
		});
		$('#suggestion_oa','.auto_wjUtils_checkActive_oa').click(function(){
			if(this.value == setting.defaultSuggest)this.value = '';
		});
	};
	if(setting.checkRole.call(this,setting.innerData)){
		$('#suggestion_oa','.auto_wjUtils_checkActive_oa').removeAttr('disabled').val(setting.defaultSuggest);
		$('.l-btn','.auto_wjUtils_checkActive_oa').each(function(){
			if($(this).find('.icon-cancel').length>0){
				$(this).hide();
			}else $(this).show();
		});
	}else{
		$('#suggestion_oa','.auto_wjUtils_checkActive_oa').attr('disabled','disabled').val('您当前没有审核权限。');
		$('.l-btn','.auto_wjUtils_checkActive_oa').each(function(){
			if($(this).find('.icon-cancel').length>0){
				$(this).show();
			}else $(this).hide();
		});
	};
	$('#checkActionContent_oa','.auto_wjUtils_checkActive_oa').html('');
	$('.auto_wjUtils_checkActive_oa').dialog('open');
	
	var formatterViewHtml = function(rb){
		var tmp = '';var status;
			for(var i=0;i<rb.length;i++){
				if(setting.isShow(rb[i])){
					status = setting.status[''+setting.getStatus(rb[i])];
					tmp += '<ul style="margin:0px; padding:0px;font-size:12px; padding-bottom:8px; margin-bottom:8px; border-bottom:solid 1px #034885"><li style=" padding-bottom:5px"><span style="color:#1671c0;width:90px;font-weight:bold; margin-right:5px;margin-left:5px">'+setting.getUserName(rb[i])+'</span><em style="margin-right:10px">'+setting.getTimer(rb[i])+'</em><span style=" color:'+(status==null?'#000000':status.color)+'; font-weight:bold">'+(status==null?'未知状态':status.text)+'</span></li><li style="line-height:21px; margin-top:5px; color:#505050; padding-left:20px">'+setting.getContent(rb[i])+'</li></ul>';
				}
			}
			$('#checkActionContent_oa','.auto_wjUtils_checkActive_oa').html(tmp);
	};
	/*if(setting.rb!=null){
		formatterViewHtml(setting.rb);
	}else{
		ajaxQuery({
			data:setting.data,
			success:function(rb){
				formatterViewHtml(rb);
			}
		});
	}*/
};
/**
* @param
* @decribtion 审核日志查看
**/
wjUtils.checkActive_js = function(__opts){
	var setting = $.extend({
		title:'审核日志查看',
		width:516,
		height:350,
		data:{},
		innerData:{},
		rb:null,
		status:{
			'0':{color:'#F39403',text:'未实施'},
			'1':{color:'#009819',text:'正在实施'},
			'2':{color:'#d10000',text:'已作废'},
			'3':{color:'#009819',text:'实施完成'},
			'100':{color:'#FF2400',text:'结算申请'},
			'101':{color:'#238E68',text:'业务审核'},
			'102':{color:'#00FFFF',text:'财务审核'},
			'109':{color:'#d10000',text:'审核拒绝'}
		},
		isShow:function(_dat){ 
			return true;
		},
		getUserName:function(_dat){//审核人
			return _dat.__UID;
		},
		getTimer:function(_dat){//审核时间
			return _dat.CTIME;
		},
		getStatus:function(_dat){//审核状态
			return _dat.STATE;
		},
		getContent:function(_dat){//审核意见
			return _dat.REMARK;
		}
	},__opts);
	var checkActiveTmpData = $.extend({},setting.innerData);
	if($('.auto_wjUtils_checkActive_js').length==0){
		$('<div class="auto_wjUtils_checkActive_js"><div id="checkActionContent_js" style="width:100%;overflow:auto;"></div></div>').appendTo('body').dialog({
				title : setting.title,
				iconCls : 'icon-checkActivity',
				width : setting.width,
				height : setting.height,
				resizable : true,
				closed : true,
				modal : true
		})
	};
	$('#checkActionContent_js','.auto_wjUtils_checkActive_js').html('');
	$('.auto_wjUtils_checkActive_js').dialog('open');
	
	var formatterViewHtml = function(rb){
		var tmp = '';var status;
			for(var i=0;i<rb.length;i++){
				if(setting.isShow(rb[i])){
					status = setting.status[''+setting.getStatus(rb[i])];
					tmp += '<ul style="margin:0px; padding:0px;font-size:12px; padding-bottom:8px; margin-bottom:8px; border-bottom:solid 1px #034885"><li style=" padding-bottom:5px"><span style="color:#1671c0;width:90px;font-weight:bold; margin-right:5px;margin-left:5px">'+setting.getUserName(rb[i])+'</span><em style="margin-right:10px">'+setting.getTimer(rb[i])+'</em><span style=" color:'+(status==null?'#000000':status.color)+'; font-weight:bold">'+(status==null?'未知状态':status.text)+'</span></li><li style="line-height:21px; margin-top:5px; color:#505050; padding-left:20px">'+setting.getContent(rb[i])+'</li></ul>';
				}
			}
			$('#checkActionContent_js','.auto_wjUtils_checkActive_js').html(tmp);
	};
	if(setting.rb!=null){
		formatterViewHtml(setting.rb);
	}else{
		ajaxQuery({
			data:setting.data,
			success:function(rb){
				formatterViewHtml(rb);
			}
		});
	}
};