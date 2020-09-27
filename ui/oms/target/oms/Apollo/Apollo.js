/*
 * 注意：
 * 发布此文件到线上需要改544行URL为线上：http://api.ruixuesoft.com
 * url:'http://api.test.ruixuesoft.com/auth/authorize/getUserPermission?userId='+user_id+'&moduleIds='+module.toString()+'&platformId=1',
 */

/**
 * 获得boss路径
 * @returns
 */
function getBossPath(){
	return typeof ApolloBossPath == 'string'?ApolloBossPath:"http://ims.ruixuesoft.com/";
}
/**
 * 获得soa路径
 * @returns
 */
function getSOAPath(){
	return typeof ApolloBossPath == 'string'?ApolloBossPath:"http://ims.ruixuesoft.com/";
}
/**
 * 项目基础路径
 * @returns
 */
function getDomain(){
	return typeof ApolloDomain == 'string'?ApolloDomain:"http://ims.ruixuesoft.com/";
};

function getPriPath(){
	return typeof ApolloPRIPath == 'string'?ApolloPRIPath:"http://api.ruixuesoft.com/";
}

/**
 * Url管理
 * 说明：
 * PRI_URL：权限校验url
 * apl_query：统一查询控制action，带分页
 * apl_query_nopage：统一查询控制action，不带分页
 * loginUrl：重定向到登录url
 * 
 * 
 */
var ApolloURL = {
	"PRI_URL":getPriPath()+"auth/authorize/getUserPermission",
	"apl_query":getDomain()+"/core/getPage.json",
	"apl_query_nopage":getDomain()+"/core/getData.json",
	"apl_update":"",
	"apl_delete":"",
	"apl_download":getDomain()+"/core/download.json",
	"loginUrl":"ims.ruixuesoft.com",
	geturl:function(url){
		if(ApolloURL[url]){
			return ApolloURL[url];
		}else{
			return getDomain()+url;
		}
	},
	getAplDownloadUrl:function(){
		return ApolloURL.apl_download;
	},
	getAplQuery:function(){
		return ApolloURL.apl_query;
	},
	getAplQueryNoPage:function(){
		return ApolloURL.apl_query_nopage;
	},
	getLoginUrl:function(){
		return ApolloURL.loginUrl;
	},
	getPriUrl:function(){
		return ApolloURL.PRI_URL;
	}
};

/**
 * 统一错误码控制
 * 两种类型的错误码：需要做重定向和不需要做重定向的
 * 需要做重定向的，在ApolloURL 里管理需要做重定向的地址
 * 
 * -5:登录失败
 * -10 API接口异常
 * -20 数据库异常
 * 
 */
var ApolloCodeManager={
		isSystemCode:function(errorCode){
			switch(errorCode){
				case -5:return true;break;
				case -10:return true;break;
				case -20:return true;break;
				default:return false;
			}
		},
		needRedirect:function(errorCode){
			//==需要做重定向的code
			if(errorCode == "-5" || errorCode ==-5){
				return true;
			}
			return false;
		},
		redirectUrl:function(errorCode){
			//==根据errorCode获得重定向的url
			var redirectUrlStr = ApolloURL.getLoginUrl();
			if(errorCode == "-5" || errorCode ==-5){
				redirectUrlStr = ApolloURL.getLoginUrl();
			}
			return redirectUrlStr;
		}
};



/**
 * 根据data翻译
 * data 数据格式参考如下：
 *  [{"TEXT":"aaa","VALUE":111},{"TEXT":"bbb","VALUE":14}]
 * 或
 *  [{"TITLE":"aaa","VALUE":111},{"TITLE":"bbb","VALUE":14}]
 * 
 * 
 * srcValue:被翻译对象的value
 * 
 * @param srcValue
 * @param params
 */
function formatterByData(srcValue,data){
	if(!srcValue && srcValue != 0){
		return srcValue;
	}		
	if(!data){
		return srcValue ;
	}
	var retStr = srcValue;
	$.each(data,function(key,item){
		if(item && srcValue == item.VALUE){
			if(item.TITLE){
				retStr = item.TITLE;
			}
			if(item.TEXT){
				retStr = item.TEXT;
			}
		}
	});
	return retStr;
}



