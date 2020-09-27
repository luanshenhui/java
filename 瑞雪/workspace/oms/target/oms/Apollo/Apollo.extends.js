/**
 * 统一控制时间搜索控件返回的时间格式
 * @param dateVal
 * @param isEnd
 * @returns
 */
function parseDateStyleToSQL(dateVal,isEnd){
	/*if(dateVal.indexOf(' ')==-1)//带时间的 均已空格判断区分 ==>ORACLE
	 return "TO_DATE('"+dateVal+" 00:00:00','yyyy-MM-dd HH24:MI:SS')";
	 else
	 return "TO_DATE('"+dateVal+"','yyyy-MM-dd HH24:MI:SS')";
	 */
	return dateVal.indexOf("'")>-1?dateVal:"'"+dateVal+"'";
	/*
	 if(dateVal.indexOf(' ')==-1)//带时间的 均已空格判断区分 ==>MYSQL
	 return "DATE_FORMAT('"+dateVal+" "+(isEnd?"23:59:59":"00:00:00")+"','%Y-%m-%d %T')";
	 else
	 return "DATE_FORMAT('"+dateVal+"','%Y-%m-%d %T')";
	 */
};

/**
 * 全局图标根据名称初始化工具类
 * @param buttons
 * @returns iconCls
 */
function parseIconFromButton(buttons){
	if(buttons.iconCls)return buttons.iconCls;
	name = buttons.text;
	if(name.indexOf('添加')>-1 || name.indexOf('新增')>-1|| name.indexOf('开户')>-1){
		return 'icon-add';
	}else if(name.indexOf('查看')!=-1){
		return 'icon-view';
	}else if(name.indexOf('编辑')>-1){
		return 'icon-modify';
	}else if(name=='删除'){
		return 'icon-delete';
	}else if(name=='搜索'){
		return 'icon-search';
	}else if(name.indexOf('下载') > -1){
		return 'icon-download';
	}else if(name.indexOf('修改')>-1){
		return 'icon-edit';
	}else if(name.indexOf('删除')>-1||name.indexOf('注销')>-1){
		return 'icon-remove';
	}else if(name.indexOf('导出')>-1){
		return 'icon-redo';
	}else if(name.indexOf('分布')>-1){
		return 'icon-reportCount';
	}else if(name.indexOf('打印')>-1){
		return 'icon-print';
	}else if(name.indexOf('审核')>-1){
		return 'icon-checkActivity';
	}else if(name.indexOf('导入')>-1 || name.indexOf('上传') > -1){
		return 'icon-undo';
	}else if(name.indexOf('返回')>-1){
		return 'icon-back';
	}else if(name.indexOf('分组')>-1 || name.indexOf('群组') > -1){
		return 'icon-groupManage';
	}else if(name.indexOf('总计')>-1){
		return 'icon-sum';
	}else if(name.indexOf('帮助')>-1){
		return 'icon-help';
	}else if(name.indexOf('提示')>-1){
		return 'icon-tip';
	}else if(name.indexOf('设置')>-1){
		return 'icon-systemSet';
	}else if(name.indexOf('关闭')>-1){
		return 'icon-suspend';
	}else if(name.indexOf('开启')>-1){
		return 'icon-resume';
	}else if(name.indexOf('显示')>-1){
		return 'icon-136';
	}else if(name.indexOf('隐藏')>-1){
		return 'icon-112';
	}

	return 'icon-modify';
};


