var maplet = null;
/**Load Gis Engine...**/
function gisLoading(_gisParam){
	_default = {
				dom:'mapbar',
				center:'116.38672,39.90805',
				level:9,
				//width:500, //GIS宽度
				//height:400,//GIS高度
				//winWidth:300,//显示窗口宽度
				//winHeight:200,	//显示窗口高度
				dblclick:null,//注册地图双击事件(function)
				layerName:null, //注册地图图层名称 (gisEngine切图名称)
				minLevel:5,
				maxLevel:11
			};
	this.gisParam = $.extend(true,_default,_gisParam);
	GIS_MIN_LEVEL = this.gisParam.minLevel;
	GIS_MAX_LEVEL = this.gisParam.maxLevel;

	maplet = new Maplet(this.gisParam.dom);
	maplet.centerAndZoom(new MPoint(this.gisParam.center),this.gisParam.level); 
	maplet.addControl(new MStandardControl());   
	maplet.showOverview(true);
	MEvent.addListener(maplet, "layer_click", function(data) {  
	  alert(data.pid);  
	}); 

	//设置地图大小
	if(this.gisParam.width&&this.gisParam.height)maplet.resize(this.gisParam.width,this.gisParam.height);
	else {
		this.gisParam.width = maplet.width;
		this.gisParam.height = maplet.height;
	}
	//设置地图弹出信息窗口大小
	if(this.gisParam.winWidth&&this.gisParam.winHeight)maplet.setIwStdSize(this.gisParam.winWidth,this.gisParam.winHeight);
	if(typeof this.gisParam.dblclick == 'function'){
		var _callBack = this.gisParam.dblclick;
		
	}
	if(this.gisParam.layerName){
		this.addLayer(this.gisParam.layerName);
	}	

	$('#'+this.gisParam.dom).resize(function(){
		maplet.resize($(this).width(),$(this).height());
	});
};

var __layerCache = {};
var __layerItem; 
/**
*	增加叠加层
*/
gisLoading.prototype.addLayer = function(layerParam,opts){
	var opt = $.extend({
		isRegClickShowName:false,	//是否注册点击事件显示拓扑名称
		isMulti:false,				//是否执行多个叠加层
		isTranslate:null,			//是否转换加密后叠加层名称，为null时自动判定
		mapServer:null				//切图服务地址，默认使用webgisImgTileServer的切图服务地址
	},opts);

	if(opt.isRegClickShowName){
		var  p = new MPanel({  
			pin: true,  
			zindex: 5,  
		//	content:'<div style="background-color:red">ssss</div>',  
		//	location: {type:"latlon",x:0,y:0,pt:_pt},  
			zoomhide: true  
		});  
		MPanel.enableDragMap(p.dom,true);  
		maplet.addPanel(p);  
		p.hide();
		MEvent.clearListener(maplet, "click");
		MEvent.addListener(maplet, "click", function(e,poi){
			getEngineInfo("getKeyByXY",{layer:layerParam,target:poi.lon+','+poi.lat},function(r){
				p.setContent('<div style="background-color:#0068AE;color:#ffffff;border:1px solid #ffffff;padding:3px;">'+r+'</div>');
				p.setLocation({
					pt:new MPoint(poi.lon,poi.lat)
				});
				p.show();
			});

		}); 
	}
	
	this.gisParam.layerName = layerParam;//增加叠加层后，存储在对象中

	if(opt.isTranslate == null){
		opt.isTranslate = (layerParam.indexOf('@')>-1||layerParam.length!=32)&&layerParam.indexOf('/')==-1  ? true : false;
	}
	
	var showLayer  = function(_layerName){
		if(!opt.isMulti){
			if(__layerItem!=null)maplet.removeLayer(__layerItem.layer,true); 
		}
		__layerItem = {
				path:(opt.mapServer ==null ? (webgisImgTileServer+'/cutmap/'+_layerName+'/'):(opt.mapServer+'/'+_layerName+'/')),
				layer:null,
				pattern:_layerName+MLayer.DPLACEHOLDER
		}; 

		if(opt.isMulti){
			__layerCache[layerParam] = __layerItem;
		}

		__layerItem.layer = new MLayer({
			serverPath: __layerItem.path,
			needData: false,  
			imgType: "png",
			imgWidth: 16,
			imgHeight: 16,
			//dataType:'js',
			minLevel: GIS_MIN_LEVEL,
			maxLevel: GIS_MAX_LEVEL,
			dataPattern: __layerItem.pattern
		});
		maplet.addLayer(__layerItem.layer);
	};
	
	if(opt.isTranslate){
		getTransLayerName(this.gisParam.layerName,function(_layer){
			showLayer(_layer);
		});
	}else{
		showLayer(this.gisParam.layerName);
	}

	
};