/*$(function(){
	if($.cookie('cookie_user_role_id')){
		//PriManager.queryPriInfoByRole();
	}
});*/


/*$(function(){*/
	/**
	 * 统一ajax控制
	 * 
	 * params:参数说明： index 和url 必传其一
	 * index：指定index
	 * url:跳转路径  如果同时传index和url ，则以url为跳转路径
	 * success:成功回调方法
	 * bizException:业务异常回调方法，触发条件：返回参数有errorCode 且errorCode的值不在系统errorCode里
	 * data:参数
	 * nopage:是否需要分页,1:不分页,其余：分页
	 * 
	 * 
	 * callback 成功回调方法
	 * 
     * ajaxControl参数说明：
     * url 发送请求的地址
     * 
     * async 默认值: true。默认设置下，所有请求均为异步请求。如果需要发送同步请求，请将此选项设置为 false。
     *       注意，同步请求将锁住浏览器，用户其它操作必须等待请求完成才可以执行。
     * type 请求方式("POST" 或 "GET")， 默认为 "GET"
     * dataType 预期服务器返回的数据类型，常用的如：xml、html、json、text
     * errorfn 失败回调函数
     * context 上下文
     * needShow 是否跳出错误提示，1：弹出，其余不弹出
     * modal:模态，是否需要弹出遮罩层，默认不弹出，true：弹出，false：不弹出
     * timeout:30000,//超时时间：默认30秒
	 */
/*
	$.fn.apolloAjax = function(params,callback,ajaxControl){
		var ajaxMethod ={
				showError:function(errorMessage){
					if(console) console.log(errorMessage);
					if(typeof errorMessage =='string'){
						errorMessage = errorMessage;
					}else{
						errorMessage = JSON.stringify(errorMessage);
					}
					if("1" == ajaxControl.needShow){
						alert(errorMessage);
					}
				}
		}
		var context = this;		
		if(!params.index && !params.url){
			alert("index必传！");
			return ;
		}		
		var url = "";
		if(params.index && !params.url){
			if("1"==params.nopage){
				url = ApolloURL.getAplQueryNoPage();
			}else{
				url = ApolloURL.getAplQuery();
			}
			
		}
		if(params.url){
			url = ApolloURL.geturl(params.url);
		}		
		
		if(!url){
			alert("跳转路径不可为空！");
			return ;
		};
		
		if(!ajaxControl) ajaxControl = {};
		var bizExceptionFunc = params.bizException;
		var successFunc = params.success;
		delete params.bizException;
		delete params.success;
		var ajaxParam = {};
		if(params.data && (typeof params.data != "string")){
			ajaxParam = $.extend(ajaxParam,params.data);
		}else{
			ajaxParam = $.extend(ajaxParam,params);
		}

		if(!(ajaxControl && ajaxControl.modal)){
			ajaxControl.modal = false;
		}		
		if(ajaxControl.modal){
			$.messager.progress({'title':'提示','text':'数据处理中，请稍后....'});
		}
	
		$.ajax({
			url:url,
			data:ajaxParam,
			dataType:ajaxControl.dataType||"json",
			context:ajaxControl.context || context,
			async :ajaxControl.async==null?true:ajaxControl.async,
			type:ajaxControl.type||"get",
			timeout:ajaxControl.timeout||30000,
			success: function(retData) {
				$.messager.progress('close');
				params.success = successFunc;
				params.bizException = bizExceptionFunc;		
				try{
					if(ajaxControl.dataType == "text"){
						retData = JSON.parse(retData);
					}					
					if(retData && retData.errorCode){
						var errorMessage = retData.errorMessage || "";					
						if(ApolloCodeManager.isSystemCode(retData.errorCode)){
							if(ApolloCodeManager.needRedirect(retData.errorCode)){
								window.location.href ="http://"+ApolloCodeManager.redirectUrl(retData.errorCode);
							}else{
								ajaxMethod.showError(errorMessage);
							}
						}else{
							if(params.bizException && (typeof params.bizException == 'function')){
								params.bizException.call(params.context || context, retData, params);
							}else{
								ajaxMethod.showError(errorMessage);
							}
						}
					}else{
						if(callback && (typeof callback == 'function') ){
							callback.call(params.context || context, retData, params);
						}
						if(params.success && (typeof params.success == 'function')){
							params.success.call(params.context || context, retData, params);
						}
					}
				}catch(e){
					if(console)console.log(e);		
					if(callback && (typeof callback == 'function') ){
						callback.call(params.context || context, retData, params);
					}
					if(params.success && (typeof params.success == 'function')){
						params.success.call(params.context || context, retData, params);
					}
					if("1" == ajaxControl.needShow && !(callback && "" != callback) && !(params.success && ""!=params.success) ){
						alert(e);
					}
				}

			},
			error: function(XMLHttpRequest, textStatus, errorThrown){
				$.messager.progress('close');
				params.success = successFunc;
				params.bizException = bizExceptionFunc;
				if(ajaxControl.errorfn  && typeof ajaxControl.errorfn=='function'){
					ajaxControl.errorfn.call(params);
				}else{
					if(!$.cookie('cookie_user_id')){
						window.location.href="http://"+ApolloCodeManager.redirectUrl(-5);
					}
					if(console) console.log(XMLHttpRequest.responseText);
					
					if("1" == ajaxControl.needShow){
						var paramStr = "";
						if(typeof XMLHttpRequest.responseText =='string'){
							paramStr = XMLHttpRequest.responseText;
						}else{
							paramStr = JSON.stringify(XMLHttpRequest.responseText);
						}
						alert(paramStr);
					}
					
				}
			}
		});	
	};	
})
*/