$(function(){
	/**
	 *  初始化checkboxList方法
	 * 参数如下：
	 * _opts : checkboxList参数列表，格式（标准json格式）参考如下
	 *  1、指定一个index，格式如下
	 * {"index":"findDicData","checkboxListName": "111",PARAMS:{},"selectObjValueList":[{VALUE:"111"},{VALUE:"222"}],"disableObjList":[VALUE:"111"]}
	 *
	 * index 指向的数据返回参数格式参考如下：
	 * [{"VALUE"":"111111","TITLE":"ti1111","PARAMS":"pp1111"},{"VALUE"":"2222222","TITLE":"ti222222222","PARAMS":"pp2222"}]
	 * index 为指定的参数格式，此种方式，PARAMS参数不可为每个radio指定，不如第二种方式灵活
	 *
	 * 	[{
	"checkboxListName": "eeeeeeeeee",
	checkboxList: [{
		"VALUE": "v1",
		"TITLE": "chebox1",
		"PARAMS": {
			"fff": "1111"
		}
	},
	{
		"VALUE": "v2",
		"TITLE": "chebox2",
		"PARAMS": {
			"fff": "2222"
		}
	}],
	"selectObjValueList": [{
		"VALUE": "v2"
	}]
}]
	 *
	 */
	$.fn.checkboxList =function(_opts,callback){
		var _this = this;
		var boxHelper = {
			needSelect:function(objValueList,targetValue){
				var flag = false;
				if(objValueList){
					$.each(objValueList,function(key,itemObj){
						if(itemObj.VALUE && itemObj.VALUE == targetValue){
							flag = true;
						}
					});
				}
				return flag;
			}
		};
		var buildDom = {
			builid:function(item){
				var pParamStr = "";
				if(item.PARAMS){
					if(typeof item.params =='string'){
						pParamStr = item.PARAMS;
					}else{
						pParamStr = JSON.stringify(item.PARAMS);
					}
				}
				var htmlStr = "";
				$.each(item.checkboxList,function(checkboxIndex,checkboxItem){
					var paramStr="";
					if(checkboxItem.PARAMS){
						if(typeof checkboxItem.PARAMS =='string'){
							paramStr = checkboxItem.PARAMS;
						}else{
							paramStr = JSON.stringify(checkboxItem.PARAMS);
						}
					}
					if(paramStr){
						pParamStr = paramStr;
					}
					if(item.selectObjValueList && boxHelper.needSelect(item.selectObjValueList,checkboxItem.VALUE)){
						htmlStr +="<input type='checkbox' checked name='"+item.checkboxListName+"' title='"+checkboxItem.TITLE+"' id='"+item.checkboxListName+"_"+checkboxIndex+"' value='"+checkboxItem.VALUE+"' params='"+paramStr+"' ";
					}else{
						htmlStr +="<input type='checkbox' name='"+item.checkboxListName+"' title='"+checkboxItem.TITLE+"' id='"+item.checkboxListName+"_"+checkboxIndex+"' value='"+checkboxItem.VALUE+"' params='"+paramStr+"' ";
					}
					htmlStr+=">"+checkboxItem.TITLE+"</input>";
				});
				$(_this).html(htmlStr);
				if(item.disableObjList){
					$.each(item.disableObjList,function(disableIndex,disableObj){
						$("input[name='"+item.checkboxListName+"'][value='"+disableObj.VALUE+"']").attr('disabled', 'disabled');
					});
				}

			}
		};
		if(_opts && _opts.index){
			if(!_opts.url){
				_opts.url = ApolloURL.getAplQueryNoPage();
			}
			apolloAjax(_opts,function(data,params){
				var item = {"checkboxList":data,"checkboxListName":_opts.checkboxListName,"PARAMS":_opts.PARAMS,"selectObjValueList":_opts.selectObjValueList};
				item = $.extend(item,_opts);
				if(item){
					buildDom.builid(item);
				}
				if(callback && (typeof callback == 'function')){
					callback.call(_this);
				}
			});
			return $(_this);
		}else{
			if(_opts && _opts.length>0){
				$.each(_opts,function(index,item){
					if(item && item.checkboxListName){
						if(item.checkboxList && item.checkboxList.length>0){
							buildDom.builid(item);
						}
					}
				})
				if(callback && (typeof callback == 'function')){
					callback.call(_this);
				}
				return $(_this);
			}
		}
	}

	/**
	 * 失效所有
	 */
	$.fn.checkboxList.disableAll = function(domName){
		if(!$("input[name='"+domName+"']") || $("input[name='"+domName+"']").length<1){
			alert("没有对应的dom节点！");
		}else{
			$.each($("input[name='"+domName+"']"),function(index,item){
				$(this).attr('disabled', 'disabled');
			});
		}
	}

	/**
	 * disable指定
	 *
	 * domName：checkboxList name
	 * disableList：需要禁选的value值list，格式参考如下:
	 * [{VALUE:"1111"},{VALUE:"22222"}]
	 * 其中VALUE 为禁选的chebox的value值
	 *
	 */
	$.fn.checkboxList.disable = function(domName,disableList){
		if(!$("input[name='"+domName+"']") || $("input[name='"+domName+"']").length<1){
			alert("没有对应的dom节点！");return;
		}else{
			if(disableList && disableList.length>0){
				$.each(disableList,function(valueIndex,valueItem){
					var targetObjValue = valueItem.VALUE;
					if($("input[name='"+domName+"'][value='"+targetObjValue+"']") && $("input[name='"+domName+"'][value='"+targetObjValue+"']").length>0){
						$("input[name='"+domName+"'][value='"+targetObjValue+"']").attr('disabled', 'disabled');
						return $("input[name='"+domName+"'][value='"+targetObjValue+"']");
					}else{
						alert("没有对应的dom节点！");return ;
					}
				});
			}else{
				alert("禁选list必传");return;
			}

		}
	}


	/**
	 * 有效所有
	 *  domName：checkboxList name
	 *
	 */
	$.fn.checkboxList.enableAll = function(domName){
		if(!$("input[name='"+domName+"']") || $("input[name='"+domName+"']").length<1){
			alert("没有对应的dom节点！");
		}else{
			$.each($("input[name='"+domName+"']"),function(index,item){
				$(this).removeAttr("disabled");
			});
		}
	}

	/**
	 * 指定有效
	 * domName：checkboxList name
	 * enableList：需要禁选的value值list，格式参考如下:
	 * [{VALUE:"1111"},{VALUE:"22222"}]
	 * 其中VALUE 为禁选的chebox的value值
	 */
	$.fn.checkboxList.enable =function(domName,enableList){
		if(!$("input[name='"+domName+"']") || $("input[name='"+domName+"']").length<1){
			alert("没有对应的dom节点！");return;
		}else{
			if(enableList && enableList.length>0){
				$.each(enableList,function(valueIndex,valueItem){
					var targetObjValue = valueItem.VALUE;
					if($("input[name='"+domName+"'][value='"+targetObjValue+"']") && $("input[name='"+domName+"'][value='"+targetObjValue+"']").length>0){
						$("input[name='"+domName+"'][value='"+targetObjValue+"']").removeAttr("disabled");
						return $("input[name='"+domName+"'][value='"+targetObjValue+"']");
					}else{
						alert("没有对应的dom节点！");return ;
					}
				});
			}else{
				alert("enableList必传");return;
			}

		}
	}

	/**
	 *  val：获得domName的选中值或参数值
	 * 参数：domName （必填）,param（选填）
	 * domName：checkboxList组name
	 * param：获取被选中checkbox的指定参数值,参考格式如下
	 * [{"key":"id"},{"key":"value"}]
	 *
	 */
	$.fn.checkboxList.val = function(domName,param){
		if(!$("input[name='"+domName+"']") || $("input[name='"+domName+"']").length<1){
			alert("没有对应的dom节点！");
		}
		if(param){
			var retList = new Array();
			$.each($("input[name='"+domName+"']:checked"),function(index,item){
				var  _this = this;
				var itemValue = {};
				$.each(param,function(index,domObj){
					if(typeof($(_this).attr(domObj.key))!="undefined"){
						itemValue[domObj.key] = $(_this).attr(domObj.key);
					}
				});
				retList.push(itemValue);
			});
			return retList;
		}else{
			var retList = new Array();
			$.each($("input[name='"+domName+"']:checked"),function(index,item){
				var itemValue = {};
				itemValue["id"] = $(this).attr("id");
				itemValue["value"] = $(this).val();
				retList.push(itemValue);
			});
			return retList;
		}
	}

	/**
	 * checkboxList
	 * 全部取消选中
	 */
	$.fn.checkboxList.clearAll =function(domName,callback){
		if(!$("input[name='"+domName+"']") || $("input[name='"+domName+"']").length<1){
			alert("没有对应的dom节点！");
		}
		$.each($("input[name='"+domName+"']"),function(index,item){
			$(this).attr("checked",false);
		});
		if(callback && (typeof callback == 'function')){
			callback.call();
		}
	}

	/**
	 * checkboxList
	 * 全部选中
	 */
	$.fn.checkboxList.selectAll =function(domName,callback){
		if(!$("input[name='"+domName+"']") || $("input[name='"+domName+"']").length<1){
			alert("没有对应的dom节点！");
		}
		$.each($("input[name='"+domName+"']"),function(index,item){
			$(this).prop("checked","checked");
		});
		if(callback  && (typeof callback == 'function')){
			callback.call();
		}
	}

	/**
	 *
	 *
	 * 初始化radioList方法
	 * 参数如下：
	 * _opts : raidolist参数列表，两种数据格式：
	 * 1、指定一个index，格式如下
	 * {"index":"findDicData","radioName": "111",PARAMS:{},"selectObjValue":"5"}
	 *
	 * index 指向的数据返回参数格式参考如下：
	 * [{"VALUE"":"111111","TITLE":"ti1111","PARAMS":"pp1111"},{"VALUE"":"2222222","TITLE":"ti222222222","PARAMS":"pp2222"}]
	 * index 为指定的参数格式，此种方式，PARAMS参数不可为每个radio指定，不如第二种方式灵活
	 *
	 *
	 * 2、直接传送初始化的数据，数据格式如下：
	 [{
				"radioName": "111",
				PARAMS:{},
				selectObjValue:"v1"
				radioList: [{
					"VALUE": "v1",
					"TITLE":"title1",
					"PARAMS":{}
				},
				{
					"VALUE": "v1",
					"TITLE":"title2",
					"PARAMS": {}
				}]
			}]

	 其中PARAMS 属性可以为json或string，会统一转换为string标记到dom节点上
	 如果既有外层params参数，又有内层params参数，则内层PARAMS参数会替换调外层PARAMS参数
	 *
	 */
	$.fn.radioList = function(_opts,callback){
		var _this = this;
		var buildDom = {
			builid:function(item){
				var pParamStr = "";
				if(item.PARAMS){
					if(typeof item.params =='string'){
						pParamStr = item.PARAMS;
					}else{
						pParamStr = JSON.stringify(item.PARAMS);
					}
				}
				var htmlStr = "";
				$.each(item.radioList,function(radioIndex,radioItem){
					var paramStr="";
					if(radioItem.PARAMS){
						if(typeof radioItem.PARAMS =='string'){
							paramStr = radioItem.PARAMS;
						}else{
							paramStr = JSON.stringify(radioItem.PARAMS);
						}
					}
					if(paramStr){
						pParamStr = paramStr;
					}
					if(item.selectObjValue == radioItem.VALUE){
						htmlStr +="<input type='radio' checked name='"+item.radioName+"' title='"+radioItem.TITLE+"' id='"+item.radioName+"_"+radioIndex+"' value='"+radioItem.VALUE+"' params='"+pParamStr+"' ";
					}else{
						htmlStr +="<input type='radio' name='"+item.radioName+"' title='"+radioItem.TITLE+"' id='"+item.radioName+"_"+radioIndex+"' value='"+radioItem.VALUE+"' params='"+pParamStr+"' ";
					}
					htmlStr+=">"+radioItem.TITLE+"</input>";
				});
				$(_this).html(htmlStr);
			}
		};
		if(_opts && _opts.index){
			if(!_opts.url){
				_opts.url = ApolloURL.getAplQueryNoPage();
			}
			apolloAjax(_opts,function(radioData,params){
				var item = {"radioList":radioData,"radioName":_opts.radioName,"PARAMS":_opts.PARAMS,"selectObjValue":_opts.selectObjValue};
				if(item){
					buildDom.builid(item);
				}
				if(callback && (typeof callback == 'function')){
					callback.call(_this);
				}
			});
			return $(_this);
		}else{
			if(_opts && _opts.length>0){
				$.each(_opts,function(index,item){
					if(item && item.radioName){
						if(item.radioList && item.radioList.length>0){
							buildDom.builid(item);
						}
					}
				})
				if(callback  && (typeof callback == 'function')){
					callback.call(_this);
				}
				return $(_this);
			}
		}
	}

	/**
	 * 失效所有
	 */
	$.fn.radioList.disableAll = function(domName){
		if(!$("input[name='"+domName+"']") || $("input[name='"+domName+"']").length<1){
			alert("没有对应的dom节点！");
		}else{
			$.each($("input[name='"+domName+"']"),function(index,item){
				$(this).attr('disabled', true);
			});
		}
	}

	/**
	 * disable指定
	 *
	 * domName：radioList name
	 * disableList：需要禁选的value值list，格式参考如下:
	 * [{VALUE:"1111"},{VALUE:"22222"}]
	 * 其中VALUE 为禁选的chebox的value值
	 *
	 */
	$.fn.radioList.disable = function(domName,disableList){
		if(!$("input[name='"+domName+"']") || $("input[name='"+domName+"']").length<1){
			alert("没有对应的dom节点！");return;
		}else{
			if(disableList && disableList.length>0){
				$.each(disableList,function(valueIndex,valueItem){
					var targetObjValue = valueItem.VALUE;
					if($("input[name='"+domName+"'][value='"+targetObjValue+"']") && $("input[name='"+domName+"'][value='"+targetObjValue+"']").length>0){
						$("input[name='"+domName+"'][value='"+targetObjValue+"']").attr('disabled', true);
						return $("input[name='"+domName+"'][value='"+targetObjValue+"']");
					}else{
						alert("没有对应的dom节点！");return ;
					}
				});
			}else{
				alert("禁选list必传");return;
			}

		}
	}


	/**
	 * 有效所有
	 *  domName：radioList name
	 *
	 */
	$.fn.radioList.enableAll = function(domName){
		if(!$("input[name='"+domName+"']") || $("input[name='"+domName+"']").length<1){
			alert("没有对应的dom节点！");
		}else{
			$.each($("input[name='"+domName+"']"),function(index,item){
				$(this).removeAttr("disabled");
			});
		}
	}

	/**
	 * 指定有效
	 * domName：checkboxList name
	 * enableList：需要禁选的value值list，格式参考如下:
	 * [{VALUE:"1111"},{VALUE:"22222"}]
	 * 其中VALUE 为禁选的chebox的value值
	 */
	$.fn.radioList.enable =function(domName,enableList){
		if(!$("input[name='"+domName+"']") || $("input[name='"+domName+"']").length<1){
			alert("没有对应的dom节点！");return;
		}else{
			if(enableList && enableList.length>0){
				$.each(enableList,function(valueIndex,valueItem){
					var targetObjValue = valueItem.VALUE;
					if($("input[name='"+domName+"'][value='"+targetObjValue+"']") && $("input[name='"+domName+"'][value='"+targetObjValue+"']").length>0){
						$("input[name='"+domName+"'][value='"+targetObjValue+"']").removeAttr("disabled");
						return $("input[name='"+domName+"'][value='"+targetObjValue+"']");
					}else{
						alert("没有对应的dom节点！");return ;
					}
				});
			}else{
				alert("enableList必传");return;
			}

		}
	}


	/**
	 * 设置radioList 选中，
	 * 入参说明：
	 * domName ：radio组名
	 * targetObjValue： 需要被选中的radio的value
	 *
	 */
	$.fn.radioList.selected = function(domName,targetObjValue){
		if(!$("input[name='"+domName+"']") || $("input[name='"+domName+"']").length<1){
			alert("没有对应的dom节点！");return ;
		}
		if($("input[name='"+domName+"'][value='"+targetObjValue+"']") && $("input[name='"+domName+"'][value='"+targetObjValue+"']").length>0){
			$("input[name='"+domName+"'][value='"+targetObjValue+"']").prop("checked",true);
			return $("input[name='"+domName+"'][value='"+targetObjValue+"']");
		}else{
			alert("没有对应的dom节点！");return ;
		}
	}

	/**
	 *  val：获得radioName的选中值或参数值
	 * 参数：domName （必填）,param（选填）
	 * domName：radio组name
	 * param：获取被选中radio的指定参数值
	 */
	$.fn.radioList.val = function(domName,param){
		if(!$("input[name='"+domName+"']") || $("input[name='"+domName+"']").length<1){
			alert("没有对应的dom节点！");return ;
		}
		if(param){
			var retList = new Array();
			$.each($("input[name='"+domName+"']:checked"),function(index,item){
				var  _this = this;
				var itemValue = {};
				$.each(param,function(index,domObj){
					if(typeof($(_this).attr(domObj.key))!="undefined"){
						itemValue[domObj.key] = $(_this).attr(domObj.key);
					}
				});
				retList.push(itemValue);
			});
			return retList;
		}else{
			return $("input[name='"+domName+"']:checked").val();
		}
	}

	/**
	 * radioList
	 * 全部取消选中
	 * 参数：
	 *
	 * domName radio组名
	 */
	$.fn.radioList.clearAll =function(domName,callback){
		if(!$("input[name='"+domName+"']") || $("input[name='"+domName+"']").length<1){
			alert("没有对应的dom节点！");
		}
		$.each($("input[name='"+domName+"']"),function(index,item){
			$(this).attr("checked",false);
		});
		if(callback && (typeof callback == 'function')){
			callback.call();
		}
	}

	/**
	 * 表格方式详细查看
	 */
	$.fn.detailGrid = function(__opts,searchParam){
		if(typeof __opts =='string'){
			if(__opts == 'openGrid'){
				if(typeof searchParam.title != 'undefined'){
					$(targetDom).prev().children('.panel-title').html(searchParam.title);
					delete searchParam.title;
				};
				//if(!$('#detailViewGrid',this).parent().hasClass('datagrid-view')){
				//var dialogParam = $(this).dialog('options');

				var gridParam = $.extend({
					//width:(dialogParam.width-20),
					//height:(dialogParam.height-110),
					pageSize:10,
//						fit:true,
					isLazyPagination:true,
					isShowRowContextMenu:false,
					isShowHeaderContextMenu:false,
					isMiniPagination:true,
					isSearchOpen:true,
					data:{},
					columns:[]
				},searchParam);
				if(typeof gridParam.search == 'undefined'){
					gridParam.height += 33;
				}
				$('#detailViewGrid',this).easyGrid(gridParam);

				/*}
				 else{
				 $('#detailViewGrid',this).datagrid('reload',searchParam.data);
				 }*/
				return $(this).dialog('open');
			} else if(__opts == 'reload'){
				$('#detailViewGrid',this).datagrid('reload');
				return $(this).dialog('open');
			} else
				return $(this).dialog(__opts);
		}
		var targetDom = this;
		var setting = $.extend({
			title : '详细查看',
			iconCls : 'icon-view',
			width : 540,
			height : 410,
			resizable : false,
			closed : true,
			modal : false
		},__opts);
		if(!setting.buttons){
			setting.buttons = [{
				text : ' 关    闭  ',
				iconCls : 'icon-cancel',
				handler : function() {
					$(targetDom).dialog('close');
				}
			}];
		};

		if($('#detailViewGrid',this).length==0){
			setting.content = '<table id="detailViewGrid" style="width:100%;height:100%"></table>';
			$(this).dialog(setting);
		};

	};

	/**
	 * 弹出可选表格数据
	 */
	$.fn.selectGrid = function(__opts,args,defaultValues){
		var targetDom = this;
		if(typeof __opts == 'string'){
			switch(__opts){
				case 'setValues':return  $.fn.selectGrid.methods[__opts](this, args);
				case 'openGrid':
					var defaultIdfield = args.idField?args.idField:"ID";
					$(this).data('selectedValues',null);
					if(defaultValues!=null && typeof defaultValues != 'undefined'){
						var selectedValues ;
						if(typeof  defaultValues == 'object'){
							selectedValues = defaultValues;
						}else{
							var tmp = defaultValues.split(",");
							selectedValues = {};
							for(var i=0;i<tmp.length;i++){
								var data = {};
								data[defaultIdfield] = tmp[i];
								selectedValues[tmp[i].toString()] = data;
							}
						}
						$(this).data('selectedValues',selectedValues);
					}
					if($('#detailViewGrid',this).parent().hasClass('datagrid-view')) {
						var detailGrid = $('#detailViewGrid',targetDom);
						detailGrid.datagrid('clearSelections');
						detailGrid.datagrid('getPager').pagination({pageNumber:1});
						detailGrid.datagrid('options').pageNumber = 1;
//						return $(this).detailGrid('openGrid',args);
					}
					var gridParam = $.extend({
						onLoadSuccess:function(rows){
							var selectedValues = $(targetDom).data('selectedValues');
							var idField = $('#detailViewGrid',targetDom).datagrid('options').idField;
							if(selectedValues==null || typeof selectedValues != 'object') return;
							for(var i=0;i<rows.rows.length;i++){
								if(selectedValues[rows.rows[i][idField].toString()]!=null){
									selectedValues[rows.rows[i][idField].toString()] = rows.rows[i];
									$('#detailViewGrid',targetDom).datagrid('selectRow',i);
								};
							}
							$(targetDom).data('selectedValues',selectedValues);
						},/*onClickRow:function(idx,rowData){
						 var isChecked = $('.datagrid-body-inner',targetDom).find('tr[ datagrid-row-index="'+idx+'"]').hasClass('datagrid-row-selected');
						 var selectedValues = $(targetDom).data('selectedValues');
						 var  gridDatas= $('#detailViewGrid',targetDom).datagrid('getData');
						 var curValue = gridDatas['rows'][idx];
						 var idField = $('#detailViewGrid',targetDom).datagrid('options').idField;
						 if(args.singleSelect || typeof selectedValues == 'undefined'||selectedValues==null)selectedValues={};
						 if(typeof curValue[idField] =='undefined'){
						 $.messager.alert("系统提示","请确认idField","error");
						 return;
						 }
						 if(isChecked){
						 selectedValues[curValue[idField].toString()] = curValue;
						 }else{
						 delete selectedValues[curValue[idField].toString()];
						 }
						 $(targetDom).data('selectedValues',selectedValues);
						 },*/
						singleSelect:true,
						checkbox:true,
						idField:defaultIdfield,
						frozenColumns:[[{field:'ck',checkbox:true}]]
					},args);
					return $(this).detailGrid('openGrid',gridParam);
				case 'open':return $(this).dialog('open');
				case 'close':return $(this).dialog('close');
				case 'reload':return $(this).detailGrid('reload');
				default:$(this).datagrid(__opts,args);
			}
		}
		var setting = $.extend({
			title:'请选择您所需要的数据',
			iconCls:'icon-save',
			singleSelect:false,
			submit:function(datas){
				debug(datas);
			},buttons:[{
				text : '确  认',
				iconCls : 'icon-ok',
				handler : function() {
					var callback = $(targetDom).dialog('options').submit;
					if(typeof callback == 'function'){
//						var tmp = [];
//						var gridSelectedValues = $(targetDom).data('selectedValues');
						var gridSelectedValues = $('#detailViewGrid',targetDom).datagrid('getSelections');
						if(gridSelectedValues == null || typeof gridSelectedValues == 'undefined')gridSelectedValues=[];
						//if(gridSelectedValues == null)gridSelectedValues = {};
						//var idField = $('#detailViewGrid',targetDom).datagrid('options').idField;
//						alter(toString(checkboxValue));
						/*if(gridSelectedValues == null || $.isEmptyObject(gridSelectedValues)){
						 tipMsg("请选择需要的数据！","系统提示");
						 return;
						 }*/
						/*for(var each in gridSelectedValues){
						 tmp.push(gridSelectedValues[each]);
						 }*/

						var _return = callback.call(this,gridSelectedValues);
						if(typeof _return != 'undefined' && !_return)return;
					}
					$(targetDom).dialog('close');
				}
			},{
				text : '关  闭',
				iconCls : 'icon-cancel',
				handler : function() {
					$(targetDom).dialog('close');
				}
			}]
		},__opts);
		$(this).detailGrid(setting);
	};

	$.fn.selectGrid.methods ={
		setValues:function(jq,values){
			if(values == null)return;
			var idField = $('#detailViewGrid',jq).datagrid('options').idField;
			var datas = $('#detailViewGrid',jq).datagrid('getData')['rows'];
			var selectedValues;
			if(typeof values == 'object'){
				selectedValues = values;
			}else{
				selectedValues = {};
				var tmp = values.split(',');
				for(var i=0;i<tmp.length;i++){
					var d = {};
					d[idField] = tmp[i];
					selectedValues[tmp[i].toString()] = d;
				}
			};
			if(!selectedValues || typeof selectedValues != 'object'|| !idField || !datas)return;
			for(var i=0;i<datas.length;i++){
				if(typeof datas[i][idField]!='undefined' && selectedValues[datas[i][idField].toString()]!=null){
					selectedValues[datas[i][idField].toString()] = datas[i];
					$('#detailViewGrid',jq).datagrid('selectRow',i);
				}
			};
			$(jq).data('selectedValues',selectedValues);
		}
	};
	/**
	 *
	 */
	$.fn.easyForm = function(__opts,p,_format){
		var isSelfMethod = function(_callMethod,param,_format,target){
			switch(_callMethod){
				case "openData":
					var tmpData = {};
					for(each in param){
						tmpData[each.toUpperCase()] = param[each];
					}
					$(target).dialog('open').setData(tmpData,$.extend({isApolloData:true},_format));

					//XXX 注册查看屏蔽提交按钮 readOnly:true
					if(_format!=null && typeof _format.readOnly != 'undefined' && $(target).data('readOnlyParam') != _format.readOnly){
						$(target).data('readOnlyParam',_format.readOnly);
						if(_format.readOnly){
							$(target).children('.dialog-button').find('.icon-ok').parent().parent().hide();
						}else{
							$(target).children('.dialog-button').find('.icon-ok').parent().parent().show();
						}
					}else if(_format == null && $(target).data('readOnlyParam') != 'undefined'){
						$(target).children('.dialog-button').find('.icon-ok').parent().parent().show();
						$(target).data('readOnlyParam',null);
					}

					return true;
			}
			return false;
		};

		var __easyForm = this;
		if(typeof __opts == 'string'){
			if(!isSelfMethod(__opts,p,_format,__easyForm)){
				if(typeof p == 'undefined')
					return $(this).dialog(__opts);
				else
					return $(this).dialog(__opts,p);
			}else{
				return __easyForm;
			}
		}
		var param = $.extend({
			title : 'My Form',
			iconCls : 'icon-save',
			width : 640,
			height : 510,
			resizable : true,
			closed : true,
			modal : true
		},__opts);
		var totalHeight = $('body').height();
		if(totalHeight - param.height < 50){//主动修正高度
			param.height = (totalHeight - 50);
		};
		if(typeof __opts.buttons == 'undefined'){
			param.buttons = [];
			if(typeof __opts.submit == 'function'){
				param.buttons.push({
					text : '提交',
					iconCls : 'icon-ok',
					handler : function() {
						var data = $(__easyForm).getData(true);
						if(data!=null && __opts.submit.call(__easyForm,data))
							$(__easyForm).dialog('close');
					}
				});
			}
			if(typeof __opts.cancel == 'function'){
				param.buttons.push({
					text : '取消',
					iconCls : 'icon-cancel',
					handler : function() {
						if(__opts.cancel.call(__easyForm))
							$(__easyForm).dialog('close');
					}
				});
			}else{
				param.buttons.push({
					text : '取消',
					iconCls : 'icon-cancel',
					handler : function() {
						$(__easyForm).dialog('close');
					}
				});
			}
		}
		//$(this).dialog(param).bgIframe();
		$(this).dialog(param);
		return this;
	};

	/*
	 * $.fn.detailGrid = function(__opts){
	 var option = $.extend({
	 url: getDomain()+'/publicJson/query.action'

	 },__opts);
	 };
	 */

	/*
	 * 通用易用表格控件
	 extendsParam:{//扩展参数说明
	 isDownResult:false,//是否支持下载表格数据
	 isMiniPagination:false,//是否是小版表格分页格式显示
	 isLazyLoad:false,//实现页面懒加载，没有默认请求；必须有查询条件的时候才请求数据
	 isLazyPagination:false,//分页数据懒加载，解决大数据count总数查询慢的问题
	 isShowRowContextMenu:true,//数据行右键功能键显示控制
	 isShowHeaderContextMenu:true,//表头显示控制
	 isSearchOpen:false,//是否默认打开搜索
	 columns:[[//较为详细的设置 必须指定width值； 有默认隐藏显示项时设定hidden:true
	 {field:'NAME',title:'名称',sortable:true,width:100,hidden:false}
	 ]],
	 buttons:[{//针对工具栏的扩展(即实现toolbar的扩展)
	 noSelected:false,//即必须选中数据才能执行该button的handler
	 hideHandler:function(data){//选中数据后，控制该button是否需要禁用，该方法不存在时不调用
	 return true;
	 },
	 //roleFilter不需要回调方法时可直接使用 roleFilter:'管理员'
	 roleFilter:{//对该button进行权限过滤显示
	 //该button显示需要的权限； 支持复杂boolean运算
	 //例： value = '超级管理员 || (*审核员 && 省级)'
	 value:'管理员',
	 success:function(){//具有权限时回调
	 //do something
	 },fail:function(){//不具权限时回调
	 //do something
	 }
	 }
	 }]
	 }
	 *
	 */
	$.fn.easyGrid = function(__opts,p){
		if(typeof __opts == 'string'){
			if(typeof p == 'undefined')
				return $(this).datagrid(__opts);
			else
				return $(this).datagrid(__opts,p);
		};

		if(!__opts.columns)return;
		var _thisGrid = this;
		if(!$(this).parent().is('div'))
			if(__opts.height){
				$(this).wrap("<div style='width:100%;height:"+__opts.height+"'></div>");
			}else{
				$(this).wrap("<div style='width:100%;height:100%'></div>");
			}

		if(typeof __opts.before == 'function'){
			__opts.before(__opts.data,__opts);
		};
		var queryUrl = __opts.url;
		if(!__opts.url){
			queryUrl = getDomain()+ApolloURL.getAplQuery();
		}
		var setting = $.extend(true,{
			url: queryUrl,
			queryParams:{},
			nowrap: false,
			striped: true,
			//fit: true,
			pagination:true,
			rownumbers:true,
			singleSelect:true,
			//toolbar:[],
			pageSize:15,
			pageList:[5,10,15,20,40,80,150,500],
			//columns:__opts.columns,
			loadMsg: '正在处理，请稍候...' ,
			sortOrder: 'desc',
			isShowFlush:true,
			isLazyLoad:false,
			isLazyPagination:true,
			isPrint:false,
			isShowRowContextMenu:true,
			isShowHeaderContextMenu:false,
			isMiniPagination:false,
			isSingleDetail:false,
			isDownResult:true,
			isSearchOpen:false,
			isSoftBuilder:false,
			onLoadError:function(){
				//alert(arguments[0].responseText);
				//$.messager.alert('加载错误提示',arguments[0].responseText,"error");
			},
			beforeApolloSearch:__opts.beforeApolloSearch
		},__opts);
		if(!setting.width||!setting.height){
			setting.fit = true;
		};
		if(__opts.data){
			setting.queryParams = __opts.data;
		};

		if(setting.isSoftBuilder && $(this).parent().hasClass('datagrid-view')){//当已经加载过，直接重载。
			$(this).datagrid('reload',setting.queryParams);
			return;
		};

		if(setting.isLazyLoad){
			setting.isSearchOpen=true;
			setting.queryParams['lazyLoad']=true;//特殊参数，用来控制第一次加载屏蔽数据展示
			setting.isLazyLoad = false;
			tipMsg('请先输入搜索条件，再进行数据展现。');
		};

		if(setting.isLazyPagination){
			setting.queryParams['lazyPagination'] = true;
		};

		/*
		 增加当前页面数据JS统计功能
		 PS：该方式是会影响到表单的其他功能，所以需要判定非该方式统计时，恢复datagrid原始onBeforeRender
		 @param target 当前表格
		 @param rows 当前返回数据
		 @return Object {
		 footer:[{field:value,...},{...}],//用来展现的footer值
		 addField:{key:value,....}//用来增加在原始数据中动态增加算出来的结果值
		 }
		 setting.countFooter = function(target,rows){

		 }
		 */
		if(typeof setting.countFooter == 'function'){
			setting.showFooter = true;
			$.fn.datagrid.defaults.view.onBeforeRender = function(target,rows){
				var footerData = setting.countFooter.call(this,target,rows);
				if(typeof footerData == 'object' && typeof footerData.footer == 'object'){
					$.data(target, 'datagrid').footer = footerData.footer;
					if(typeof footerData.addField =='object'){
						for(var i=0;i<rows.length;i++){
							for(var each in footerData.addField){
								rows[i][each] = footerData.addField[each];
							}
						}
						$.data(target, 'datagrid').data.rows = rows;
					}
				}
			};
		}else{
			$.fn.datagrid.defaults.view.onBeforeRender = function(target,rows){
			};
		};

		var flushGridSearchHeight = function(){
			if(__opts.search&&$(_thisGrid).data('isGridSearchShow')){
				var lastHeight = $(_thisGrid).data('lastHeight');
				if(lastHeight!=null){
					window.setTimeout(function(){
						$('.datagrid-body',_thisGrid.parent()).css('height',lastHeight.bHeight);
						_thisGrid.parent().css({height:lastHeight.pHeight});
					},600);
				}
			}
		};
		if(setting.columns!=null){
			var field2Idx = {};
			/*增加对columns的控制*/
			for(var i=0;i<setting.columns[setting.columns.length-1].length;i++){
				var _column = setting.columns[setting.columns.length-1][i];
				if(_column == null || _column.field == null)break;
				field2Idx[_column.field] = i;
				if(typeof _column.formatter == 'undefined'){
					_column.formatter = function(v,data,i,field){
						if(field==null || data ==null || data['__'+field] == null)return v;
						var val = data['__'+field];
						var isNeedSource = setting.columns[setting.columns.length-1][field2Idx[field]].source;
						if(isNeedSource==null || isNeedSource){
							val = '['+v+'] '+val;
						};
						return val;
					};
				}
			}
		};

		/*增加对detailView单个显示控制*/
		if(__opts.view){
			if(__opts.isSingleDetail){
				var checkExpend = function(index){
					var lastDetailViewIndex = $(_thisGrid).data('lastDetailViewIndex');
					if(lastDetailViewIndex && lastDetailViewIndex!=index){
						$('tr[datagrid-row-index="'+lastDetailViewIndex+'"]').find('.datagrid-row-collapse').click();
					}
					$(_thisGrid).data('lastDetailViewIndex',index);
				};
				if(typeof setting.onExpandRow == 'function'){
					setting.onExpandRow = function(index,row){
						__opts.onExpandRow.call(this,index,row);
						checkExpend(index);
					};
				}else{
					setting.onExpandRow = checkExpend;
				}
			};
			setting.isShowHeaderContextMenu  = false;
		};

		if(typeof __opts.onLoadSuccess == 'function'){
			setting.onLoadSuccess = function(datas){
				__opts.onLoadSuccess.call(_thisGrid,datas);
				flushGridSearchHeight();
			};
		}else{
			setting.onLoadSuccess = function(datas){
				if(typeof __opts.after == 'function')__opts.after.call(_thisGrid,datas);
				flushGridSearchHeight();
			};
		};

		var collectButtonControl;

		if(typeof __opts.click == 'function'){
			setting.onClickRow = __opts.click;
		};

		if(typeof __opts.dblclick == 'function'){
			setting.onDblClickRow = __opts.dblclick;
		};
		if(typeof __opts.before == 'function'){
			setting.onBeforeLoad = __opts.before;
		};

		if(__opts.buttons&&__opts.buttons.length>0){
			var menuHeight = 0;
			if(__opts.buttons.length>0){
				var isButtonControl = false;
				setting.toolbar=[];
				var iconCall = {};
				var defaultDBClickCallText;
				var gridContextMenu = '<div id="gridContextMenu" style="width:110px;">';
				var accessIdx  = 1;

				var parser = function(conf){
					icon = parseIconFromButton(conf);
					if(!conf.noSelected&&setting.isShowRowContextMenu)
						gridContextMenu += ('<div iconCls="'+icon+'">'+conf.text+'</div>');
					if(typeof conf.hideHandler=='function'){
						if(collectButtonControl == null)collectButtonControl = {};
						collectButtonControl[conf.text] = conf.hideHandler;
						isButtonControl = true;
						conf.isControlByData = true;
					};
					iconCall[conf.text] = conf;

					//没有默认双击表格事件时，自动将修改数据注册为该事件
					if(typeof setting.onDblClickRow == 'undefined' && (conf.text.indexOf('修改')>-1|| conf.text.indexOf('编辑')>-1)){
						defaultDBClickCallText = conf.text;
						setting.onDblClickRow = function(idx,rowData){
							if(collectButtonControl == null
								|| typeof collectButtonControl[defaultDBClickCallText] == 'undefined'
								|| !collectButtonControl[defaultDBClickCallText].call(_thisGrid,rowData)){
								iconCall[defaultDBClickCallText].handler.call(_thisGrid,rowData);
							}
						};
					};

					setting.toolbar.push({
						title:'快捷键:Alt+'+accessIdx,
						iconCls:icon,
						text:conf.text,
						handler:function(){
							var calling = iconCall[$(this).text().trim()];
							if(typeof calling == 'undefined')return;
							var data = null;
							if(setting.singleSelect){
								data = $(_thisGrid).datagrid('getSelected');
								if(!calling.noSelected&&!data){
									if("101" == __opts.buttons[1].pri_id){
										$.messager.alert('','请选择要修改的数据','系统提示');
									}else{
									//tipMsg('请选中数据后再点击按钮，或者右键选择功能按钮。','表格控件提醒',3);
										$.messager.alert('','请选中数据后再点击按钮，或者右键选择功能按钮。','系统提示');
									}
									return;
								}
							}else{
								data = $(_thisGrid).datagrid('getSelections');
								if(!calling.noSelected&&data.length==0){
									//tipMsg('请选中数据后再点击按钮，或者右键选择功能按钮。','表格控件提醒',3);
									$.messager.alert('','请选中数据后再点击按钮，或者右键选择功能按钮。','系统提示');
									return;
								}
							}
							if(calling.isControlByData){
								if(calling.hideHandler.call(_thisGrid,data)){
									//tipMsg("您无权限操作该数据！","系统提示");
									$.messager.alert('',"该数据不允许进行该操作！","系统提示");
									return;
								}
							}
							calling.handler.call(_thisGrid,data);
						}
					});
					$.hotkeys.add('Alt+'+accessIdx,function(e){
						var index = parseInt(e.keyCode)-49;
						var target = $('.datagrid-toolbar',_thisGrid.parent().parent()).children('a').get(index);
						$(target).click();
					});
					accessIdx++;
					menuHeight += 24;
				};
				if(typeof operate == 'undefined'||operate=='null')operate=15;//没有权限控制时
				for(var i=0;i<__opts.buttons.length;i++){
					var conf = __opts.buttons[i];
					if(conf!=null && typeof conf != 'string'){
						var priId = conf.pri_id;
						if(priId && !PriManager.hasPrevilege(priId)){
							continue;
						}
						/*
						 var __name = conf.text;
						 if(operate!=15){
						 if(__name.indexOf('新增') != -1 && !(2 & operate)){
						 continue;
						 };
						 if(__name.indexOf('创建') != -1 && !(2 & operate)){
						 continue;
						 };
						 if(__name.indexOf('修改') != -1 && !(4 & operate)){
						 continue;
						 };
						 if(__name.indexOf('编辑') != -1 && !(4 & operate)){
						 continue;
						 };
						 if(__name.indexOf('删除') != -1 && !(8 & operate)){
						 continue;
						 };
						 if(__name.indexOf('注销') != -1 && !(8 & operate)){
						 continue;
						 };
						 };
						 */
						if(typeof conf.roleFilter != 'undefined'){
							if(typeof conf.roleFilter == 'string'){
								hasRole(conf.roleFilter,function(is){
									if(is){
										parser(conf);
									}
								});
							}else{
								hasRole(conf.roleFilter.value,function(is){
									if(is){
										if(typeof conf.roleFilter.success=='function')conf.roleFilter.success.call(this);
										parser(conf);
									}else{
										if(typeof conf.roleFilter.fail=='function')conf.roleFilter.fail.call(this);
									}
								});
							}
						}else parser(conf);
					}else{
						setting.toolbar.push('-');
					}
				};
				gridContextMenu += '</div>';

				if(setting.isShowRowContextMenu&&(__opts.onRowContextMenu==null || !__opts.onRowContextMenu)&&gridContextMenu.length>60){
					setting.onRowContextMenu = function(e, rowIndex, rowData){
						e.preventDefault();
						$(_thisGrid).datagrid('selectRow',rowIndex);

						var targetParent = _thisGrid.parent();
						var contextMenu = $('#gridContextMenu',targetParent);
						if(contextMenu.length==0){
							contextMenu = $(gridContextMenu).menu({
								onClick:function(item){
									if(typeof iconCall[item.text]!='undefined'){
										var data;
										if(setting.singleSelect){
											data = $(_thisGrid).datagrid('getSelected');
											if(!data)return;
										}else{
											data = $(_thisGrid).datagrid('getSelections');
											if(data.length==0)return;
										}
										if(iconCall[item.text].isControlByData){
											if(iconCall[item.text].hideHandler.call(_thisGrid,data))return;
										}
										iconCall[item.text].handler.call(_thisGrid,data);
									}
								}
							}).appendTo(targetParent);
						};
						var disOffset = $(targetParent).offset();
						var dis = ( e.pageY - disOffset.top - targetParent.height()+menuHeight);//修正在小窗口中右键数据菜单显示隐藏问题
						if(dis<0)dis=0;
						contextMenu.menu('show',{
							left:(e.pageX - disOffset.left),
							top:(e.pageY - disOffset.top - dis)
						});
					};
				}
			}
		};
		if(collectButtonControl!=null || typeof __opts.onSelect == 'function'){
			setting.onSelect = function(rowIndex, rowData){
				if(collectButtonControl!=null){
					$('a',_thisGrid.parent().prev('.datagrid-toolbar')).each(function(){
						var handler = collectButtonControl[$(this).text()];
						if(typeof handler == 'function'){
							if(handler.call(_thisGrid,rowData)){
								$(this).addClass('l-btn-disabled');
							}else{
								$(this).removeClass('l-btn-disabled');
							}
						}
					});

					$('.menu-text',_thisGrid.next('#gridContextMenu')).each(function(){
						var handler = collectButtonControl[$(this).text()];
						if(typeof handler == 'function'){
							if(handler.call(_thisGrid,rowData)){
								$(this).addClass('l-btn-disabled');
							}else{
								$(this).removeClass('l-btn-disabled');
							}
						}
					});
				}
				if(typeof __opts.onSelect == 'function'){
					__opts.onSelect.call(_thisGrid,rowIndex,rowData);
				}
			};
		};
		var isSearchClose = function(){
			return !setting.isSearchOpen && setting.toolbar!=null && setting.toolbar.length>0;
		};
		if(__opts.search && setting.toolbar && !setting.isSearchOpen){
			setting.toolbar.push('-');
			setting.toolbar.push({
				iconCls:'icon-search',
				text:'搜索',
				handler:function(){
					$(_thisGrid).gridSearch(__opts.search,__opts.data,__opts.isMiniPagination,isSearchClose());
				}
			});
			$.hotkeys.add('Shift+f',function(){
				$(_thisGrid).gridSearch(__opts.search,__opts.data,__opts.isMiniPagination,isSearchClose());
			});
		};
		if(setting.isShowHeaderContextMenu){
			setting.onHeaderContextMenu = function(e,filed){
				e.preventDefault();
				var disOffset = $(_thisGrid.parent()).offset();
				$(_thisGrid).headContextMenu(setting.columns[setting.columns.length-1],{
					left:(e.pageX - disOffset.left),
					top:(e.pageY - disOffset.top)
				});
			};
		};


		//调用datagrid请求表格数据
		delete setting.data;
		$(this).datagrid(setting);
		var paginationButtons = [];
		if(__opts.isDownResult){

			paginationButtons.push({
				iconCls:'icon-download',
				text:'下载',
				handler:function(){
					/* var _downLoadParam = {};
					 _downLoadParam.data = $(_thisGrid).datagrid('options').queryParams;
					 if(_downLoadParam.data.lazyLoad)return;
					 _downLoadParam.elemt={};
					 $.each(setting.columns[setting.columns.length-1],function(i,opt){
					 if(!opt.hidden)
					 _downLoadParam.elemt[opt.title] = {'key':opt.field};
					 else
					 _downLoadParam.elemt[opt.title] = {'key':opt.field,isShow:false};
					 });
					 headControl = $(_thisGrid).next('#datagrid_contextmenu');
					 if(headControl.length>0){
					 headControl.children().each(function(){
					 if($(this).children('.icon-ok').length>0)
					 _downLoadParam.elemt[$(this).text()].isShow = true;
					 else
					 _downLoadParam.elemt[$(this).text()].isShow = false;
					 });
					 }
					 $(_thisGrid).gridDownResult(_downLoadParam); */
					if(confirm("您确定需要下载当前搜索后的结果数据？")){
						//waiting();
						var options = $(_thisGrid).datagrid('options');
						var _url  = 'http://'+window.location.host+options.url;
						var colums = options.columns[options.columns.length-1];
						var fields =[];
						for(var i=0;i<colums.length;i++){
							if(!colums[i].hidden)
								fields.push(colums[i].field+':'+colums[i].title);
						}
						var downParamData = $.extend({
							downUrl:_url,
							downFields : fields.join('|')
						},options.queryParams);
						//window.open(getDomain()+'/core/download.action?index='+options.queryParams.index+'&downFields='+encodeURI(encodeURI(downParamData.downFields)));
						var paramStr = "";
						if(downParamData){
							$.each(downParamData,function(pramkey,paramItem){
								if(pramkey !="downUrl" && pramkey !="index" && pramkey !="lazyPagination"){
									paramStr +="&"+pramkey+"="+paramItem;
								}
							});
							if(setting.downloadUrl){
								if(getDomain()){
									window.open(getDomain()+setting.downloadUrl+'?'+paramStr);
								}else{
									window.open("/"+setting.downloadUrl+'?'+paramStr);
								}								
							}else{
								if(setting.downloadIndex){
									window.open(ApolloURL.getAplDownloadUrl()+'?index='+setting.downloadIndex+paramStr);
								}else{
									window.open(ApolloURL.getAplDownloadUrl()+'?index='+options.queryParams.index+paramStr);
								}
							}
						}
						/*
						 apolloAjax({
						 url:getDomain()+'/publicJson/download.action',
						 data:downParamData,
						 success:function(r){
						 if($('#downLoadFrame').length ==0){
						 $('<iframe style="display:none" id="downLoadFrame" src=""></iframe>').appendTo('body');
						 };
						 var downUrl = getDomain()+'/publicJson/download.action?fileName='+r.msg+'&outName=result.csv';
						 $('#downLoadFrame').attr('src',downUrl);
						 if($.browser.msie){$('#downLoadFrame').each(function(){
						 this.contentWindow.location.href = downUrl;
						 });};
						 waiting('close');
						 },error:function(r,t,e){
						 alert(r.responseText);
						 waiting('close');
						 }
						 });
						 */
					}
				}
			});

			 $.hotkeys.add('Shift+d',function(){
			 $(_thisGrid).gridDownResult(_downLoadParam);
			 });

		};
		if(setting.isPrint){
			paginationButtons.push({
				iconCls:'icon-print',
				text:'打印',
				handler:function(){
					$(_thisGrid).parent().easyPrint();
				}
			});
		};
		if(__opts.pageButtons){
			if(paginationButtons.length>0)paginationButtons.push('-');
			$.each(__opts.pageButtons,function(i,conf){
				if(typeof conf == 'string')
					paginationButtons.push('-');
				else{
					conf.icon = parseIconFromButton(conf);
					paginationButtons.push(conf);
				}

			});
		};

		$.hotkeys.add('Alt+home',function(){
			$(_thisGrid).parent().next('.pagination').find('.pagination-first').click();
		});
		$.hotkeys.add('Alt+pageup',function(){
			$(_thisGrid).parent().next('.pagination').find('.pagination-prev').click();
		});
		$.hotkeys.add('Alt+pagedown',function(){
			$(_thisGrid).parent().next('.pagination').find('.pagination-next').click();
		});
		$.hotkeys.add('Alt+end',function(){
			$(_thisGrid).parent().next('.pagination').find('.pagination-last').click();
		});
		if(setting.isLazyPagination ){
			paginationButtons.push({
				iconCls:'icon-sum',
				text:'总计',
				handler:function(){
					var queryParam = $(_thisGrid).datagrid('options').queryParams;
					queryParam.page = queryParam.page ||$(_thisGrid).datagrid('options').pageNumber ;
					queryParam.rows = queryParam.rows || $(_thisGrid).datagrid('options').pageSize;
					if(queryParam.lazyLoad)return;
					waiting();
					var totalUrl = "";
					if(setting.url.indexOf('core/getPage')>-1){
						totalUrl  = getDomain()+'/core/getPage.json';
					}else{
						totalUrl = setting.url;
					}
					apolloAjax({
						url:totalUrl,
						data:queryParam,
						success:function(r){
							$(_thisGrid).datagrid('getPager').find('#lazyCount').html('  共:'+r.total+'条记录');
							waiting('close');
						}
					});
				}
			});
		};
		var paginationParam ={
			displayMsg:'',
			showRefresh:setting.isShowFlush,
			beforePageText:'当前是第',
			afterPageText:'页',
			showPageList:true,
			displayMsg : '显示{from}到{to},共{total}记录',
			buttons:paginationButtons
		};
		if(setting.isLazyPagination){
			paginationParam.displayMsg='显示第{from}条到{to}条记录<span id="lazyCount"></span>';
		};
		if(setting.isShowFlush){
			paginationParam.onRefresh = function(num,size){
				var queryParam = $(_thisGrid).datagrid('options').queryParams;
				$(_thisGrid).datagrid('reload');
				/*apolloAjax({
				 url:(getDomain()+'/publicJson/clear.action?index='+queryParam.index)
				 });*/
			};
		};

		if(__opts.isMiniPagination){
			paginationParam.beforePageText='';
			paginationParam.afterPageText='/{pages}';
			paginationParam.showPageList=false;
			paginationParam.displayMsg='<span id="lazyCount"></span>';
		};
		if($(_thisGrid) && $(_thisGrid).length>0){
			$(_thisGrid).datagrid('getPager').pagination(paginationParam);
			if(__opts.height && __opts.height!="100%"){
				$(".datagrid-pager").attr("style","padding-bottom:20px");
			}
			
		}
		if(setting.isSearchOpen&&__opts.search){
			window.setTimeout(function(){
				$(_thisGrid).gridSearch(__opts.search,setting.queryParams,__opts.isMiniPagination,isSearchClose(),setting.beforeApolloSearch);
			},500);
		};
		return this;
	};


	$.fn.gridSearch = function(searchOpts,queryData,isMini,isCloseAble,beforeSearch){
		if(typeof isCloseAble == 'undefined')isCloseAble=true;
		var __gridSearch = this.parent().prev('.datagrid-search');
		if(!$(this).attr('searchId')){
			$(this).attr('searchId',Math.random());
		}
		__grid = this;
		if(isCloseAble && $(__grid).data('isGridSearchShow') && __gridSearch.length>0){
			__gridSearch.hide();
			$(__grid).data('isGridSearchShow',false);
			var disHeight = $(__grid).data('disHeight');
			__grid.parent().css({height:(__grid.parent().height()+disHeight)});
			var grid_body = $('.datagrid-body',__grid.parent());
			grid_body.css('height',(grid_body.height()+disHeight));
			return;
		};
		if(__gridSearch.length==0){
			var searchButtonWith = isMini?90:120;
			var allWidth = $(this).parent().parent().parent().width();
			var searchWidth=0;var disHeight = 30;
			var serachOptLength = 0;
			for(var each in searchOpts){
				if(searchOpts[each].type==null)searchOpts[each].type='TEXT';
				else searchOpts[each].type = searchOpts[each].type.toUpperCase();
				var type = searchOpts[each].type;
				if(typeof searchOpts[each].width == 'number') searchOpts[each].width = searchOpts[each].width +'px';
				var curWidth;
				switch(type){
					case 'DATE':
						if(typeof searchOpts[each].width == 'undefined'){
							searchOpts[each].width = '100px';
						};
						serachOptLength++;
					case 'CALENDAR':
						if(typeof searchOpts[each].width == 'undefined'){
							searchOpts[each].width = '100px';
						};
						serachOptLength++;
					case 'DATETIMER':
						if(typeof searchOpts[each].width == 'undefined'){
							searchOpts[each].width = '125px';
						};
						curWidth = 2*parseInt(searchOpts[each].width.replace('px',''),10);
						serachOptLength = serachOptLength+2;
						break;
					case 'SELECT':
						if(typeof searchOpts[each].width == 'undefined'){
							searchOpts[each].width = '100px';
						};
						serachOptLength++;
					case 'TREE':
						if(typeof searchOpts[each].width == 'undefined'){
							searchOpts[each].width = '100px';
						};
						curWidth = parseInt(searchOpts[each].width.replace('px',''),10);
						serachOptLength++;
						break;
					default:
						if(typeof searchOpts[each].width == 'undefined'){
							searchOpts[each].width = '75px';
						};
						curWidth = parseInt(searchOpts[each].width.replace('px',''),10);
						serachOptLength++;
				}
				//alert((allWidth - searchButtonWith - searchWidth - curWidth));
				if(allWidth - searchButtonWith - searchWidth < curWidth ){
					searchWidth = 0;
					disHeight += 30;
				};
				searchWidth = searchWidth+curWidth + 3;
			};
			$(this).data('disHeight',disHeight);
			var lineNum = 1;
			if((allWidth-searchButtonWith) >850 && (allWidth-searchButtonWith)<1000){
				lineNum = Math.ceil(serachOptLength/2/5);
			}else if((allWidth-searchButtonWith)>=1000 &&  (allWidth-searchButtonWith)<1200){
				lineNum = Math.ceil(serachOptLength/2/7);
			}
			__gridSearch = $('<div class="datagrid-search" style="height:'+(disHeight/lineNum-4)*lineNum+'px;padding:5px"></div>');
			var searchContent = $('<div style="float:left;width:'+(allWidth-searchButtonWith)+'px"/>').appendTo(__gridSearch);
			this.parent().before(__gridSearch);
			//$.each(searchOpts,function(elemt,opt){
			for(var elemt in searchOpts){
				var opt = searchOpts[elemt];
				var _searchType =  opt.type;
				_searchAll =  opt.searchAll==null?true:opt.searchAll;
				switch(_searchType){
					case 'DATETIMER':
						width = opt.width==null?'100px':opt.width;
						$('<input id="'+elemt+'_b" name="'+elemt+'" title="'+opt.title+' 开始" value="'+opt.title+' 开始" style="width:'+width+'" '+(opt.className?('class="'+opt.className+'"'):'')+'/>')
							.appendTo(searchContent).wrap('<div style="margin-left:3px;margin-bottom:2px;float:left;"><label>'+opt.title+'开始：</label></div>')
							.click(function(){
								if(this.value == $(this).attr('title'))$(this).val('');
							}).blur(function(){
							if(this.value == '')this.value = $(this).attr('title');
						}).datetimebox({editable:opt.editable}).datetimebox("setValue", "");
						//.datePicker((opt.timeStyle==null?{format:'yyyy-MM-dd'}:{format:opt.timeStyle}));
						$('<input id="'+elemt+'_e" name="'+elemt+'" title="'+opt.title+' 结束" value="'+opt.title+' 结束" style="width:'+width+'"  '+(opt.className?('class="'+opt.className+'"'):'')+'/>')
							.appendTo(searchContent).wrap('<div style="margin-left:3px;margin-bottom:2px;float:left;"><label>'+opt.title+'结束：</label></div>')
							.click(function(){
								if(this.value == $(this).attr('title'))$(this).val('');
							}).blur(function(){
							if(this.value == '')this.value = $(this).attr('title');
						}).datetimebox({editable:opt.editable}).datetimebox("setValue", "");
						break;
					case 'DATE' :
						width = opt.width==null?'100px':opt.width;
						$('<input id="'+elemt+'_b" name="'+elemt+'" title="'+opt.title+' 开始" value="'+opt.title+' 开始" style="width:'+width+'" '+(opt.className?('class="'+opt.className+'"'):'')+'/>')
							.appendTo(searchContent).wrap('<div style="margin-left:3px;margin-bottom:2px;float:left;"><label>'+opt.title+'开始：</label></div>')
							.click(function(){
								if(this.value == $(this).attr('title'))$(this).val('');
							}).blur(function(){
							if(this.value == '')this.value = $(this).attr('title');
						}).datebox({dateFmt:'yyyy-MM-dd'}).datetimebox({editable:opt.editable}).datebox("setValue", "");
						//.datePicker((opt.timeStyle==null?{format:'yyyy-MM-dd'}:{format:opt.timeStyle}));
						$('<input id="'+elemt+'_e" name="'+elemt+'" title="'+opt.title+' 结束" value="'+opt.title+' 结束" style="width:'+width+'"  '+(opt.className?('class="'+opt.className+'"'):'')+'/>')
							.appendTo(searchContent).wrap('<div style="margin-left:3px;margin-bottom:2px;float:left;"><label>'+opt.title+'结束：</label></div>')
							.click(function(){
								if(this.value == $(this).attr('title'))$(this).val('');
							}).blur(function(){
							if(this.value == '')this.value = $(this).attr('title');
						}).datebox({dateFmt:'yyyy-MM-dd'}).datetimebox({editable:opt.editable}).datebox("setValue", "");
						break;
					case 'CALENDAR' :
						if(!opt.dateFormatter)opt.dateFormatter = 'yyyy-MM-dd';
						width = opt.width==null?'100px':opt.width;
						$('<input id="'+elemt+'" name="'+elemt+'" title="'+opt.title+'检索" value="'+opt.title+'检索" style="width:'+width+'" '+(opt.className?('class="'+opt.className+'"'):'')+'/>').appendTo(searchContent).wrap('<div style="margin-left:3px;margin-bottom:2px;float:left;"><label>'+opt.title+'：</label></div>').datebox({formatter:function(date){
							return date.format(opt.dateFormatter);
						}});
						break;
					case 'SELECT':
						_search = $('<select id="'+elemt+'" title="'+opt.title+'检索"  style="height:22px;"  '+(opt.className?('class="'+opt.className+'"'):'')+'></select>');
						if(_searchAll)opt.first ='全部';
						if(typeof opt.filterParent == 'string'){
							opt.filterParent = __gridSearch.find(opt.filterParent);
						};
						_search.appendTo(searchContent).option(opt);
						_search.wrap('<div style="margin-left:3px;margin-bottom:2px;float:left;"><label>'+opt.title+'：</label></div>');
						break;
					case 'TREE':
						_search = $('<input id="'+elemt+'" title="'+opt.title+'检索" value="'+opt.title+'检索" style="height:22px;"  '+(opt.className?('class="'+opt.className+'"'):'')+'/>');
						_search.appendTo(searchContent).wrap('<div style="margin-left:3px;margin-bottom:2px;float:left;"><label>'+opt.title+'：</label></div>');
						var _treeUrl;
						if(!opt.url){
							_treeUrl = getDomain()+'/publicJson/tree.action?treeRichData=false';
							$.each(opt.data,function(key,value){
								_treeUrl += '&'+key+'='+value;
							});
							if(opt.treeTextKey)_treeUrl += '&treeTextKey='+opt.treeTextKey;
							if(opt.treeKey)_treeUrl += '&treeKey='+opt.treeKey;
							if(opt.treeParentKey)_treeUrl += '&treeParentKey='+opt.treeParentKey;
							if(opt.treeRootShow)_treeUrl += '&treeRootShow='+opt.treeRootShow;
						}else _treeUrl = opt.url;
						if(!opt.width) opt.width = 100;
						_search.combotree({
							url:_treeUrl,
							multiple:opt.multiple,
							width:opt.width
						}).before('&nbsp;');

						break;
					default:
						width = opt.width==null?'90px':opt.width;
						if(opt.defultValue == null)opt.defultValue = opt.title +"检索";
						$('<label>'+opt.title +'：</label><input id="'+elemt+'" title="'+opt.title+'检索" style="width:'+width+'" value="'+opt.defultValue+'" '+(opt.className?('class="'+opt.className+'"'):'')+'/>')
							.click(function(){
								if($(this).val() == $(this).attr('title')){
									$(this).val('');
								}
							}).mouseout(function(){
							if($(this).val() == ''){
								$(this).val($(this).attr('title'));
							}
						}).keyup(function(){
							if($(this).val().indexOf($(this).attr('title'))>-1){
								$(this).val($(this).val().replace($(this).attr('title'),''));
							}
						}).appendTo(searchContent).wrap('<div style="margin-left:3px;margin-bottom:2px;float:left;"></div>');
						if(opt.event){//增加对搜索表单的事件控制
							for(var ev in opt.event){
								$('#'+elemt,searchContent).bind(ev,opt.event[ev]);
							}
						}
				};
			};

			if(isCloseAble){
				$('<span style="float:right;padding-right:8px;padding-left:2px;" title="关闭搜索框"><img src="'+getDomain()+'/Apollo/themes/default/images/tabs_close.gif"/></span>').click(function(){
					__gridSearch.hide();
					$(__grid).data('isGridSearchShow',false);
					__grid.parent().css({height:(__grid.parent().height()+disHeight)});
					var grid_body = $('.datagrid-body',__grid.parent());
					grid_body.css('height',(grid_body.height()+disHeight));
					$.messager.show({
						title:'温馨提示',
						msg:'通过组合键<b style="color:red">Shift+F</b>可调出搜索栏',
						timeout:5000,
						showType:'slide'
					});
				}).appendTo(__gridSearch);
			}else{
				$('<span style="float:right;padding-right:8px;padding-left:2px;">&nbsp;</span>').appendTo(__gridSearch);
			}
			var linkButtonParam;
			if(isMini){
				linkButtonParam={
					text:'查'
				};
			}else{
				linkButtonParam={
					iconCls:"icon-search"
				};
			};
			$('<a href="javascript:void(0)" searchId="'+$(this).attr('searchId')+'">搜索</a>').click(function(){
				if(typeof beforeSearch == 'function'){
					if(!beforeSearch.call()){
						alert("不满足查询条件！");
						return;
					}
				}

				var __grid = $(this).closest('.datagrid-search').next().children('*[searchId="'+$(this).attr('searchId')+'"]');
				var searchQueryData = $(__grid).datagrid('options').queryParams;
				if(searchQueryData==null)return;
				var data = $(this).parent().parent().getData(true);
				var isBegin;
				for(var each in searchOpts){//将日期类型数据先清除，接下来特殊处理直接增加数据值
					if(searchOpts[each].type == 'DATE' || searchOpts[each].type == 'DATETIMER' ){
						delete searchQueryData[each];
					}
				}
				//$.each(data,function(key,value){
				for(var key in data){

					var value = data[key];
					if(value){
						value = value.replace(/(^\s*)|(\s*$)/g,'');
					}

					isBegin = "";
					if(key.indexOf('_b')>-1 && value){
						isBegin = true;
					}
					if(key.indexOf('_e')>-1 && value){
						isBegin = false;
					}
					key = key.replace(/\_b$|\_e$/g,'');

					if(typeof value == 'object') value = value.join('|');//XX Add Multi Tree Data XX 2011-09-15
					value = value.replace(/-全部| 开始| 结束|检索$/g,'');
					var flag = (''+value).replace(new RegExp(searchOpts[key].title,"gm"),'');
					if(flag =='' || flag ==';'){
						if(searchOpts[key].type != 'DATE' && searchOpts[key].type != 'DATETIMER'){
							delete searchQueryData[key];
						}
					}else{
						if(typeof searchOpts[key].method == 'function'){
							searchOpts[key].method(key,value,searchQueryData);
						}else{

							switch(searchOpts[key].type){
								case 'TREE' :
									searchQueryData[key] = value.replace(/,/g,'|');
									break;
								case 'DATETIMER' :
									if(value&&value.length>0 && searchOpts[key].title &&value!=searchOpts[key].title){
										if(value.indexOf(";")>-1){
											value = value.split("\\;")[1];
										}
										if(isBegin){
											if(searchQueryData[key]!=null && searchQueryData[key]){
												searchQueryData[key] = searchQueryData[key]+'&'+value;
											}else if(searchQueryData[key]!="undefined"){
												searchQueryData[key+"_b"] = value;
											}
										}else{
											if(searchQueryData[key]!=null && searchQueryData[key]){
												searchQueryData[key] = searchQueryData[key]+'&'+value;
											}else if(searchQueryData[key]!="undefined"){
												searchQueryData[key+"_e"] = value;
											}
										}

									}
									break;
								case 'DATE' :
									/*
									 sData = [];
									 tmpVal = value.split(';');
									 //_fmt = searchOpts[key].format == null?"TO_DATE":searchOpts[key].format;
									 //parseDateStyleToSQL
									 if(tmpVal[0]&&tmpVal[0]!=searchOpts[key].title&&tmpVal[0]!='')sData.push(">="+parseDateStyleToSQL(tmpVal[0]));
									 if(tmpVal[1]&&tmpVal[1]!=searchOpts[key].title&&tmpVal[1]!='')sData.push("<="+parseDateStyleToSQL(tmpVal[1],true));
									 if(sData.length>0)searchQueryData[key] = sData.join('&');
									 */
									if(value&&value.length>0&&value!=searchOpts[key].title){
										if(value.indexOf(";")>-1){
											value = value.split("\\;")[1];
										}

										var vv ;//=  (isBegin?'>=':'<=')+parseDateStyleToSQL(value);
										if(isBegin){
											vv = value+" 00:00:00";
											if(searchQueryData[key]!=null && searchQueryData[key]){
												searchQueryData[key] = searchQueryData[key]+'&'+vv;
											}else if(searchQueryData[key]!="undefined"){
												searchQueryData[key+"_b"] = vv;
											}
										}else if(!isBegin){
											vv = value+" 23:59:59";
											if(searchQueryData[key]!=null && searchQueryData[key]){
												searchQueryData[key] = searchQueryData[key]+'&'+vv;
											}else if(searchQueryData[key]!="undefined"){
												searchQueryData[key+"_e"] = vv;
											}
										};
									}
									break;
								case 'CALENDAR' :
									if(value&&value.length>0&&value!=searchOpts[key].title){
										searchQueryData[key] = value;
									}
									break;
								/*case 'DATETIMER' :
								 sData = [];
								 tmpVal = value.split(';');
								 //_fmt = searchOpts[key].format == null?"TO_TIMESTAMP":searchOpts[key].format;
								 if(tmpVal[0]&&tmpVal[0]!=searchOpts[key].title&&tmpVal[0]!='')sData.push(">="+parseDateStyleToSQL(tmpVal[0]));
								 if(tmpVal[1]&&tmpVal[1]!=searchOpts[key].title&&tmpVal[1]!='')sData.push("<="+parseDateStyleToSQL(tmpVal[1]));
								 if(sData.length>0)searchQueryData[key] = sData.join('&');
								 break;*/
								case 'SELECT' :
									searchQueryData[key] = value;
									break;
								default :
									if(/\*|\+|-|\||&|>|</g.test(value)){
										value = value.replace(/ /g,'').replace(/\+/g,'&').replace(/-/g,'&!').replace(/\*/g,'%');
										if(/>|</g.test(value)){
											value = value.replace(/%/g,'');
										}
										searchQueryData[key] = value;
									}else {
										//searchQueryData[key] = value;
										if(searchOpts[key].equals)
											searchQueryData[key] = value;
										else
											searchQueryData[key]= '%'+value+'%';
									}
									if(searchQueryData[key])searchQueryData[key] = searchQueryData[key].replace(searchOpts[key].title,'');
							}
						}
					}
				};
				try{
					__grid.datagrid('getPager').pagination({pageNumber:1});
					__grid.datagrid('options').pageNumber = 1;
				}catch(e){
				};
				delete searchQueryData['lazyLoad'];//特殊控制参数，用来屏蔽第一次加载不展示所有数据的。
				$.each(searchQueryData,function(key,item){
					if(searchOpts[key]){
						if(searchOpts[key].type =="DATE" || searchOpts[key].type =="DATETIMER"){
							var dateParam = searchQueryData[key];
							delete searchQueryData[key];
							if(dateParam.indexOf("_e")>-1){
								if( dateParam.indexOf("_e") == (dateParam.length-2)){
									searchQueryData[key+"_b"]=dateParam.substring(0,dateParam.indexOf("&"));
								}else{
									searchQueryData[key+"_b"]=dateParam.substring(dateParam.lastIndexOf("&")+1,dateParam.length);
								}
							}
						}
					}
				});
				__grid.datagrid("reload",searchQueryData);
			}).linkbutton(linkButtonParam).appendTo(__gridSearch).wrap('<div style="float:right" class="searchSubmit"></div>');


			__gridSearch.children(':input').addClass('defalut').keyup(function(){
				if($(this).val() == $(this).attr('title')){
					$(this).addClass('defalut');
				}else{
					$(this).removeClass('defalut');
				}
			});
			$.hotkeys.add('Ctrl+return',function(){
				if($(__grid).data('isGridSearchShow'))__gridSearch.find('a').click();
			});
		};

		if(isMini)__gridSearch.show();
		else __gridSearch.show('slow');

		var disHeight = $(__grid).data('disHeight');
		$(__grid).data('isGridSearchShow',true);
		var pHeight = (__grid.parent().height()-disHeight);
		__grid.parent().css({height:pHeight});
		var grid_body = $('.datagrid-body',__grid.parent());
		var bHeight = (grid_body.height()-disHeight);
		grid_body.css('height',bHeight);
		$(__grid).data('lastHeight',{'pHeight':pHeight,'bHeight':bHeight});
	};


	$.fn.gridDownResult = function(opts){
		if(opts.data){
			delete opts.data.rows;
			delete opts.data.sort;
		};
		/**暂时屏蔽了自定义下载带来的其他问题**/
		waiting();
		opts.isAllElemt = false;
		$downloadResult(opts);
		return;

		$.messager.confirm('下载提示', '您是否使用默认下载方式?', function(r){
			if (r){
				opts.isAllElemt = false;
				$downloadResult(opts);
			}else{
				_ui_downLoad = $(this).next('#ui_downLoad');
				if(_ui_downLoad.length == 0){
					_ui_downLoad = $('<div id="ui_downLoad" icon="icon-download"><div >'+
						'<table class="apollo-form"><tr><th>文件名称</th><td><input id="filename"  type="text" class="easyui-validatebox" name="filename" required="true"></td></tr>'+
						'<tr><th>文件类型</th><td><select id="type"><option value="csv">Excel格式</option><option value="txt">文本格式</option></select></td></tr>'+
						'<tr><th>是否显示表头</th><td><input type="radio" name="isTitleShow" value="true" checked>是&nbsp;&nbsp;<input type="radio" name="isTitleShow" value="false">否</td></tr>'+
						'<tr><td colspan="2" style="text-align:center"><input type="radio" name="isAllElemt" value="true">下载全部字段&nbsp;&nbsp;<input type="radio" name="isAllElemt" value="false" checked>下载可见字段</td></tr>'+
						'</table></div></div>');
					_ui_downLoad.dialog({
						title:'表格数据 - 下载',
						width:400,
						buttons:[{
							text:'下 载',
							iconCls:'icon-ok',
							handler:function(){
								var data = $('#ui_downLoad').getData();
								data.isTitleShow = data.isTitleShow == 'false'?false:true;
								data.isAllElemt	 = data.isAllElemt == 'false'?false:true;
								data.fileName = data.filename+'.'+data.type;
								delete data.type;
								$downloadResult($.extend(opts,data));
								_ui_downLoad.dialog('close');
							}
						},{
							text:'取 消',
							iconCls:'icon-cancel',
							handler:function(){
								_ui_downLoad.dialog('close');
							}
						}]
					}).insertAfter(this);
				}
				_ui_downLoad.dialog('open');
			}
		});
	};

	/**
	 * 表格标题右键菜单
	 */
	$.fn.headContextMenu = function(_columns,poi){
		if(!poi)return;
		_thisGridTarget  = this;
		_ui_gridColumn = $(this).next('#datagrid_contextmenu');
		if(_ui_gridColumn.length == 0){
			_ui_gridColumn = $('<div id="datagrid_contextmenu"  style="width:150px;z-index:1000"></div>');
			__columnCache={};
			$.each(_columns,function(i,opt){
				__columnCache[opt.title] = opt.field;
				// column="'+opt.field+'"
				_ui_gridColumn.append('<div iconCls="'+(opt.hidden?'icon-empty':'icon-ok')+'">'+opt.title+'</div>');
			});
			_ui_gridColumn.menu({
				onClick: function(item){
					if(item==null || typeof item.iconCls == 'undefined')return;
					if (item.iconCls=='icon-ok'){
						_thisGridTarget.datagrid('hideColumn', __columnCache[item.text]);
						_thisGridTarget.next('#datagrid_contextmenu').menu('setIcon', {
							target: item.target,
							iconCls: 'icon-empty'
						});
					}else{
						_thisGridTarget.datagrid('showColumn', __columnCache[item.text]);
						_thisGridTarget.next('#datagrid_contextmenu').menu('setIcon', {
							target: item.target,
							iconCls: 'icon-ok'
						});
					}
				}
			}).insertAfter(_thisGridTarget);
		};
		_ui_gridColumn.menu('show',poi);
	};

	/**
	 @constructor
	 @description	将Json对象的值设置到某个区域内所有表单中<br>
	 支持常见所有表单值的设定，多值时 Json中对应的value以“;”分开
	 @param {Object} _data	Json对象值｛key:value｝
	 @param {Object}	formatParam 表单设值格式话参数 可以为null
	 @example
	 $('form').setData(
	 {
         id:'dd',name:'Janson',
         pid:'12;213' //多值以“;”分开
     },{ //格式化参数
			readOnly:false,//设置表单内容为查看模式
			format:{//对设置值时进行特殊格式化处理；支持对表单ID或者表单类型统一处理
				'name':function(thisObj){//对表单ID为"name"的表单特殊处理
					thisObj.value = 'self';
				},'checkbox':function(thisObj){//对表单中每一个"checkbox"都进行特殊处理
					thisObj.checked = false;
				}
			}
		}
	 );
	 */
	$.fn.setData = function(_data,_formatParam){
		var formatParam = $.extend({
			clear:true,//情况表单所有内容
			isApolloData:false,//表单所有数据KEY均为大写
			isFormOnly:true,//仅仅将数据展示在表单内
			readOnly:false,//将表单设置成只查看状态
			filter:[],//过滤不操作的表单内容
			format:null//数据值设置自定义
		},_formatParam);
		if(formatParam.clear)$(this).form('clear');//采用easy-ui的form clear 方法清除数据
		var isIe6 = isIE6();
		var setMultiSelectValue = function(_select,value){
			_select.find('option').each(function(){
				if(value.indexOf(';'+$(this).val()+';')>-1){
					if(isIe6){
						try{
							this.selected = true;
						}catch(e){}
					}else{
						$(this).attr('selected','selected') ;
					}
				}
			});
			_select.change();
		};
		var data = {};
		if(formatParam.isApolloData){
			for(each in _data)data[each.toUpperCase()] = _data[each];
		}else{
			data = $.extend({},_data);
		};
		if(data == null)return;
		var multiKey = [];
		this.find('span').each(function(){
			var _dValue = '';
			_thisId = $(this).attr('id');
			_thisName = $(this).attr('name');
			_thisType = $(this).attr('type');
			if((!_thisId&&!_thisName)||_thisType=='button')return;
			key = _thisId||_thisName;
			if(formatParam.isApolloData)key = key.toUpperCase();
			_dValue = data[key];
			if(_dValue == null||formatParam.filter.contains(key))return;

			$(this).text(_dValue);
		});
		this.find(':input').each(function(){
			var _dValue = '';
			_thisId = $(this).attr('id');
			_thisName = $(this).attr('name');
			_thisType = $(this).attr('type');
			if((!_thisId&&!_thisName)||_thisType=='button')return;
			key = _thisId||_thisName;
			if(formatParam.isApolloData)key = key.toUpperCase();
			_dValue = data[key];
			if(_dValue == null||formatParam.filter.contains(key))return;

			if(formatParam.format!=null&&
				(typeof formatParam.format[_thisType] == 'function'||typeof formatParam.format[_thisId] == 'function')){
				if(typeof formatParam.format[_thisType] == 'function'){
					formatParam.format[_thisType](this,_dValue);
				}else{formatParam.format[_thisId](this,_dValue);};
			}else{
				if(_dValue!=null){
					if($(this).is('.combo-f')){
						if($(this).combo('options').multiple)
							$(this).combo('setValues',typeof _dValue == 'object'?_dValue:_dValue.split(","));
						else
							$(this).combo('setValue',_dValue);
					}if($(this).is('.combobox-f')){
						if($(this).combobox('options').multiple)
							$(this).combobox('setValues',typeof _dValue == 'object'?_dValue:_dValue.split(","));
						else
							$(this).combobox('setValue',_dValue);
					}else if($(this).is('.combotree-f')){
						if($(this).combotree('options').multiple)
							$(this).combotree('setValues',typeof _dValue == 'object'?_dValue:_dValue.split(","));
						else
							$(this).combotree('setValue',_dValue);
					}else if($(this).is('.datebox-f')){
						$(this).datebox('setValue',_dValue);
					}else if($(this).is('.datetimebox-f')){
						$(this).datetimebox('setValue',_dValue);
					}else if($(this).is('.easyui-numberbox')){
						$(this).numberbox('setValue',_dValue);
					}else{
						if(_thisType == 'radio' || _thisType == 'checkbox'){
							var checkValue = ';'+_dValue+';';
							if(_dValue!=null&&checkValue.indexOf(';'+this.value+';') > -1)
								$(this).attr('checked','checked');
						}else if(_thisType=="select-one"||_thisType=="select-multiple"){
							var checkValue = ';'+_dValue+';';
							if(_dValue!=null)setMultiSelectValue($(this),checkValue);
						}else {
							if(typeof _dValue =='number' ||( typeof _dValue =='string' && _dValue.toUpperCase()!='NULL'))$(this).val(_dValue);
						}
					}
				}
			};
			if(!formatParam.isFormOnly)multiKey.push(key);
		});

		if(!formatParam.isFormOnly){
			for(var i=0;i<multiKey.length;i++){
				delete data[multiKey[i]];
			};
			var _targetForm = this;
			for(each in data){
				$('#'+(formatParam.isApolloData?each.toLowerCase():each),_targetForm).html(data[each]);
			}
		};

		$(this).form('validate');
		if(formatParam.readOnly){
			this.find(':input').each(function(){
				_thisId = $(this).attr('id');
				_thisName = $(this).attr('name');
				_thisType = $(this).attr('type');
				if(!_thisId&&!_thisName)return;
				if(formatParam.format!=null&&(typeof formatParam.format[_thisType] == 'function'
					||typeof formatParam.format[_thisId] == 'function')){
					if(typeof formatParam.format[_thisType] == 'function'){
						formatParam.format[_thisType](this);
					}else{
						formatParam.format[_thisId](this);
					}
				}else{
					$(this).attr('disabled','true');
					/*
					 if(_thisType == 'radio' || _thisType == 'checkbox'){
					 }else if(_thisType=="select-one"||_thisType=="select-multiple"){
					 $(this).after($(this).find(':selected').text()).remove();
					 }else{
					 if(_thisType != 'hidden' && _thisType != 'button')$(this).after($(this).val()).remove();;
					 }
					 */
				}
			});
			{
				$(this).find('.combobox-f').combobox('disable');
				$(this).find('.combotree-f').combotree('disable');
				$(this).find('.datebox-f').datebox('disable');
				$(this).find('.datetimebox-f').datetimebox('disable');
				$(this).find('.easyui-numberbox').numberbox('disable');
			}
		}else{
			this.find(':input').each(function(){
				$(this).removeAttr('disabled');
			});
			{
				$(this).find('.combobox-f').combobox('enable');
				$(this).find('.combotree-f').combotree('enable');
				$(this).find('.datebox-f').datebox('enable');
				$(this).find('.datetimebox-f').datetimebox('enable');
				$(this).find('.easyui-numberbox').numberbox('enable');
			}
		}
		return this;
	};
	/**
	 @constructor
	 @description 将该区域下所有表单的值组成Json对象获取
	 @param {boolean} fullData //设置是否需要过滤掉值为null或者""的对象值<br>
	 fullData = true	获取所有值<br>
	 fullData = false||null 将过滤掉 值为null或者""的值
	 @param {boolean} isSensitiveCheck
	 */
	$.fn.getData = function(fullData,isSensitiveCheck,isCheckScript){
		if(typeof isCheckScript == 'undefined')isCheckScript=true;
		if(!$(this).form('validate'))return null;
		var tmpJson = {};
		var getMultiSelectValue = function(key,_select){
			_select.find('option').each(function(){
				if(this.selected){
					if(tmpJson[key]==null)
						tmpJson[key] = $(this).val();
					else
						tmpJson[key] += ';'+$(this).val();
				}
			});
		};
		this.find(':input').each(function(){
			_thisType = $(this).attr('type');
			var dataKey = $(this).attr('name')||$(this).attr('id');
			if(dataKey==null || dataKey =='' || $(this).is('.combo-value'))return;
			var isCombo = true;
			if($(this).is('.combo-f')){
				if($(this).combo('options').multiple)
					tmpJson[dataKey] = $(this).combo('getValues').join(',');
				else
					tmpJson[dataKey] = $(this).combo('getValue');
			}else if($(this).is('.combobox-f')){
				if($(this).combobox('options').multiple){//XXX
					tmpJson[dataKey] = $(this).combobox('getValues').join(',');
				}else{
					tmpJson[dataKey] = $(this).combobox('getValue');
				}
			}else if($(this).is('.combotree-f')){
				if($(this).combotree('options').multiple){//XXX
					tmpJson[dataKey] = $(this).combotree('getValues').join(',');
				}else{
					tmpJson[dataKey] = $(this).combotree('getValue');
				}
				//tmpJson[dataKey] = $(this).combotree('getValue');
			}else if($(this).is('.datebox-f')){
				tmpJson[dataKey] = $(this).datebox('getValue');
			}else if($(this).is('.datetimebox-f')){
				tmpJson[dataKey] = $(this).datetimebox('getValue');
			}else if($(this).is('.easyui-numberbox')){
				tmpJson[dataKey] = $(this).numberbox('getValue');
			}else{
				if(_thisType == 'radio' || _thisType == 'checkbox'){
					if(this.checked){
						if(tmpJson[dataKey]==null){
							tmpJson[dataKey] = $(this).val();
						}else{
							tmpJson[dataKey] += ';'+$(this).val();
						}
					}
				}else if(_thisType=="select-multiple"){
					getMultiSelectValue(dataKey,$(this));
				}else if(_thisType=="select-one"){//XXX  baoft
					var tVal = $(this).val();
					if(tVal!=null&&tVal.length>0){
						tmpJson[dataKey] = tVal;
					}else{
						tmpJson[dataKey] = tVal;
					};

				}else{
					// type attribute of input tag [button;checkbox;file;hidden;password;radio;reset;submit;text]
					if('button;reset;submit'.indexOf(_thisType)==-1){
						if(fullData){
							var tVal = $(this).val();
							if(tmpJson[dataKey]==null)
								tmpJson[dataKey] = tVal;
							else{
								if(tmpJson[dataKey] && !"hidden".indexOf(_thisType)>-1){
									tmpJson[dataKey] = tVal;
								}else{
									tmpJson[dataKey] = tmpJson[dataKey]+';'+tVal;
								}
							}
						}else{
							var tVal = $(this).val().replace(/^ | $/g,'');
							if(tVal!=null&&tVal.length>0){
								if(tmpJson[dataKey]==null)
									tmpJson[dataKey] = tVal;
								else tmpJson[dataKey] = tmpJson[dataKey]+';'+tVal;
							}
						}
					}
				}
			};
			if(!fullData && typeof tmpJson[dataKey] == 'string' && tmpJson[dataKey].replace(/^ | $/g,'').length ==0)delete tmpJson[dataKey];
		});

		//if(isCheckScript)tmpJson = checkScript(tmpJson);//XXX 暂时不需要处理过滤JS文本

		if(!isSensitiveCheck
			&& typeof sensitiveCheckData == 'function'
			&& sensitiveCheckData.call(this,tmpJson)){//兼容FT敏感数据修改
			return null;
		};
		return tmpJson;
	};

	/**
	 @constructor
	 @description	动态Select元素值设定<br>
	 支持静态值，ajax数据库查询值等数据源<br>
	 支持SELECT联动
	 @param {Object} opt 具体参数设定

	 @example
	 基本值设定Demo：
	 ====静态数组====
	 例1：select的text和value一致时可用
	 $('#selectId').option({
			option:["1","2","3"]
		})

	 例2：{key:value}结构数据可用
	 $('#selectId').option({
			option:{value1:text1,value2:text2,value3:text3...}
		})

	 例3：对象数组可用
	 $('#selectId').option({
			option:[{text:'显示1',value:'值1'},{text:'显示2',value:'值2'}...]
		})

	 例4:对象数组自定义显示结构
	 $('#selectId').option({
			text:'name',value:'id',
			option:[{id:'显示1',name:'值1'},{id:'显示2',name:'值2'}...]
		})

	 例5:对象数组自定义方法
	 $('#selectId').option({
			text:function(data){//data为数组中的每个对象数据
				return '=='+data['name']+'==';
			},value:function(data){
				return data['id']+'%';
			},
			option:[{id:'显示1',name:'值1'},{id:'显示2',name:'值2'}...]
		})

	 例6：ajax数据库获取option值
	 $('#selectId').option({
			text:'ID',name:'VALUE',//该处值为大写，ajax方式获取数组中的对象的KEY均为大写
			data:{
				index:'sqlConfig',//获取
				//other sql param
			}
		})

	 例7：联动操作(支持N级联动操作)
	 $('#selectId').option({
			text:'ID',name:'VALUE',//该处值为大写，ajax方式获取数组中的对象的KEY均为大写
			data:{
				index:'sqlConfig',//获取
				//other sql param
			},
			filterParent:'#fatherDomId',//父选择框的ID 最多递归往上找5层找其父选择框
			filterParentWith:'pid'//父选择框选定值后，筛选该数组对象中key为pid的值和父类相等的值
		})

	 */
	$.fn.option = function(opt,param){
		if(typeof opt == 'string'){
			$.fn.option.methods[opt](this,param);
			return;
		};
		opt = $.extend(true,{text:'TEXT',value:'VALUE',__options:{}},opt);
		if(opt==null)return;
		var _select = this;
		var _filterParentValue;
		var isFilterParent = typeof opt.filterParent!='undefined' && typeof opt.filterParentWith!='undefined' ? true:false;
		var _defaultKey = "default";
		// 初始话Select值
		initSelect = function(){
			if(opt.first){
				if(typeof opt.first == 'string'){
					_select.html('<option  value="">'+opt.first+'</option>');
				}else if(typeof opt.first == 'object'){
					_select.html('<option value="'+(opt.first["value"])+'">'+(opt.first["text"])+'</option>');
				}else{
					_select.html('<option value="">请选择...</option>');
				}
			}else _select.html('');
		};
		__parseValue = function(key,data){
			if(typeof data == 'string') return data;
			else if(typeof key == 'string')return data[key];
			else if(typeof key == 'function')return key(data);
			else return "";
		};

		__checkFilterData = function(data){
			if(typeof opt.filter == 'undefined')return true;
			return opt.filter(data);
		};

		__formatOptions = function(_option){
			if(typeof _option.length == 'undefined'){//对象数据
				opt.__options[_defaultKey] = [];
				for(var value in _option){
					var text = _option[value];
					_data = {'value':value,'text':text};
					if(__checkFilterData(_data))
						opt.__options[_defaultKey] .push(_data);
				}
			}else{//数组数据
				if(isFilterParent){
					$.each(_option,function(i,data){
						if(__checkFilterData(data)&&data[opt.filterParentWith]!=null){
							if(opt.__options[data[opt.filterParentWith]]==null)opt.__options[data[opt.filterParentWith]]=[];
							opt.__options[data[opt.filterParentWith]].push({'value':__parseValue(opt.value,data),'text':__parseValue(opt.text,data)});
						}
					});
				}else{
					opt.__options[_defaultKey] = [];
					$.each(_option,function(i,data){
						if(__checkFilterData(data))
							opt.__options[_defaultKey].push({'value':__parseValue(opt.value,data),'text':__parseValue(opt.text,data)});
					});
				}
			};
			delete opt.option;
			if(typeof opt.appendItem!='undefined'){

			}
		};

		__parseOption = function(indexValue){
			initSelect();
			indexValue = indexValue == null ? _defaultKey : indexValue;
			if(opt.__options[indexValue] == null)return;
			var _selectDom = _select[0];
			$.each(opt.__options[indexValue],function(i,data){
				_selectDom.options.add(new Option(data.text,data.value));
			});
			_select.change();
		};

		__regParentFilter = function(){
			if(isFilterParent){
				var _filterParent=null;
				if(typeof opt.filterParent == 'object')
					_filterParent =  opt.filterParent;
				else if(typeof opt.filterParent == 'string'){
					_filterParent = $(_select).siblings(opt.filterParent);
					if(_filterParent.length==0){
						var deep = 0,_e = $(_select).parent();
						while(_filterParent.length==0&&deep<5){
							_filterParent = _e.find(opt.filterParent);
							_e = _e.parent();
							deep++;
						}
					}
				};
				_filterParent.change(function(){
					if(opt.first){
						if(typeof opt.first == 'string'){
							_select.html('<option  value="">'+opt.first+'</option>');
						}else if(typeof opt.first == 'object'){
							_select.html('<option value="'+(opt.first["value"])+'">'+(opt.first["text"])+'</option>');
						}else{
							_select.html('<option value="">请选择...</option>');
						}
					}else _select.html('');
					var pVale = _filterParent.val();
					if(pVale != null && pVale != ''&&opt.__options[pVale]!=null){
						var _selectDom = _select[0];
						if(typeof opt.beforeOptions =='function')opt.beforeOptions(_selectDom);
						$.each(opt.__options[pVale],function(i,data){
							_selectDom.options.add(new Option(data.text,data.value));
						});
						if(typeof opt.afterOptions =='function')opt.afterOptions(_selectDom);
					};
					_select.change();
				});
			}
		};

		if(typeof opt.option != 'undefined'){
			__formatOptions(opt.option);
			__parseOption();
			__regParentFilter();
		}else{
			_queryData = opt.index==null?opt.data:{index:opt.index};
			apolloAjax({
				url:opt.url,
				nopage:"1",
				index:opt.data.index
			},function(rb){
				__formatOptions(rb);
				__parseOption();
				__regParentFilter();
			},{async:false});
		}

	};
	$.fn.option.methods = {
		selected:function(_this,param){
			_select = _this.get(0);
			for(var i=0;i<_select.options.length;i++){
				if(_select.options[i].value == param){
					_select.options[i].selected = true;
				}else  _select.options[i].selected = false;
			}
		}
	};


	/* $.fn.datePicker = function(opt){
	 var _formatTimer = function(_fmt){
	 _f = {'年':'yyyy','月':'MM','日':'dd','时':'HH','分':'mm','秒':'ss'};
	 for(each in _f){
	 _fmt = _fmt.replace(each,_f[each]);
	 };
	 return _fmt;
	 };
	 var _default = {
	 errDealMode:2,
	 autoPickDate:false
	 };
	 var datePickerParam = $.extend({},_default,opt);
	 datePickerParam.el = $(this).attr('id');
	 datePickerParam.dateFmt = (opt!=null&&opt.format!=null)?_formatTimer(opt.format):'yyyy-MM-dd';
	 if(opt!=null&&opt.value!=null)$(this).val(opt.value);
	 $(this).click(function(){
	 WdatePicker(datePickerParam);
	 });
	 };
	 */
	$.hotkeys.add('Esc',function(){
		$('.panel-tool-close').click();
	});

	function isDate(value, formatString){
		formatString = formatString || "ymd";
		var m, year, month, day;
		switch(formatString){
			case "y-m-d" :
				value = value.replace(/-/g,'');

			case "ymd" :
				//alert(value);
				m = value.match(new RegExp("^((\\d{4})|(\\d{2}))([-./])(\\d{1,2})\\4(\\d{1,2})$"));
				if(m == null ) return false;
				day = m[6];
				month = m[5]*1;
				year =  (m[2].length == 4) ? m[2] : GetFullYear(parseInt(m[3], 10));
				break;
			case "dmy" :
				m = value.match(new RegExp("^(\\d{1,2})([-./])(\\d{1,2})\\2((\\d{4})|(\\d{2}))$"));
				if(m == null ) return false;
				day = m[1];
				month = m[3]*1;
				year = (m[5].length == 4) ? m[5] : GetFullYear(parseInt(m[6], 10));
				break;
			default :
				break;
		};
		if(!parseInt(month)) return false;
		month = month==0 ?12:month;
		var date = new Date(year, month-1, day);
		return (typeof(date) == "object" && year == date.getFullYear() && month == (date.getMonth()+1) && day == date.getDate());
		function GetFullYear(y){return ((y<30 ? "20" : "19") + y)|0;}
	};

	$.extend($.fn.validatebox.defaults.rules, {
		minLength: {
			validator: function(value, param){
				return value.length >= param[0];
			},
			message: '请输入至少{0}个字符'
		},
		maxLength: {
			validator: function(value, param){
				return value.length <= param[0];
			},
			message: '最多输入{0}个字符'
		},
		between:{
			validator: function(value, param){
				return parseInt(value) >= param[0] && parseInt(value) <= param[1];
			},
			message: '请输入介于{0}到{1}的数字'
		},
		qq: {
			validator: function(value, param){
				return /^[1-9]\d{4,8}$/.test(value);
			},
			message: '请正确输入QQ号码'
		},
		'int': {
			validator: function(value, param){
				if(value && value.length>1){
					return /^[1-9][0-9]*$/.test(value);///^\d+$/.test(value);
				}else{
					return /^[0-9]*$/.test(value);///^\d+$/.test(value);
				}
			},
			message: '请输入正整数'
		},
		'number': {
			validator: function(value, param){
				return /^[-\+]?\d+$/.test(value);
			},
			message: '请输入数字'
		},
		'mail': {
			validator: function(value, param){
				return  /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/.test(value);
			},
			message: '请输入邮箱地址'
		},
		'double': {
			validator: function(value, param){
				return  /^[-\+]?\d+(\.\d+)?$/.test(value);
			},
			message: '请输入双精度小数'
		},
		'pdouble': {
			validator: function(value, param){
				return  /^\d+(\.\d+)?$/.test(value);
			},
			message: '请输入正双精度小数'
		},
		english: {
			validator: function(value, param){
				return /^[A-Za-z]+$/.test(value);
			},
			message: '请输入英文字母'
		},
		chinese: {
			validator: function(value, param){
				return /^[\u0391-\uFFE5]+$/.test(value);
			},
			message: '请输入汉字'
		},
		zip: {
			validator: function(value, param){
				return /^[1-9]\d{5}$/.test(value);
			},
			message: '请输入邮政编码'
		},
		phone: {
			validator: function(value, param){
				return /^((\(\d{2,3}\))|(\d{3}\-))?(\(0\d{2,3}\)|0\d{2,3}-)?[1-9]\d{6,7}(\-\d{1,4})?$/.test(value);
			},
			message: '请输入电话号码'
		},
		mobile: {
			validator: function(value, param){
				return /^((13[0-9])|(15[0-9])|(18[0-9]))\d{8}$/.test(value);
			},
			message: '请输入手机号码'
		},
		safepass: {
			validator: function (value, param) {
				return !(/^(([A-Z]*|[a-z]*|\d*|[-_\~!@#\$%\^&\*\.\(\)\[\]\{\}<>\?\\\/\'\"]*)|.{0,3})$|\s/.test(value));
			},
			message: '密码由字母和数字或特殊符号组成，至少4位'
		},
		equalTo: {
			validator: function (value, param) {
				return value == $(param[0]).val();
			},
			message: '两次输入的字符不一至'
		},
		idcard: {
			validator: function(value, param){
				var date, Ai;
				var verify = "10x98765432";
				var Wi = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
				var area = ['','','','','','','','','','','','北京','天津','河北','山西','内蒙古','','','','','','辽宁','吉林','黑龙江','','','','','','','','上海','江苏','浙江','安微','福建','江西','山东','','','','河南','湖北','湖南','广东','广西','海南','','','','重庆','四川','贵州','云南','西藏','','','','','','','陕西','甘肃','青海','宁夏','新疆','','','','','','台湾','','','','','','','','','','香港','澳门','','','','','','','','','国外'];
				var re = value.match(/^(\d{2})\d{4}(((\d{2})(\d{2})(\d{2})(\d{3}))|((\d{4})(\d{2})(\d{2})(\d{3}[x\d])))$/i);
				if(re == null) return false;
				if(re[1] >= area.length || area[re[1]] == "") return false;
				if(re[2].length == 12){
					Ai = value.substr(0, 17);
					date = [re[9], re[10], re[11]].join("-");
				}
				else{
					Ai = value.substr(0, 6) + "19" + value.substr(6);
					date = ["19" + re[4], re[5], re[6]].join("-");
				}
				if(!isDate(date, "ymd")) return false;
				var sum = 0;
				for(var i = 0;i<=16;i++){
					sum += Ai.charAt(i) * Wi[i];
				}
				Ai +=  verify.charAt(sum%11);
				return (value.length ==15 || value.length == 18 && value == Ai);
			},
			message: '请输入身份证号码'
		},
		isdate : {//日期格式验证
			validator: function(value, param){
				return isDate(value,param[0]==null?'y-m-d':param[0]);
			},
			message: '请输入日期,格式为y-m-d'
		},
		uniqueness :{//字符唯一确定 跟数据库对接 param[0]=SQLIndex param[1]=验证字段
			validator: function(value, param){
				if(typeof __uniquenessValue == 'string'&&__uniquenessValue==value)return true;
				if(!param||param.length<1)return false;
				if(typeof __uniquenessCache=="undefined" || __uniquenessCache == null){
					tempCache = {};
					apolloAjax({
						index:param[0],
						success:function(result){
							$.each(result,function(i,data){
								tempCache[data[param[1].toUpperCase()]] = true;
							});
						}
					});
					__uniquenessCache = tempCache;
				}
				return !__uniquenessCache[value];
			},
			message: '该值已存在，请重新输入'
		},
		'agedate': {
			validator: function(value, param){
				return /^((0([1-9]{1}))|(1[1|2]))\/(([0-2]([1-9]{1}))|(3[0|1]))$/.test(value);
			},
			message: '请按格式输入。</br>例:05/01'
		},'price': {
			validator: function(value, param){
				return  /^[+]?\d+(\.\d{1,2})?$/.test(value);
			},
			message: '请输入大于0的数字,小数点后最多两位'
		},'uniPhone': {
			validator: function(value, param){
				return /^((13[0-4])|153|156|187|189|156|188)\d{8}$/.test(value);
			},
			message: '请输入联通手机号码'
		}
	});



	$.extend($.fn.datagrid.defaults.editors, {
		timespiner : {
			init : function(container, options) {
				var editor = $('<input type="text" class="datagrid-editable-input" >')
					.appendTo(container);
				editor.timespinner(options);
				editor.width(editor.outerWidth() - 19);
				editor.height(editor.outerHeight() -16);
				return editor;
			},
			destroy : function(target) {
				$(target).timespinner('destroy');
			},
			getValue : function(target) {
				var h = $(target).timespinner('getHours');
				var m = $(target).timespinner('getMinutes');
				return h+':'+m;
			},
			setValue : function(target, value) {
				var  hh=(value)/3600|0;
				value=parseInt(value)-hh*3600;
				if(parseInt(hh)<10){
					hh="0"+hh;
				}
				//得到分
				var   mm=value/60|0;
				if(parseInt(mm)<10){
					mm="0"+mm;
				}
				$(target).timespinner('setValue',hh+":"+mm);
			},
			resize : function(target, width) {
				var editor = $(target);
				if ($.boxModel == true) {
					editor.width(width - (editor.outerWidth() - editor.width())-19);
				} else {
					editor.width(width);
				}
			}
		}
	});


});
/***
 * 消息提示
 **/
function tipMsg(content,title,second){
	if(title==null)title = "温馨提示";
	if(second == null)second = 5000;
	else second = second*1000;
	$.messager.show({
		title:title,
		msg:content,
		timeout:second,
		showType:'slide'
	});
};

function detailGrid(_opts,_rows){
	var option = $.extend({

	},_opts);
	var stringBuffer = '<table class="detailViewClass"><tr>';
	for(var i = 0 ;i<_opts.columns[0].length;i++){
		var column = _opts.columns[0][i];
		stringBuffer += '<th '+(column['width']?('style="width:'+column['width']+'px"'):'')+'>'+column['title']+'</th>';
	};
	stringBuffer += '</tr>';
	for(var j=0;j<_rows.length;j++){
		var data = _rows[j];
		stringBuffer += '<tr>';
		for(var i = 0 ;i<_opts.columns[0].length;i++){
			var column = _opts.columns[0][i];
			var val = typeof column['formatter'] == 'function' ?
				column['formatter'].call(this,data[column['field']],data,i) : data[column['field']];
			stringBuffer += '<td ' + (column['align'] ? 'align="' + column['align'] + '"' : '') + '>'+val+'</td>';
		}
		stringBuffer += '</tr>';
	};
	return stringBuffer += '</table>';
};

function getFrame(name){
//	if($.browser.mozilla)
	if($.browser.msie)return document.frames[name].window;
	else return window.frames["lonlatSelectFrame"].window;
};

/**
 * filter all &lt;script&gt; tag ,avoid the scrpt injection
 * !! recusion
 * @param obj
 * @returns
 */
function checkScript(obj){
	function replaceScript(ss){
		if(typeof ss == 'string' ){
			ss = ss.replace(/<script[^>]*?>.*?\<\/script\>/ig,'');
		};
		return ss;
	};
	if(typeof obj == 'string'){
		return replaceScript(obj);
	}else if(typeof obj == 'object'){
		if(!obj){
			return obj;
		};
		if(obj.length){
			for(var i=0;i<obj.length;i++){
				var o = obj[i];
				obj[i] = replaceScript(o);
			};
			return obj;
		}else{
			for(var e in obj){
				var o = obj[e];
				if(typeof o == 'object'){
					obj[e] = checkScript(o);
				}else{
					obj[e] = replaceScript(o);
				}
			};
			return obj;
		}
	};
	return obj;
};


/**
 * comboSearch - jQuery EasyUI
 *
 */
$(function(){
	function select(target, value) {
		var opts = $.data(target, 'combobox').options;
		var data = $.data(target, 'combobox').data;
		if (opts.multiple) {
			var values = $(target).comboSearch('getVals');
			for (var i = 0; i < values.length; i++) {
				if (values[i][opts.valueField] == value[opts.valueField]) {
					return;
				}
			};
			values.push(value);
			setValues(target, values);
		} else {
			setValues(target, [value]);
		};
		for (var i = 0; i < data.length; i++) {
			if (data[i][opts.valueField] == value[opts.valueField]) {
				opts.onSelect.call(target, data[i]);
				return;
			}
		}
	};
	function unselect(target, value) {
		var opts = $.data(target, 'combobox').options;
		var data = $.data(target, 'combobox').data;
		var values = $(target).comboSearch('getVals');
		for (var i = 0; i < values.length; i++) {
			if (values[i][opts.valueField] == value[opts.valueField]) {
				values.splice(i, 1);
				setValues(target, values);
				break;
			}
		}
//		for (var i = 0; i < data.length; i++) {
//			if (data[i][opts.valueField] == value) {
//				opts.onUnselect.call(target, data[i]);
//				return;
//			}
//		}
	};
	function getVals(target) {
		var _obj = $(target, 'combobox').data("comboSearch");
		if(_obj == null || _obj.values == null)
			return [];
		return _obj.values;
	};
	function getValues(target){
		var opts = $.data(target, 'combobox').options;
		var _obj = $(target, 'combobox').data("comboSearch");
		var _val = "";
		if(_obj == null || _obj.values == null) {
			var combo = $.data(target, 'combo').combo;
			_val = combo.find('input.combo-text').val();
			if(_val == null || _val == "")
				return "";
			return _val;
		};

		for(var i = 0; i < _obj.values.length; i++) {
			_val += '|' + _obj.values[i][opts.valueField];
		};
		return _val.substring(1);
	};
	function setValues(target, values, remainText) {
		var opts = $.data(target, 'combobox').options;
		var data = $.data(target, 'combobox').data;
		var panel = $(target).combo('panel');

		panel.find('div.combobox-item-selected')
			.removeClass('combobox-item-selected');
		var vv = [], ss = [];

		for (var i = 0; i < values.length; i++) {
			var v = values[i][opts.valueField];
			var s = values[i][opts.textField];
			/*for (var j = 0; j < data.length; j++) {
			 if (data[j][opts.valueField] == v) {
			 s = data[j][opts.textField];
			 break;
			 }
			 }*/

			vv.push(v);
			ss.push(s);
			panel.find('div.combobox-item[value=' + v + ']')
				.addClass('combobox-item-selected');
		};
		var _obj = new Object();
		_obj.values = values;
		$(target, 'combobox').data('comboSearch', _obj);
		//$.data(target, 'comboSearch', _obj);
		//$(target).data('comboSearch', {values:values});
//		if (!remainText && values.length != 0) {
		$(target, 'combobox').combo('setText', ss.join(opts.separator));
//		}
	};
	function transformData(target) {
		var opts = $.data(target, 'combobox').options;
		var data = [];
		$('>option', target).each(function() {
			var item = {};
			item[opts.valueField] = $(this).attr('value')!=undefined?$(this).attr('value'):$(this).html();
			item[opts.textField] = $(this).html();
			item['selected'] = $(this).attr('selected');
			data.push(item);
		});
		return data;
	};
	function s_init(target) {
		var panel = $(target).combo('panel');
		var opts = $.data(target, 'combobox').options;
		var search_input = $("<input type='text' onclick='$(this).focus();' />");
		search_input.css("width", parseInt(panel.css("width")) - 7);
		panel.prepend(search_input);
		search_input.bind("keyup", function(event){
			opts.onKeyup(target, this, event);
		}).bind("focus", function() {
			$(this).val('');
		});
		$.data(target, "comboSearch", {});
	};
	function loadData(target, data, remainText) {
		var opts = $.data(target, 'combobox').options;
		var panel = $(target).combo('panel');
		$.data(target, 'combobox').data = data;
		var values = $(target).comboSearch('getVals');
		panel.find("div").remove();
		if(data == null)
			return;
		for (var i = 0; i < data.length; i++) {
			var v = data[i][opts.valueField];
			var s = data[i][opts.textField];
			var item = $('<div class="combobox-item"></div>').appendTo(panel);
			item.attr('value', v);
			if (opts.formatter) {
				item.html(opts.formatter.call(target, data[i]));
			} else {
				item.html(s);
			};
			if (data[i]['selected']) {
				(function() {
					for (var i = 0; i < values.length; i++) {
						if (v == values[i]) {
							return;
						}
					}
					values.push(v);
				})();
			}
		};
		if (opts.multiple) {
			setValues(target, values, remainText);
		} else {
			if (values.length) {
				setValues(target, [values[values.length - 1]], remainText);
			} else {
				setValues(target, [], remainText);
			}
		};
		opts.onLoadSuccess.call(target, data);
		$('.combobox-item', panel).hover(function() {
			$(this).addClass('combobox-item-hover');
		}, function() {
			$(this).removeClass('combobox-item-hover');
		}).click(function() {
			var item = $(this);
			var _obj = new Object();
//			var pattern = /<[^>]>?/;
			//alert(item.html().replace(/\<.+\>/g,''));
			_obj[opts.valueField] = item.attr('value');
			_obj[opts.textField] = item.html().replace(/<[^>]*>/g,'');
			if (opts.multiple) {
				if (item.hasClass('combobox-item-selected')) {
					unselect(target, _obj);
				} else {
					select(target, _obj);
				}
			} else {
				select(target, _obj);
				$(target).combo('hidePanel');
			}
		});
	};
	function request(target, url, param, remainText) {
		var opts = $.data(target, 'combobox').options;
		if (url) {
			opts.url = url;
		};
		if (!opts.url) {
			return;
		};
		param = param || {};
		$.ajax({
			type:opts.method,
			url : opts.url,
			dataType : 'json',
			data : param,
			success : function(data) {
				loadData(target, data, remainText);
			},
			error : function() {
				opts.onLoadError.apply(this, arguments);
			}
		});
	};
	function doQuery(target, q) {
		var opts = $.data(target, 'combobox').options;
		if (opts.multiple && !q) {
			setValues(target, [], true);
		} else {
			setValues(target, [q], true);
		};
		if (opts.mode == 'remote') {
			request(target, null, {
				q : q
			}, true);
		} else {
			var panel = $(target).combo('panel');
			panel.find('div.combobox-item').hide();
			var data = $.data(target, 'combobox').data;
			for (var i = 0; i < data.length; i++) {
				if (opts.filter.call(target, q, data[i])) {
					var v = data[i][opts.valueField];
					var s = data[i][opts.textField];
					var item = panel.find('div.combobox-item[value=' + v + ']');
					item.show();
					if (s == q) {
						setValues(target, [v], true);
						item.addClass('combobox-item-selected');
					}
				}
			}
		}
	};
	function create(target) {
		var opts = $.data(target, 'combobox').options;
		$(target).addClass('combobox-f');
		$(target).combo($.extend({}, opts, {
			onShowPanel : function() {
				$(target).combo('panel').find('div.combobox-item').show();
				scrollTo(target, $(target).comboSearch('getValue'));
				opts.onShowPanel.call(target);
			}
		}));
	};
	$.fn.comboSearch = function(options, param) {
		if (typeof options == 'string') {
			var method = $.fn.comboSearch.methods[options];
			if (method) {
				return method(this, param);
			} else {
				return this.combo(options, param);
			}
		};
		options = options || {};
		return this.each(function() {
			var state = $.data(this, 'combobox');
			if (state) {
				$.extend(state.options, options);
				create(this);
			} else {
				state = $.data(this, 'combobox', {
					options : $.extend({},
						$.fn.comboSearch.defaults,
						$.fn.comboSearch.parseOptions(this),
						options)
				});
				create(this);
				s_init(this);
				//loadData(this, transformData(this));
			};
			if (state.options.data) {
				loadData(this, state.options.data);
			}
			//request(this);
		});
	};
	$.fn.comboSearch.methods = {
		options : function(jq) {
			return $.data(jq[0], 'combobox').options;
		},
		getData : function(jq) {
			return $.data(jq[0], 'combobox').data;
		},
		getValues : function(jq) {
			return getValues(jq[0]);
		},
		getVals : function(jq) {
			return getVals(jq[0]);
		},
		setValues : function(jq, values) {
			return jq.each(function() {
				setValues(this, values);
			});
		},
		setValue : function(jq, value) {
			return jq.each(function() {
				setValues(this, [value]);
			});
		},
		clear : function(jq) {
			return jq.each(function() {
				$(this).combo('clear');
				var panel = $(this).combo('panel');
				panel.find('div.combobox-item-selected')
					.removeClass('combobox-item-selected');
			});
		},
		loadData : function(jq, data) {
			return jq.each(function() {
				loadData(this, data);
			});
		},
		reload : function(jq, url) {
			return jq.each(function() {
				request(this, url);
			});
		},
		select : function(jq, value) {
			return jq.each(function() {
				select(this, value);
			});
		},
		unselect : function(jq, value) {
			return jq.each(function() {
				unselect(this, value);
			});
		},
		loadSearchData : function(jq, data) {

		}
	};
	$.fn.comboSearch.parseOptions = function(target) {
		var t = $(target);
		return $.extend({}, $.fn.combo.parseOptions(target), {
			valueField : t.attr('valueField'),
			textField : t.attr('textField'),
			mode : t.attr('mode'),
			method:(t.attr('method')?t.attr('method'):undefined),
			url : t.attr('url')
		});
	};
	$.fn.comboSearch.defaults = $.extend({}, $.fn.combo.defaults, {
		valueField : 'value',
		textField : 'text',
		mode : 'local',
		method:'post',
		url : getDomain() + '/search/biz_search.action',
		search_url : 'http://192.168.100.2:8088/searchbiz?',
		data : null,
		pageindex : 1,
		pagenum : 10,
		keyword : 'keyword',
		apikey : 'fantong.com',
		search_key : 'bid',
		search_value : 'name',
		search_table : 'biz',
		multiple : true,
		keyHandler : {
			up : function() {
				selectPrev(this);
			},
			down : function() {
				selectNext(this);
			},
			enter : function() {
				var values = $(this).comboSearch('getVals');
				$(this).comboSearch('setValues', values);
				$(this).comboSearch('hidePanel');
			},
			query : function(q) {
				doQuery(this, q);
			}
		},
		filter : function(q, row) {
			var opts = $(this).comboSearch('options');
			return row[opts.textField].indexOf(q) == 0;
		},
		formatter : function(row) {
			var opts = $(this).comboSearch('options');
			return row[opts.textField];
		},
		onLoadSuccess : function() {
		},
		onLoadError : function() {
		},
		onSelect : function(record) {
		},
		onUnselect : function(record) {
		},
		onKeyup : function(target, _input, event) {
			var _val = $(_input).val();
//			tipMsg(_val.length,"system messager");
//			return;
			if(_val == "")
				return;
			var opts = $.data(target, 'combobox').options;
			var _data = {q:opts.search_value+":"+_val,tableName:opts.search_table};
			//http://ip_or_domain:8088/searchbiz?city=%E5%8C%97%E4%BA%AC&addr=&keyword=%E9%A4%90%E9%A6%86&resultnum=100&pageindex=0&pagenum=10&t=json-mobile-utf8&multilimit=%E9%A4%90%E9%A6%86,is_park,eq,1&fieldlimit=%E7%81%AB%E9%94%85,taste&apikey=fantong.com
			//var _url = opts.search_url + "city=北京&addr=&keyword=" + $(_input).val() + "&resultnum=100&pageindex=1&pagenum=10&t=json-mobile-utf8&multilimit=%E9%A4%90%E9%A6%86,is_park,eq,1&fieldlimit=%E7%81%AB%E9%94%85,taste&apikey=fantong.com";

			apolloAjax({
				url:opts.url,
				data:_data,
				success:function(rb){
					var _result = rb.result;
					loadData(target, _result);
				},
				error:function(r){
					$.messager.alert("系统信息", "读取搜索数据出错");
				}
			});
		},
		onShowPanel : function() {
			var panel = $(this).combo('panel');
			panel.find('input[type=text]').val('请输入商家名称');
			var _obj = $(this).data('comboSearch');
			if(_obj == null || _obj.values == null)
				return;
			$(this).comboSearch("loadData", _obj.values);
		},
		onHidePanel : function() {

		}
	});
});

/**
 * jQuery EasyUI 1.4.4
 *
 * Copyright (c) 2009-2015 www.jeasyui.com. All rights reserved.
 *
 * Licensed under the freeware license: http://www.jeasyui.com/license_freeware.php
 * To use it on other terms please contact us: info@jeasyui.com
 *
 */
/**
 * combobox - jQuery EasyUI
 *
 * Dependencies:
 *   combo
 *
 */
(function($){
	var COMBOBOX_SERNO = 0;

	function getRowIndex(target, value){
		var state = $.data(target, 'combobox');
		var opts = state.options;
		var data = state.data;
		for(var i=0; i<data.length; i++){
			if (data[i][opts.valueField] == value){
				return i;
			}
		}
		return -1;
	}

	/**
	 * scroll panel to display the specified item
	 */
	function scrollTo(target, value){
		var opts = $.data(target, 'combobox').options;
		var panel = $(target).combo('panel');
		var item = opts.finder.getEl(target, value);
		if (item.length){
			if (item.position().top <= 0){
				var h = panel.scrollTop() + item.position().top;
				panel.scrollTop(h);
			} else if (item.position().top + item.outerHeight() > panel.height()){
				var h = panel.scrollTop() + item.position().top + item.outerHeight() - panel.height();
				panel.scrollTop(h);
			}
		}
	}

	function nav(target, dir){
		var opts = $.data(target, 'combobox').options;
		var panel = $(target).combobox('panel');
		var item = panel.children('div.combobox-item-hover');
		if (!item.length){
			item = panel.children('div.combobox-item-selected');
		}
		item.removeClass('combobox-item-hover');
		var firstSelector = 'div.combobox-item:visible:not(.combobox-item-disabled):first';
		var lastSelector = 'div.combobox-item:visible:not(.combobox-item-disabled):last';
		if (!item.length){
			item = panel.children(dir=='next' ? firstSelector : lastSelector);
//			item = panel.children('div.combobox-item:visible:' + (dir=='next'?'first':'last'));
		} else {
			if (dir == 'next'){
				item = item.nextAll(firstSelector);
//				item = item.nextAll('div.combobox-item:visible:first');
				if (!item.length){
					item = panel.children(firstSelector);
//					item = panel.children('div.combobox-item:visible:first');
				}
			} else {
				item = item.prevAll(firstSelector);
//				item = item.prevAll('div.combobox-item:visible:first');
				if (!item.length){
					item = panel.children(lastSelector);
//					item = panel.children('div.combobox-item:visible:last');
				}
			}
		}
		if (item.length){
			item.addClass('combobox-item-hover');
			var row = opts.finder.getRow(target, item);
			if (row){
				scrollTo(target, row[opts.valueField]);
				if (opts.selectOnNavigation){
					select(target, row[opts.valueField]);
				}
			}
		}
	}

	/**
	 * select the specified value
	 */
	function select(target, value){
		var opts = $.data(target, 'combobox').options;
		var values = $(target).combo('getValues');
		if ($.inArray(value+'', values) == -1){
			if (opts.multiple){
				values.push(value);
			} else {
				values = [value];
			}
			setValues(target, values);
			opts.onSelect.call(target, opts.finder.getRow(target, value));
		}
	}

	/**
	 * unselect the specified value
	 */
	function unselect(target, value){
		var opts = $.data(target, 'combobox').options;
		var values = $(target).combo('getValues');
		var index = $.inArray(value+'', values);
		if (index >= 0){
			values.splice(index, 1);
			setValues(target, values);
			opts.onUnselect.call(target, opts.finder.getRow(target, value));
		}
	}

	/**
	 * set values
	 */
	function setValues(target, values, remainText){
		var opts = $.data(target, 'combobox').options;
		var panel = $(target).combo('panel');

		if (!$.isArray(values)){values = values.split(opts.separator)}
		panel.find('div.combobox-item-selected').removeClass('combobox-item-selected');
		var vv = [], ss = [];
		for(var i=0; i<values.length; i++){
			var v = values[i];
			var s = v;
			opts.finder.getEl(target, v).addClass('combobox-item-selected');
			var row = opts.finder.getRow(target, v);
			if (row){
				s = row[opts.textField];
			}
			vv.push(v);
			ss.push(s);
		}

		if (!remainText){
			$(target).combo('setText', ss.join(opts.separator));
		}
		$(target).combo('setValues', vv);
	}

	/**
	 * load data, the old list items will be removed.
	 */
	function loadData(target, data, remainText){
		var state = $.data(target, 'combobox');
		var opts = state.options;
		state.data = opts.loadFilter.call(target, data);
		state.groups = [];
		data = state.data;

		var selected = $(target).combobox('getValues');
		var dd = [];
		var group = undefined;
		for(var i=0; i<data.length; i++){
			var row = data[i];
			var v = row[opts.valueField]+'';
			var s = row[opts.textField];
			var g = row[opts.groupField];

			if (g){
				if (group != g){
					group = g;
					state.groups.push(g);
					dd.push('<div id="' + (state.groupIdPrefix+'_'+(state.groups.length-1)) + '" class="combobox-group">');
					dd.push(opts.groupFormatter ? opts.groupFormatter.call(target, g) : g);
					dd.push('</div>');
				}
			} else {
				group = undefined;
			}

			var cls = 'combobox-item' + (row.disabled ? ' combobox-item-disabled' : '') + (g ? ' combobox-gitem' : '');

			if(opts.formatter ? opts.formatter.call(target, row) : s){
				dd.push('<div id="' + (state.itemIdPrefix+'_'+i) + '" class="' + cls + '">');
				dd.push(opts.formatter ? opts.formatter.call(target, row) : s);
				dd.push('</div>');
			}


//			if (item['selected']){
//				(function(){
//					for(var i=0; i<selected.length; i++){
//						if (v == selected[i]) return;
//					}
//					selected.push(v);
//				})();
//			}
			if (row['selected'] && $.inArray(v, selected) == -1){
				selected.push(v);
			}
		}
		$(target).combo('panel').html(dd.join(''));

		if (opts.multiple){
			setValues(target, selected, remainText);
		} else {
			setValues(target, selected.length ? [selected[selected.length-1]] : [], remainText);
		}

		opts.onLoadSuccess.call(target, data);
	}

	/**
	 * request remote data if the url property is setted.
	 */
	function request(target, url, param, remainText){
		var opts = $.data(target, 'combobox').options;
		if (url){
			opts.url = url;
		}
		param = $.extend({}, opts.queryParams, param||{});
//		param = param || {};

		if (opts.onBeforeLoad.call(target, param) == false) return;

		opts.loader.call(target, param, function(data){
			loadData(target, data, remainText);
		}, function(){
			opts.onLoadError.apply(this, arguments);
		});
	}

	/**
	 * do the query action
	 */
	function doQuery(target, q){
		var state = $.data(target, 'combobox');
		var opts = state.options;

		var qq = opts.multiple ? q.split(opts.separator) : [q];
		if (opts.mode == 'remote'){
			_setValues(qq);
			request(target, null, {q:q}, true);
		} else {
			var panel = $(target).combo('panel');
			panel.find('div.combobox-item-selected,div.combobox-item-hover').removeClass('combobox-item-selected combobox-item-hover');
			panel.find('div.combobox-item,div.combobox-group').hide();
			var data = state.data;
			var vv = [];
			$.map(qq, function(q){
				q = $.trim(q);
				var value = q;
				var group = undefined;
				for(var i=0; i<data.length; i++){
					var row = data[i];
					if (opts.filter.call(target, q, row)){
						var v = row[opts.valueField];
						var s = row[opts.textField];
						var g = row[opts.groupField];
						var item = opts.finder.getEl(target, v).show();
						if (s.toLowerCase() == q.toLowerCase()){
							value = v;
							item.addClass('combobox-item-selected');
							opts.onSelect.call(target, row);
						}
						if (opts.groupField && group != g){
							$('#'+state.groupIdPrefix+'_'+$.inArray(g, state.groups)).show();
							group = g;
						}
					}
				}
				vv.push(value);
			});
			_setValues(vv);
		}
		function _setValues(vv){
			setValues(target, opts.multiple ? (q?vv:[]) : vv, true);
		}
	}

	function doEnter(target){
		var t = $(target);
		var opts = t.combobox('options');
		var panel = t.combobox('panel');
		var item = panel.children('div.combobox-item-hover');
		if (item.length){
			var row = opts.finder.getRow(target, item);
			var value = row[opts.valueField];
			if (opts.multiple){
				if (item.hasClass('combobox-item-selected')){
					t.combobox('unselect', value);
				} else {
					t.combobox('select', value);
				}
			} else {
				t.combobox('select', value);
			}
		}
		var vv = [];
		$.map(t.combobox('getValues'), function(v){
			if (getRowIndex(target, v) >= 0){
				vv.push(v);
			}
		});
		t.combobox('setValues', vv);
		if (!opts.multiple){
			t.combobox('hidePanel');
		}
	}

	/**
	 * create the component
	 */
	function create(target){
		var state = $.data(target, 'combobox');
		var opts = state.options;

		COMBOBOX_SERNO++;
		state.itemIdPrefix = '_easyui_combobox_i' + COMBOBOX_SERNO;
		state.groupIdPrefix = '_easyui_combobox_g' + COMBOBOX_SERNO;

		$(target).addClass('combobox-f');
		$(target).combo($.extend({}, opts, {
			onShowPanel: function(){
				$(target).combo('panel').find('div.combobox-item:hidden,div.combobox-group:hidden').show();
				scrollTo(target, $(target).combobox('getValue'));
				opts.onShowPanel.call(target);
			}
		}));

		$(target).combo('panel').unbind().bind('mouseover', function(e){
			$(this).children('div.combobox-item-hover').removeClass('combobox-item-hover');
			var item = $(e.target).closest('div.combobox-item');
			if (!item.hasClass('combobox-item-disabled')){
				item.addClass('combobox-item-hover');
			}
			e.stopPropagation();
		}).bind('mouseout', function(e){
			$(e.target).closest('div.combobox-item').removeClass('combobox-item-hover');
			e.stopPropagation();
		}).bind('click', function(e){
			var item = $(e.target).closest('div.combobox-item');
			if (!item.length || item.hasClass('combobox-item-disabled')){return}
			var row = opts.finder.getRow(target, item);
			if (!row){return}
			var value = row[opts.valueField];
			if (opts.multiple){
				if (item.hasClass('combobox-item-selected')){
					unselect(target, value);
				} else {
					select(target, value);
				}
			} else {
				select(target, value);
				$(target).combo('hidePanel');
			}
			e.stopPropagation();
		});
	}

	$.fn.combobox = function(options, param){
		if (typeof options == 'string'){
			var method = $.fn.combobox.methods[options];
			if (method){
				return method(this, param);
			} else {
				return this.combo(options, param);
			}
		}

		options = options || {};
		return this.each(function(){
			var state = $.data(this, 'combobox');
			if (state){
				$.extend(state.options, options);
			} else {
				state = $.data(this, 'combobox', {
					options: $.extend({}, $.fn.combobox.defaults, $.fn.combobox.parseOptions(this), options),
					data: []
				});
			}
			create(this);
			var casecadeBy = state.options.casecadeBy;
			if ( casecadeBy ) {
				var that = this;
				$("#"+casecadeBy).combobox({
					onChange:function(newValue, oldValue){
						//清空子集
						$.fn.combobox.methods["loadData"]($(that),[]);
						$.fn.combobox.methods["clear"]($(that));

						var pValue = newValue;
						if ( !pValue ) {
							return;
						}
						var pParam = state.options.parentRequestParam;
						var param = {};
						param[pParam] = pValue;
						if (state.options.index) {
							param.index = state.options.index;
							request(that,ApolloURL.apl_query,param);
						}else if ( state.options.url ) {
							request(that,null,param);
						}else if( state.options.data ){
							var dataSet = state.options.data;
							var resultData = [];
							for ( var i=0; i<dataSet.length; i++ ) {
								if ( dataSet[i][state.options.parentValueField]==pValue ) {
									resultData.push(dataSet[i]);
								}
							}
							loadData(that, resultData);
						}else{
							var data = $.fn.combobox.parseData(this);
							if (data.length){
								loadData(this, data);
							}
						}
					}
				});
				return;
			}
			if (state.options.data) {
				loadData(this, state.options.data);
			} else {
				var data = $.fn.combobox.parseData(this);
				if (data.length){
					loadData(this, data);
				}
			}
			if (state.options.index) {
				request(this,ApolloURL.apl_query,{index:state.options.index});
			}else{
				request(this);
			}
		});
	};


	$.fn.combobox.methods = {
		options: function(jq){
			var copts = jq.combo('options');
			return $.extend($.data(jq[0], 'combobox').options, {
				width: copts.width,
				height: copts.height,
				originalValue: copts.originalValue,
				disabled: copts.disabled,
				readonly: copts.readonly
			});
		},
		getData: function(jq){
			return $.data(jq[0], 'combobox').data;
		},
		setValues: function(jq, values){
			return jq.each(function(){
				setValues(this, values);
			});
		},
		setValue: function(jq, value){
			return jq.each(function(){
				setValues(this, [value]);
			});
		},
		clear: function(jq){
			return jq.each(function(){
				$(this).combo('clear');
				var panel = $(this).combo('panel');
				panel.find('div.combobox-item-selected').removeClass('combobox-item-selected');
			});
		},
		reset: function(jq){
			return jq.each(function(){
				var opts = $(this).combobox('options');
				if (opts.multiple){
					$(this).combobox('setValues', opts.originalValue);
				} else {
					$(this).combobox('setValue', opts.originalValue);
				}
			});
		},
		loadData: function(jq, data){
			return jq.each(function(){
				loadData(this, data);
			});
		},
		reload: function(jq, url){
			return jq.each(function(){
				if (typeof url == 'string'){
					request(this, url);
				} else {
					if (url){
						var opts = $(this).combobox('options');
						opts.queryParams = url;
					}
					request(this);
				}
			});
		},
		select: function(jq, value){
			return jq.each(function(){
				select(this, value);
			});
		},
		unselect: function(jq, value){
			return jq.each(function(){
				unselect(this, value);
			});
		}
	};

	$.fn.combobox.parseOptions = function(target){
		var t = $(target);
		return $.extend({}, $.fn.combo.parseOptions(target), $.parser.parseOptions(target,[
			'valueField','textField','groupField','mode','method','url','casecadeBy','parentValueField','parentRequestParam','index'
		]));
	};

	$.fn.combobox.parseData = function(target){
		var data = [];
		var opts = $(target).combobox('options');
		$(target).children().each(function(){
			if (this.tagName.toLowerCase() == 'optgroup'){
				var group = $(this).attr('label');
				$(this).children().each(function(){
					_parseItem(this, group);
				});
			} else {
				_parseItem(this);
			}
		});
		return data;

		function _parseItem(el, group){
			var t = $(el);
			var row = {};
			row[opts.valueField] = t.attr('value')!=undefined ? t.attr('value') : t.text();
			row[opts.textField] = t.text();
			row['selected'] = t.is(':selected');
			row['disabled'] = t.is(':disabled');
			if (group){
				opts.groupField = opts.groupField || 'group';
				row[opts.groupField] = group;
			}
			data.push(row);
		}
	};

	$.fn.combobox.defaults = $.extend({}, $.fn.combo.defaults, {
		valueField: 'value',
		textField: 'text',
		groupField: null,
		groupFormatter: function(group){return group;},
		mode: 'local',	// or 'remote'
		method: 'post',
		url: null,
		data: null,
		queryParams: {},

		keyHandler: {
			up: function(e){nav(this,'prev');e.preventDefault()},
			down: function(e){nav(this,'next');e.preventDefault()},
			left: function(e){},
			right: function(e){},
			enter: function(e){doEnter(this)},
			query: function(q,e){doQuery(this, q)}
		},
		filter: function(q, row){
			var opts = $(this).combobox('options');
			if(opts && opts.textField && row[opts.textField]){
				return row[opts.textField].toLowerCase().indexOf(q.toLowerCase()) == 0;
			}
			return false;			
		},
		formatter: function(row){
			var opts = $(this).combobox('options');
			return row[opts.textField];
		},
		loader: function(param, success, error){
			var opts = $(this).combobox('options');
			if (!opts.url) return false;
			$.ajax({
				type: opts.method,
				url: opts.url,
				data: param,
				dataType: 'json',
				success: function(data){
					success(data);
				},
				error: function(){
					error.apply(this, arguments);
				}
			});
		},
		loadFilter: function(data){
			return data;
		},
		finder:{
			getEl:function(target, value){
				var index = getRowIndex(target, value);
				var id = $.data(target, 'combobox').itemIdPrefix + '_' + index;
				return $('#'+id);
			},
			getRow:function(target, p){
				var state = $.data(target, 'combobox');
				var index = (p instanceof jQuery) ? p.attr('id').substr(state.itemIdPrefix.length+1) : getRowIndex(target, p);
				return state.data[parseInt(index)];
			}
		},

		onBeforeLoad: function(param){},
		onLoadSuccess: function(){},
		onLoadError: function(){},
		onSelect: function(record){},
		onUnselect: function(record){}
	});
})(jQuery);

$.extend($.fn.validatebox.defaults.rules, {
	/**
	 * 验证最小长度
	 * @example
	 */
	minLength : {
		validator : function(value, param) {
			return value.length >= param[0];
		},
		message : '最少输入 {0} 个字符。'
	},
	lengthbetween : {
		validator : function(value, param) {
			this.message = '输入内容长度必须介于{0}到{1}之间';
			var len = $.trim(value).length;
			if (param) {
				for (var i = 0; i < param.length; i++) {
					this.message = this.message.replace(new RegExp(
						"\\{" + i + "\\}", "g"), param[i]);
				}
			}
			return len >= param[0] && len <= param[1];
		},
		message : '输入内容长度必须介于{0}到{1}之间'
	},
	numberbetween:{
		validator: function(value, param){
			if (!isNaN(value)){
				value = parseInt(value);
				return value >= param[0] && value <= param[1];
			}else{
				return false;
			}
		},
		message: '请输入介于{0}到{1}的数字'
	},
	phone : {// 验证电话号码
		validator : function(value) {
			return /^((\(\d{2,3}\))|(\d{3}\-))?(\(0\d{2,3}\)|0\d{2,3}-)?[1-9]\d{6,7}(\-\d{1,4})?$/i.test(value);
		},
		message : '格式不正确,请使用下面格式:020-88888888'
	},
	mobile : {// 验证手机号码
		validator : function(value) {
			return /^(13|15|18)\d{9}$/i.test(value);
		},
		message : '手机号码格式不正确'
	},
	idcard : {// 验证身份证
		validator : function(value) {
			return /^\d{15}(\d{2}[A-Za-z0-9])?$/i.test(value);
		},
		message : '身份证号码格式不正确'
	},
	intOrFloat : {// 验证整数或小数
		validator : function(value) {
			return /^\d+(\.\d+)?$/i.test(value);
		},
		message : '请输入数字，并确保格式正确'
	},
	currency : {// 验证货币
		validator : function(value) {
			return /^\d+(\.\d+)?$/i.test(value);
		},
		message : '货币格式不正确'
	},
	qq : {// 验证QQ,从10000开始
		validator : function(value) {
			return /^[1-9]\d{4,9}$/i.test(value);
		},
		message : 'QQ号码格式不正确'
	},
	integer : {// 验证整数
		validator : function(value) {
			return /^[+]?[1-9]+\d*$/i.test(value);
		},
		message : '请输入整数'
	},
	chinese : {// 验证中文
		validator : function(value) {
			return /^[\u0391-\uFFE5]+$/i.test(value);
		},
		message : '请输入中文'
	},
	english : {// 验证英语
		validator : function(value) {
			return /^[A-Za-z]+$/i.test(value);
		},
		message : '请输入英文'
	},
	unnormal : {// 验证是否包含空格和非法字符
		validator : function(value) {
			return /.+/i.test(value);
		},
		message : '输入值不能为空和包含其他非法字符'
	},
	username : {// 验证用户名
		validator : function(value) {
			return /^[a-zA-Z][a-zA-Z0-9_]{5,15}$/i.test(value);
		},
		message : '用户名不合法（字母开头，允许6-16字节，允许字母数字下划线）'
	},
	faxno : {// 验证传真
		validator : function(value) {
//            return /^[+]{0,1}(\d){1,3}[ ]?([-]?((\d)|[ ]){1,12})+$/i.test(value);
			return /^((\(\d{2,3}\))|(\d{3}\-))?(\(0\d{2,3}\)|0\d{2,3}-)?[1-9]\d{6,7}(\-\d{1,4})?$/i.test(value);
		},
		message : '传真号码不正确'
	},
	zip : {// 验证邮政编码
		validator : function(value) {
			return /^[1-9]\d{5}$/i.test(value);
		},
		message : '邮政编码格式不正确'
	},
	ip : {// 验证IP地址
		validator : function(value) {
			return /d+.d+.d+.d+/i.test(value);
		},
		message : 'IP地址格式不正确'
	},
	name : {// 验证姓名，可以是中文或英文
		validator : function(value) {
			return /^[\u0391-\uFFE5]+$/i.test(value)|/^\w+[\w\s]+\w+$/i.test(value);
		},
		message : '请输入姓名'
	},
	carNo:{
		validator : function(value){
			return /^[\u4E00-\u9FA5][\da-zA-Z]{6}$/.test(value);
		},
		message : '车牌号码无效（例：粤J12350）'
	},
	carenergin:{
		validator : function(value){
			return /^[a-zA-Z0-9]{16}$/.test(value);
		},
		message : '发动机型号无效(例：FG6H012345654584)'
	},
	email:{
		validator : function(value){
			return /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/.test(value);
		},
		message : '请输入有效的电子邮件账号(例：abc@126.com)'
	},
	msn:{
		validator : function(value){
			return /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/.test(value);
		},
		message : '请输入有效的msn账号(例：abc@hotnail(msn/live).com)'
	},
	same:{
		validator : function(value, param){
			if($("#"+param[0]).val() != "" && value != ""){
				return $("#"+param[0]).val() == value;
			}else{
				return true;
			}
		},
		message : '两次输入的密码不一致！'
	},
	multiple : {
		validator : function(value, vtypes) {
			var returnFlag = true;
			var opts = $.fn.validatebox.defaults;
			for (var i = 0; i < vtypes.length; i++) {
				var methodinfo = /([a-zA-Z_]+)(.*)/.exec(vtypes[i]);
				var rule = opts.rules[methodinfo[1]];
				if (value && rule) {
					var parame = eval(methodinfo[2]);
					if (!rule["validator"](value, parame)) {
						returnFlag = false;
						this.message = rule.message;
						break;
					}
				}
			}
			return returnFlag;
		}
	},
	required:{
		validator : function(value, param){
			alert(value);
			if ( param&&param.length==2 ) {
				var datas=$("#"+param[0]).combobox("getData");
				for ( var i=0; i<datas.length; i++ ) {
					if (datas[i][param[1]]==value){

						return true;
					}
				}
				return false;
			}

			if(value != ""){
				return true;
			}else{
				return false;
			}
		},
		message : '该输入项为必输项！'
	}
});

$.extend($.fn.validatebox.methods, {
	validateByType : function(jq,validType) {
		return jq.each(function() {
			var thisObj = $(this);
			var oldType = thisObj.attr('validType');
			if ( oldType==''||oldType!=validType ) {
				//alert(validType);
				thisObj.validatebox({validType:'email'});
				return thisObj.validatebox("validate");
				thisObj.validatebox({validType:oldType});
			}else{
				return thisObj.validatebox("validate");
			}
		});
	}
});


/**  
 * tree方法扩展   
 */  
$.extend($.fn.tree.methods, {   
    /**
     * 激活复选框  
     * @param {Object} jq  
     * @param {Object} target  
     */  
    enableCheck : function(jq, target) {    
        return jq.each(function(){   
            var realTarget;   
            if(typeof target == "string" || typeof target == "number"){   
                realTarget = $(this).tree("find",target).target;   
            }else{   
                realTarget = target;   
            }   
            var ckSpan = $(realTarget).find(">span.tree-checkbox");   
            if(ckSpan.hasClass('tree-checkbox-disabled0')){   
                ckSpan.removeClass('tree-checkbox-disabled0');   
            }else if(ckSpan.hasClass('tree-checkbox-disabled1')){   
                ckSpan.removeClass('tree-checkbox-disabled1');   
            }else if(ckSpan.hasClass('tree-checkbox-disabled2')){   
                ckSpan.removeClass('tree-checkbox-disabled2');   
            }   
        });   
    },   
    /**
     * 禁用复选框  
     * @param {Object} jq  
     * @param {Object} target  
     */  
    disableCheck : function(jq, target) {   
        return jq.each(function() {   
            var realTarget;   
            var that = this;   
            var state = $.data(this,'tree');   
            var opts = state.options;   
            if(typeof target == "string" || typeof target == "number"){   
                realTarget = $(this).tree("find",target).target;   
            }else{   
                realTarget = target;   
            }   
            var ckSpan = $(realTarget).find(">span.tree-checkbox");   
            ckSpan.removeClass("tree-checkbox-disabled0").removeClass("tree-checkbox-disabled1").removeClass("tree-checkbox-disabled2");   
            if(ckSpan.hasClass('tree-checkbox0')){   
                ckSpan.addClass('tree-checkbox-disabled0');   
            }else if(ckSpan.hasClass('tree-checkbox1')){   
                ckSpan.addClass('tree-checkbox-disabled1');   
            }else{   
                ckSpan.addClass('tree-checkbox-disabled2')   
            }   
            if(!state.resetClick){   
                $(this).unbind('click').bind('click', function(e) {   
                    var tt = $(e.target);   
                    var node = tt.closest('div.tree-node');   
                    if (!node.length){return;}   
                    if (tt.hasClass('tree-hit')){   
                        $(this).tree("toggle",node[0]);   
                        return false;   
                    } else if (tt.hasClass('tree-checkbox')){   
                        if(tt.hasClass('tree-checkbox-disabled0') || tt.hasClass('tree-checkbox-disabled1') || tt.hasClass('tree-checkbox-disabled2')){   
                            $(this).tree("select",node[0]);   
                        }else{   
                            if(tt.hasClass('tree-checkbox1')){   
                                $(this).tree('uncheck',node[0]);   
                            }else{   
                                $(this).tree('check',node[0]);   
                            }   
                            return false;   
                        }   
                    } else {   
                        $(this).tree("select",node[0]);   
                        opts.onClick.call(this, $(this).tree("getNode",node[0]));   
                    }   
                    e.stopPropagation();   
                });   
            }   
               
        });   
    }   
});  