gisLoading.prototype.removeLayer = function(layerName){
	if(__layerCache[layerName] && __layerCache[layerName].layer){
		maplet.removeLayer(__layerCache[layerName].layer,true); 
		delete __layerCache[layerName];
	}
};

gisLoading.prototype.isLayerExsit = function(layerName){
	return __layerCache[layerName] == null;
};

var _pointCache = {};
var _gisPointMarker;

gisLoading.prototype.isPointExsit = function(xy){
	return _pointCache[xy]==null;
};

gisLoading.prototype.getPointByXY = function(xy){
	return _pointCache[xy].pt;
};

gisLoading.prototype.focusPoint = function(_key){
	maplet.setCenter(_pointCache[_key].pt);
	_pointCache[_key].openInfoWindow();
};

gisLoading.prototype.addPoint = function(xy,opts){
	var opt = $.extend({
		isCenter:true,
		isMulti:false,
		icon:'poi.gif',
		info:null
	},opts);
	if(!opt.isMulti && _gisPointMarker!=null){
		maplet.removeOverlay(_gisPointMarker);	
	}
	var curPoi = new MPoint(xy);
	_gisPointMarker = new MMarker(   
			curPoi,
			new MIcon(webgisImgTileServer+"/images/"+opt.icon,26,26,13,26)
	); 
	if(opt.info != null){
		_gisPointMarker.info=new MInfoWindow(opt.info.title,opt.info.content);
	}
	maplet.addOverlay(_gisPointMarker);	
	if(opt.isCenter)maplet.setCenter(curPoi);
	if(opt.isMulti){
		_pointCache[xy] = _gisPointMarker;	
	}
};

gisLoading.prototype.removePoint = function(xy){
	if(_pointCache[xy]!=null){
		maplet.removeOverlay(_pointCache[xy]);
		delete _pointCache[xy];
	}
};

var defaultBrush = new MBrush();   
defaultBrush.color = "red";   
defaultBrush.stroke = 1;
defaultBrush.bgcolor = "green";   


var _lineCache = {};
var _gisLine;
gisLoading.prototype.addLine = function(xys,opts){
	var opt = $.extend({
		isAutoZoom:true,
		isMulti:false,
		brush:{},
		//lineKey:'line',
		info:null
	},opts);
	for(each in opt.brush){
		defaultBrush[each] = opt.brush[each];
	}
	if(!opt.lineKey)opt.lineKey = 'Line_'+xys.length;

	if(!opt.isMulti && _gisLine!=null){
		maplet.removeOverlay(_gisLine);	
	}
	var tmpPts = [];
	for(var i=0;i<xys.length;i++){
		tmpPts.push(new MPoint(xys[i]));
	}
	var _line = new MPolyline(tmpPts,defaultBrush); 
	if(opt.isMulti)
		_lineCache[opt.lineKey] = _line;
	else _gisLine = _line;

	if(opt.info != null){
		_line.info=new MInfoWindow(opt.info.title,opt.info.content);
	}
	maplet.addOverlay(_line);	
	if(opt.isAutoZoom)maplet.setAutoZoom();
};
gisLoading.prototype.removeLine = function(lineKey){
	if(_lineCache[lineKey]!=null){
		maplet.removeOverlay(_lineCache[lineKey]);	
		delete _lineCache[lineKey];
	}
};

gisLoading.prototype.focusLine = function(_key){
	if(_lineCache[_key]!=null){
		maplet.setCenter(_lineCache[_key].pts[0]);
		_lineCache[_key].openInfoWindow();
	}
};



gisLoading.prototype.dblClick = function(_callback){
	MEvent.addListener(maplet,"dbclick",function(evt,poi){
		_callback.call(this,poi.lon,poi.lat);
	});
};


/**
*	注册在叠加层上双击事件
**/
gisLoading.prototype.layerDBClick = function(_callback){
	var _layerName = this.gisParam.layerName;
	MEvent.addListener(maplet,"dbclick",function(evt,poi){
		getEngineInfo('getKeyByXY',{
			layer:_layerName,
			level:maplet.getZoomLevel(),
			target:(poi.lon+','+poi.lat)
		},function(r){
			if(r=='null')return;
			addPoint(poi.lon+','+poi.lat);
			_callback.call(this,r,poi.lon,poi.lat);
		});
	});
};