/**
 * 统一ajax控制
 *
 * params:参数说明： index 和url 必传其一
 * index：指定index
 * url:跳转路径  如果同时传index和url ，则以url为跳转路径
 * success:成功回调方法
 * bizException:业务异常回调方法，触发条件：返回参数有errorCode 且errorCode的值不在系统errorCode里
 * data:参数
 * nopage:是否需要分页,1:不分页,其余：分页
 *
 *
 * callback 成功回调方法
 *
 * ajaxControl参数说明：
 * url 发送请求的地址
 *
 * async 默认值: true。默认设置下，所有请求均为异步请求。如果需要发送同步请求，请将此选项设置为 false。
 *       注意，同步请求将锁住浏览器，用户其它操作必须等待请求完成才可以执行。
 * type 请求方式("POST" 或 "GET")， 默认为 "GET"
 * dataType 预期服务器返回的数据类型，常用的如：xml、html、json、text
 * errorfn 失败回调函数
 * context 上下文
 * needShow 是否跳出错误提示，1：弹出，其余不弹出
 * modal:模态，是否需要弹出遮罩层，默认不弹出，true：弹出，false：不弹出
 * timeout:30000,//超时时间：默认30秒
 */

function apolloAjax(params,callback,ajaxControl){
	var ajaxMethod ={
		showError:function(errorMessage){
			if(console) console.log(errorMessage);
			if(typeof errorMessage =='string'){
				errorMessage = errorMessage;
			}else{
				errorMessage = JSON.stringify(errorMessage);
			}
			if("1" == ajaxControl.needShow){
				alert(errorMessage);
			}
		}
	}
	var context = this;
	if(!params.index && !params.url){
		alert("index必传！");
		return ;
	}
	var url = "";
	if(params.index && !params.url){
		if("1"==params.nopage){
			url = ApolloURL.getAplQueryNoPage();
		}else{
			url = ApolloURL.getAplQuery();
		}

	}
	if(params.url){
		url = ApolloURL.geturl(params.url);
	}

	if(!url){
		alert("跳转路径不可为空！");
		return ;
	};

	if(!ajaxControl) ajaxControl = {};
	var bizExceptionFunc = params.bizException;
	var successFunc = params.success;
	delete params.bizException;
	delete params.success;
	var ajaxParam = {};
	if(params.data && (typeof params.data != "string")){
		ajaxParam = $.extend(ajaxParam,params.data);
	}else{
		ajaxParam = $.extend(ajaxParam,params);
	}

	if(!(ajaxControl && ajaxControl.modal)){
		ajaxControl.modal = false;
	}
	if(ajaxControl.modal){
		$.messager.progress({'title':'提示','text':'数据处理中，请稍后....'});
	}

	$.ajax({
		url:url,
		data:ajaxParam,
		dataType:ajaxControl.dataType||"json",
		context:ajaxControl.context || context,
		async :ajaxControl.async==null?true:ajaxControl.async,
		type:ajaxControl.type||"get",
		timeout:ajaxControl.timeout||30000,
		success: function(retData) {
			$.messager.progress('close');
			params.success = successFunc;
			params.bizException = bizExceptionFunc;
			try{
				if(ajaxControl.dataType == "text"){
					retData = JSON.parse(retData);
				}
				if(retData && retData.errorCode){
					var errorMessage = retData.errorMessage || "";
					if(ApolloCodeManager.isSystemCode(retData.errorCode)){
						if(ApolloCodeManager.needRedirect(retData.errorCode)){
							window.location.href ="http://"+ApolloCodeManager.redirectUrl(retData.errorCode);
						}else{
							ajaxMethod.showError(errorMessage);
						}
					}else{
						if(params.bizException && (typeof params.bizException == 'function')){
							params.bizException.call(params.context || context, retData, params);
						}else{
							ajaxMethod.showError(errorMessage);
						}
					}
				}else{
					if(callback && (typeof callback == 'function') ){
						callback.call(params.context || context, retData, params);
					}
					if(params.success && (typeof params.success == 'function')){
						params.success.call(params.context || context, retData, params);
					}
				}
			}catch(e){
				if(console)console.log(e);
				if(callback && (typeof callback == 'function') ){
					callback.call(params.context || context, retData, params);
				}
				if(params.success && (typeof params.success == 'function')){
					params.success.call(params.context || context, retData, params);
				}
				if("1" == ajaxControl.needShow && !(callback && "" != callback) && !(params.success && ""!=params.success) ){
					alert(e);
				}
			}

		},
		error: function(XMLHttpRequest, textStatus, errorThrown){
			$.messager.progress('close');
			params.success = successFunc;
			params.bizException = bizExceptionFunc;
			if(ajaxControl.errorfn  && typeof ajaxControl.errorfn=='function'){
				ajaxControl.errorfn.call(params);
			}else{
				if(!$.cookie('cookie_user_id')){
					window.location.href="http://"+ApolloCodeManager.redirectUrl(-5);
				}
				if(console) console.log(XMLHttpRequest.responseText);

				if("1" == ajaxControl.needShow){
					var paramStr = "";
					if(typeof XMLHttpRequest.responseText =='string'){
						paramStr = XMLHttpRequest.responseText;
					}else{
						paramStr = JSON.stringify(XMLHttpRequest.responseText);
					}
					alert(paramStr);
				}

			}
		}
	});
}

/**
 * 权限控制管理
 */
var user_id = "";
var PriManager = {
		priMap:"",
		queryPriInfoByUserAuth:function(userId,priIdArray){
			/**
			 * 根据用户id和按钮菜单id查找用户权限
			 */ 
			var AppendPrid = new Array();
			var continueto = true;
			$("[pri_id]").each(function(){
				var pri_id =  $(this).attr("pri_id");
				if(null != AppendPrid && "" != AppendPrid){
					for(var i=0;i<AppendPrid.length;i++){
						if(AppendPrid[i] == pri_id){
							continueto = false;
							break;
						}
					}
					if(continueto){
						AppendPrid.push(pri_id);
					}
				}else{
					AppendPrid.push(pri_id);
				}
				
			});
			if("" != priIdArray && null != priIdArray){
				AppendPrid.push(priIdArray.toString());
			}
			//console.log(AppendPrid);
			var priIds = "";
			var queryParams = {};
			if(userId == "" || null == userId){ //如果userId为空就从缓存中取
				if(miniCookie.getCookie("user_id") != null){
					user_id = miniCookie.getCookie('user_id');
				}else{
					console.log("uesrId为空！");
				}				
			}else{
				user_id = userId;
			}
			
			if(AppendPrid){
				var module = "[";
				for(var i=0;i<AppendPrid.length;i++){
					module += "{";
					module += "\"moduleId\":\""+AppendPrid[i]+"\"";
					module += "}";
					module += i < AppendPrid.length - 1 ? "," : "";
				}
				module += "]";
			}
			var url = $.Apollo.domain.API_PATH;
			$.ajax({
				type:'post',
				url:url+'/auth/authorize/getUserPermission?userId='+user_id+'&moduleIds='+module.toString(),
				dataType:'json',
				async:false,
				   xhrFields: {
				          withCredentials: true
				       },
		  		success:function(data){
		  			if("0" == data.status){
		  				PriManager.priMap = data.result.modulePermisionList;
		  			}else{
		  				PriManager.priMap = "";
		  				console.log("查询功能按钮权限异常");
		  			}
		  			/*if(json.success){
		  				var obj= $.parseJSON(json.userModuleJson);
		  				PriManager.priMap = obj;	
		  			}else{
		  				PriManager.priMap = "";
		  				console.log("查询功能按钮权限异常");
		  			}*/
				},error:function(XMLHttpRequest, textStatus, errorThrown){
					console.log("获取用户按钮功能权限异常"+textStatus + ""  +"error:" + XMLHttpRequest.readyState);
				}
			});
			
		},
		
		
		/**
		 * 根据权限idlist获得权限列表 (根据列表查询权限)
		 * pri_id_list 格式：
		 * [{pri_id:111},{pri_id:2222}]
		 * 
		 * @param pri_id_list
		 */
		queryPriByPriIdList:function(pri_id_list,callback){
			if(pri_id_list && pri_id_list.length>0){
				$.each(pri_id_list,function(key,item){
					if(item.pri_id){
						$.ajax({
							url :  ApolloURL.getPriUrl()+item.pri_id,
							dataType: "jsonp",
							async : false,
							type: "get",
							success: function(r) {				
								if(r.result_id == "1"){						
									PriManager.priMap[item.pri_id] = item.pri_id;
								}else{
									PriManager.priMap[item.pri_id] = -1;
								}
								
								if(callback  && (typeof callback=='function')){
									callback.call(PriManager.priMap);
								}
							},
							error: function(XMLHttpRequest, textStatus, errorThrown){
								alert("权限验证失败");
							}
						});	
					}
				});
			}else{
				alert("权限列表不可为空！");
			}		
		},
		//对封装后的easyUi 按钮权限控制
		hasPrevilege:function(pri_id,callback){
			PriManager.queryPriInfoByUserAuth('',pri_id);
			var flag = false;
			$.each(PriManager.priMap,function(key,value){
				if(value.moduleId){
					if(value.moduleId == pri_id && value.hasPermission){					
						flag = true;
						return flag;
					}
				}				
			});
			return flag;
		},
		//对原生的easyUi 按钮包含普通按钮权限控制
		priFunction:function(gridId,fieldPriList){
			var perform= false;
			$("[pri_id]").each(function(){ //获取页面所有定义的pri_id标签属性
				$(this).hide();
				var pri_id =  $(this).attr("pri_id"); //获取pri_id 的值
				if(null != PriManager.priMap && "" != PriManager.priMap){
					$.each(PriManager.priMap,function(key,value){
						if(null != value.moduleId && "" != value.moduleId){
						if(value.moduleId == pri_id && value.hasPermission){
							$("[pri_id='"+pri_id+"']").show();   //相等就展示按钮
							perform = true;
						 }
						}else{
							$("[pri_id='"+pri_id+"']").show(); 
						}
						
					});
					/*if(perform){  //不建议使用，相当慢
						$.ajax({
							type:'post',
							url:'/sysUser/ajaxQryUserAction.action',
							data:{'userId':user_id,'menuId':pri_id},
							dataType:'json',
							async:false,
					  		success:function(json){
					  			if(json.success){
					  				var obj= $.parseJSON(json.userModuleJson);
					  				$.each(obj,function(key,value){
					  					if(value.hasPermission){
					  						$("[pri_id='"+pri_id+"']").show();
					  					}
					  				});
					  			}
						},
						error: function(XMLHttpRequest, textStatus, errorThrown){
							alert("权限验证失败");
						}
					});
					}*/
				}else{
					$(this).show();
				}
		  	});
			//控制dataGrid 列隐藏
			if(gridId && fieldPriList){
				PriManager.dealGridField(gridId,fieldPriList);
			}
		},
		/**
		 * 处理dataGrid 列权限
		 * fieldPriList 格式如下：
		 * [{"field":field1,"pri_id":pri_id1},{"field":field2,"pri_id":pri_id2}]
		 * @param gridId
		 * @param fieldPriList
		 */
		dealGridField:function(gridId,fieldPriList){
			if(fieldPriList && fieldPriList.length>0){
				$.each(fieldPriList,function(index,item){
					if(item && item.field && item.pri_id){
						$.ajax({
							url :  ApolloURL.getPriUrl()+item.pri_id,
							dataType: "jsonp",
							async : false,
							type: "get",
							success: function(r) {		
								if(r.result_id != "1"){
									$("#"+gridId).datagrid('hideColumn', item.field);							
								}
							},
							error: function(XMLHttpRequest, textStatus, errorThrown){
								$("#"+gridId).datagrid('hideColumn', item.field);	
								alert("权限验证失败");						
							}
						});
					}
				});
			}	
		}
}