gisLoading.prototype.addOverView = function(param){
	var panelParam = $.extend({
			tagCss:'.overview',
			title:'',
			left:0,
			top:0,
			width:200,
			height:300,
			resizable:false,
			closable:false,
			minimizable:false,
			maximizable:false,
			collapsible:false,
			colorRuler:true,
			filter:0.9,
			tabs:[]
		},param);

		if(panelParam.top == 0){
			panelParam.top = $('#'+this.gisParam.dom).offset().top + 3;
		}
		if(panelParam.left == 0){
			panelParam.left = $('#'+this.gisParam.dom).offset().left + this.gisParam.width - panelParam.width - 2;
		}
		if(panelParam.colorRuler){
			if(!panelParam.tabs){
				panelParam.tabs = [];
			}
			getTransLayerName(this.gisParam.layerName,function(_layer){
				panelParam.tabs.push({
					title:'比例尺',
					content:'<iframe src="'+webgisImgTileServer+'/cutmap/'+_layer+'.html" style="width:'+(panelParam.width-40)+'px;height:'+(panelParam.height-40)+'px;margin-top:5px" frameborder="0" scrolling="no" scrolling="no"></iframe>'
				});
			});
		};

	var overview = $(panelParam.tagCss);
	if(overview.length == 0){
		overview = $('<div class="'+panelParam.tagCss.substring(1)+'" style="position:absolute;left:'+
			panelParam.left+'px;top:'+panelParam.top+'px;width:'+panelParam.width
			+'px;height:'+(panelParam.height)+
			'px;filter:alpha(opacity='+(panelParam.filter*100)+');-moz-opacity:'+panelParam.filter+';opacity:'+panelParam.filter+';"></div>').appendTo('body');
		overview.panel(panelParam).tabs().draggable({axis:null,handle:'.tabs-header'});
		if(panelParam.tabs.length>0){
			for(var i=0;i<panelParam.tabs.length;i++){
				var tab = panelParam.tabs[i];		
				var _content = '';
				if(typeof tab.content == 'function'){
					_content = '<div style="width:100%;height:100%;overflow:hidden" id="tabFun_'+i+'"></div>';  
				}else{
					if(tab.isFromDom){
						_content = $(tab.content).html();
						$(tab.content).remove();
					}else _content = tab.content;
				}
				overview.tabs('add',{
					title:tab.title,
					content:_content,
					closable:false,
					fit:true
				});
				if(typeof tab.content == 'function'){
					tab.content.call(this,$('#tabFun_'+i));
				}
			}
		}
	};
	overview.panel('open');
};


gisLoading.prototype.addDetailView = function(param){
	var panelParam = $.extend({
			tagCss:'.detailView',
			title:'区域详细信息',
			width:200,
			height:300,
			modal: false,
			resizable:false,
			closable:true,
			minimizable:false,
			maximizable:false,
			collapsible:true,
			colorRuler:true,
			filter:0.9,
			tabs:null
		},param);
	panelParam.style = {'position':'absolute','left':(maplet.width-panelParam.width-5)+'px','top':(panelParam.height+20)+'px','filter':'alpha(opacity='+(panelParam.filter*100)+')','-moz-opacity':panelParam.filter,'opacity':panelParam.filter};
	var detailView = $(panelParam.tagCss);
	if(detailView.length == 0){
		detailView = $('<div class="'+panelParam.tagCss.substring(1)+'" style="width:'+panelParam.width+'px;height:'+
			(panelParam.height-28)+'px"></div>').appendTo('body');
		detailView.panel(panelParam);
		detailView.parent().draggable({axis:null,handle:'.panel-header'});
	};
	detailView.panel('open');
	if(panelParam.tabs){
		detailView.tabs();
		for(var i=0;i<panelParam.tabs.length;i++){
			var tab = panelParam.tabs[i];
			var tmpContent ;
			if(typeof tab.content == 'string'){
				tmpContent = tab.content;
			}else if(typeof tab.table == 'object'){
				if(tab.table.data){
					ajaxQuery({
						isAsync:false,
						data:tab.table.data,
						success:function(rb){
							tmpContent = parseTable(rb,tab.table.columns);
							if(tab.changeBorderName!=undefined){
								if(typeof tab.changeBorderName == 'string'){
									var t = $('.panel-title',detailView.parent());
									t.html(tab.changeBorderName);
								}else if(typeof tab.changeBorderName == 'object'){
									var n=tab.changeBorderName.changeName;
									var t = $('.panel-title',detailView.parent());
									t.html(rb[0][n]+'区域详细信息');						
								}
							}
						}
					});
				}else if(tab.table.result){
					tmpContent = parseTable(tab.table.result,tab.table.columns);
				}
			}else if(typeof tab.chart == 'object'){
				var randomNumber = 'r'+Math.random();
				randomNumber = randomNumber.substring(randomNumber.indexOf('.')+1);
				var randomid = 'randomid'+randomNumber;
				if(tab.chart.el){
					randomid = tab.chart.el;
				}
				tmpContent='<div id="'+randomid+'"></div>';
			};
			if(!detailView.tabs('exists',tab.title)){
				detailView.tabs('add',{
					title:tab.title,
					content:tmpContent,
					closable:false,
					fit:true
				});
			}else{
				detailView.tabs('getTab',tab.title).panel({content:tmpContent});
			}
			if(typeof tab.chart == 'object'){
				var chartRegion = $(detailView);
				var chartConfig = $.extend(true,{el:randomid,wid:chartRegion.width()-20,hid:chartRegion.height()},tab.chart);
				renderChart(chartConfig);
			}
		}
	}
	if(typeof panelParam.content == 'function'){
		panelParam.content.call(this,$(panelParam.tagCss));
	}
};