/**
 *权限控制检查，做页面统一权限控制
 *
 */
$(function(){
	/*PriManager.queryPriInfoByUserAuth('','');
	setTimeout(PriManager.priFunction,450);*/
});


function isIE6() {
	/**判定是否是IE6**/
	if ($.browser.msie) {if ($.browser.version == "6.0") return true;} return false;
};	

function ajaxTree(__opts){
	var queryParam = $.extend({
		url:getDomain()+'/publicJson/tree.action'
	},__opts);
	queryParam.success = function(_data){
		__opts.success(_data);
	};
	$().apolloAjax(queryParam);
};

/** 
	@constructor
	@description ajax方式查询数据库
*/
function ajaxQuery(__opts){
	var queryParam = $.extend({
		url:getDomain()+ApolloURL.getAplQueryNoPage()
	},__opts);
	queryParam.success = function(_data){
		__opts.success(_data.rows);
	};
	$().apolloAjax(queryParam);
};

/** 
	@constructor
	@description ajax方式更新数据库
*/
function ajaxUpdate(__opts){
	var queryParam = $.extend({
		url:getDomain()+'/publicJson/update.action'
	},__opts);
	if(__opts.isMulti)__opts.data.isMultiQuery = true;
	if(typeof __opts.success == 'function'){
	queryParam.success = function(_data){
		__opts.success((_data.total>0?true:false),_data.total);
	};
	}
	$().apolloAjax(queryParam);
};

/**
	@constructor
	@description ajax方式多index更新数据库
	@parameter [{index:'sqlconfig1',other:''},{index:'sqlconfig2',other:''},....]
*/
function ajaxMultiUpdate(__opts){
	var queryData = toString(__opts.data);
	delete __opts.data;
	__opts.data = {};
	if(__opts.isLowerCase)__opts.data.lowerCase = true;
	__opts.data.parameter = queryData;
	var queryParam = $.extend({
		url:getDomain()+'/publicJson/multiUpdate.action'
	},__opts);
	//alert(toString(queryParam));
	if(typeof __opts.success == 'function'){
		queryParam.success = function(_data){
			__opts.success((_data.total>0?true:false),_data.total);
		};
	}
	$().apolloAjax(queryParam);
};

function ajaxSubmit(data,successCallBack){
	var queryParam = {};
	queryParam.data = data;
	//queryParam.url = getDomain()+'/publicJson/update.action';
	queryParam.url = ApolloURL.getAplQuery();
	queryParam.success = function(_data){
		if(typeof successCallBack == 'function'){
			successCallBack.call(this);
		}
	};
	$().apolloAjax(queryParam);
}
function setCookie(key,value){
	$().apolloAjax({
		url:getDomain()+'/publicJson/setCookie.action',
		data:{'key':key,'value':value},
		isAsync:false
	});
};

function getCookie(key,success){
	$().apolloAjax({
		url:getDomain()+'/publicJson/getCookie.action',
		data:{'key':key},
		isAsync:false,
		success:function(result){
			success(result.value);
		}
	});
};

function setSession(key,value){
	$().apolloAjax({
		url:getDomain()+'/publicJson/setSession.action',
		data:{'key':key,'value':value},
		isAsync:false
	});
};