function parseTable(rb,tableColumns){
	//if(rb.length==0)return "";
	var tmp = "<table class='apollo-form'>";
	var config;
	var hasValue = rb.length==0?false:true;
	for(var j=0;j<tableColumns.length;j++){
		config = tableColumns[j];
		if(!config.thWid)config.thWid = '50';
		var v = hasValue?rb[0][config.field]:0;
		if(typeof config.formatter =='function'){
			v =config.formatter.call(this,v,hasValue?rb[0]:0);
		}
		if(!config.hidden){	
			if(config.notVale){
				if(v!=0){
					tmp += '<tr><th colspan="2" align="center" '+(config.thWid?('width="'+config.thWid+'"'):'')+'>'+v+config.title+'</th></tr>';
				}else{
					tmp += '<tr><th colspan="2" align="center" '+(config.thWid?('width="'+config.thWid+'"'):'')+'>'+config.title+'</th></tr>';
				}
			}else if(config.notTitleVale){	
				tmp += '<tr><th colspan="2" align="center" '+(config.thWid?('width=\''+config.thWid+'\''):'')+'>'+v+'</th></tr>';
			}else{
				tmp += '<tr><th '+(config.thWid?('width=\''+config.thWid+'\''):'')+'>'+config.title+'</th><td '+(config.tdWid?('width:'+config.tdWid):'')+'>'+v+'</td></tr>';
			}
		}
	}
	tmp += '</table>';

	return tmp;
};

function getTransLayerName(_LayerName,_callback){
	getEngineInfo('getAppReName',{
		layer:_LayerName
	},function(r){
		_callback.call(this,r);	
	});
};

function addLayer(_LayerName){
	if(__layerItem && __layerItem.layer){
		maplet.removeLayer(__layerItem.layer,true);   
	}
	if(__layerItem==null){
		__layerItem = {
				path:webgisImgTileServer+'/cutmap/'+_layerName+'/',
				layer:null,
				pattern:_layerName+MLayer.DPLACEHOLDER
		}; 
	}
	/**先获取叠加层加密名称**/
	getTransLayerName(_LayerName,function(_layer){
		__layerItem.path = webgisImgTileServer+'/cutmap/'+_layer+'/';
		__layerItem.layer = new MLayer({   
		  serverPath: __layerItem.path,   
		  needData: false,           
		  imgWidth: 16,   
		  imgHeight: 16,   
		  minLevel: GIS_MIN_LEVEL,   
		  maxLevel: GIS_MAX_LEVEL,   
		  imgType: "png"
		});   
		maplet.addLayer(__layerItem.layer); 
	});
};

var __curMarker;
function addMarker(point,title,contnent,tabs){
	if(__curMarker!=null)maplet.removeOverlay(__curMarker);
	__curMarker = new MMarker(   
				new MPoint(point),
				new MIcon(webgisImgTileServer+"/images/pix.gif",1,1),
				new MInfoWindow(title,contnent)
	);   
	maplet.addOverlay(__curMarker);
	if(tabs){
		for(var i in tabs){
			__curMarker.info.setTabs(tabs[i].title,tabs[i].content);
		}
		__curMarker.openInfoWindow();
	}
};


var _gisPointMarker;
function addPoint(xy){
	if(_gisPointMarker!=null)maplet.removeOverlay(_gisPointMarker);
	_gisPointMarker = new MMarker(   
				new MPoint(xy),
				new MIcon(webgisImgTileServer+"/images/poi.gif",26,26,13,26)
	);   
	maplet.addOverlay(_gisPointMarker);
};


function getEngineInfo(_method,_data,_callBack){
	_url = typeof ApolloDomain == 'undefined' ? (webgisImgTileServer+'/'+_method+'.svr') : (ApolloDomain+'/gisSvr/'+_method+'.action');
	//if(_data.target)_data.target = encodeURI(_data.target);
	//alert(_data.target);	encodeURIComponent
	$.ajax({
		scriptCharset:'UTF-8',ifModified:true,cache:false,
		url:_url,
		data:_data,
		async:false,timeOut:10000,type:"POST",dataType:'text',success:function(r){
			_callBack.call(this,r);
		},error:function(r,t,e){
			alert(r.responseText);
		}
	});
}

/******展示帮助小工具********/