function getSession(key,success){
	$().apolloAjax({
		url:getDomain()+'/publicJson/getSession.action',
		data:{'key':key},
		isAsync:false,
		success:function(result){
			success(result.value);
		}
	});
};


function hasRole(roles,success){
	$().apolloAjax({
		url:getDomain()+'/publicJson/checkRole.action',
		data:{'roleName':roles},
		isAsync:false,
		success:function(result){
			success(result.hasRole);
		}
	});
};
function debug(o){
	var toString = function(o){
		var r = [];
		if(typeof o =="string") return "\""+o.replace(/([\'\"\\])/g,"\\$1").replace(/(\n)/g,"\\n").replace(/(\r)/g,"\\r").replace(/(\t)/g,"\\t")+"\"";
		if(typeof o =="undefined") return "undefined";
		if(typeof o == "object"){
			if(o===null) return "null";
			else if(!o.sort){
				for(var i in o)
					r.push(i+":"+toString(o[i]));
				r="{"+r.join()+"}";
			}else{
				for(var i =0;i<o.length;i++)
					r.push(toString(o[i]));
				r="["+r.join()+"]";
			};
			return r;
		};
		return o.toString();
	};
	//alert(toString(o));
};

function $downloadResult(param,_allCount){
	if(_allCount && _allCount>10000 && !confirm('您下载的数据量比较大，需要耐心等待一会。您是否确认继续本次下载？'))return;
	var downLoadFrame = $('#QD_downloadIframe');
	if(downLoadFrame.length == 0){
		downLoadFrame = $('<iframe src="#" id="QD_downloadIframe" style="display:none"></iframe>');
		$('body').append(downLoadFrame);
	}
	if(typeof param == 'string')
		downLoadFrame.attr('src',param);
	else{
		var downParam = $.extend(true,{isAllElemt:true,isTitleShow:true,fileName:'result.gbk.csv.zip',elemt:{}},param);
		//var tmp = [];
		//var idx=0;
		if(typeof downParam.isAllElemt == 'string'){
			downParam.isAllElemt = downParam.isAllElemt == 'true' ? true : false;
		}
		//debug(downParam);
		var tmpKey = [];var tmpTitle = [];
		$.each(downParam.elemt,function(title,opt){
			if(downParam.isAllElemt || opt.isShow==null || opt.isShow){
				tmpTitle.push(encodeURI(title));
				tmpKey.push(opt.key);
			}
			/*
			if(opt.key!=null&&opt.key.length>0&&opt.key!='WF_IDX'){
				if(downParam.isAllElemt || opt.isShow ==null || opt.isShow)
					tmp.push('"'+encodeURI(title)+'":{key:"'+opt.key+'",idx:'+(idx++)+'}');				
			}
			*/
		});
		var parseEncode = function(value){
			//return value;
			return encodeURIComponent(value);
		};
		var downURLParam=getDomain()+'/tranTool/resultDownload.action?fileName='+(downParam.fileName)
				+'&downloadKeys='+tmpKey.join('|')+(downParam.isTitleShow?('&downloadTittles='+tmpTitle.join('|')):'');	
		$.each(downParam.data,function(key,value){
			downURLParam += '&'+key+'='+parseEncode(value);
		});
		//alert(downURLParam);
		downLoadFrame.attr('src',downURLParam+"&$r="+Math.random());
		waiting('close');
	}
};

function waiting(opt){
	if(typeof opt == 'undefined' || opt == 'open'){
		if($('.apolloWaiting').length==0){
			$('<div class="apolloWaiting" style="text-align:center"><img src="'+getDomain()+'/Apollo/images/loading.gif" width="150px" height="150px"/></div>')
			.appendTo('body').dialog({
				title:'正在处理数据，请您稍候...',
				width : 240,
				height : 190,
				resizable : false,
				closed : false,
				closable:false,
				modal : true
			});
		}
		$('.apolloWaiting').dialog('open');
	}else {
		$('.apolloWaiting').dialog('close');
	}
}

function loginOut(){
	$.cookie('saveLoginInfo',null);
	location.href = getDomain()+'/security/loginOut.action';
}

function parseNameByValue(value,_opt){
	//var opt = $.extend(true,{text:'text',value:'value',__options:{}},_opt);
	

};