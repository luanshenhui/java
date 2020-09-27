// Time-stamp: <Administrator at 2011-05-10 15:10:55>
//       .==.          .==.
//      //`^\\        //^`\\   
//     // ^ ^ \(\__/)/^  ^^\\
//    //^ ^^ ^ /6  6\ ^^ ^  \\
//   //^ ^^ ^ /( .. )\  ^^  ^\\
//  // ^^ ^/\|  v""v  |/\^ ^^ \\
// // ^^/\/ /   `~~`   \ \/\^ ^\\
//--------------------------------
// 	HERE BE DRAGONS

// Ver: 2010-10-13 baofengtian@kaitone.cn
//  
// Modify History:
// 2010-10-15 move to '/Apollo/ui.chart'
//


/*
 * 这个文件为fusionchart提供dom形数据
 */
var colors = '1D8BD1|F1683C|2AD62A|DBDC25|607142|8EAC41|A66EDD'.split('|'); 

String.prototype.endWith = function(str) {
	if (str == null || str == "" || this.length == 0
			|| str.length > this.length)
		return false;
	if (this.substring(this.length - str.length) == str)
		return true;
	else
		return false;
	return true;
};

String.prototype.startWith = function(str) {
	if (str == null || str == "" || this.length == 0
			|| str.length > this.length)
		return false;
	if (this.substr(0, str.length) == str)
		return true;
	else
		return false;
	return true;
};
String.prototype.contains = function(textToCheck) {
	return (this.indexOf(textToCheck) > -1);
};
/**
 * 
 * @param {} text
 * @return {} DOM
 */
function parseText(text) {
	var xmlDoc = null;
	try {// Internet Explorer
		xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		xmlDoc.async = "false";
		xmlDoc.loadXML(text);
	} catch (e) {
		try // Firefox, Mozilla, Opera, etc.
		{
			parser = new DOMParser();
			xmlDoc = parser.parseFromString(text, "text/xml");
		} catch (e) {
		}
	}
	return xmlDoc;
}

// check for XPath implementation for FF,CHROME
if(document.implementation.hasFeature("XPath", "3.0")){
    // prototying the XMLDocument
    XMLDocument.prototype.selectNodes = function(sXPathString, xNode){
    	if(!xNode)
    		xNode = this;
    	var oNSResolver = this.createNSResolver(this.documentElement);
    	var aItems = this.evaluate(sXPathString, xNode, oNSResolver,XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
    	var aResult = [];
    	for(var i=0;i<aItems.snapshotLength;i++)
    		aResult[i] = aItems.snapshotItem(i);
	    return aResult;
    };
    XMLDocument.prototype.selectSingleNode = function(sXPathString, xNode){
    	if(!xNode){
    		xNode = this;
	    	var xItems = this.selectNodes(sXPathString, xNode);
	    	if(xItems.length>0)
			    return xItems[0];
	    	else
			    return null;
    	}
    };
    // prototying the Element
    Element.prototype.selectNodes = function(sXPathString){
    	if(this.ownerDocument.selectNodes)
		    return this.ownerDocument.selectNodes(sXPathString, this);
	    else
	    	throw "For XML Elements Only";
    };
    Element.prototype.selectSingleNode = function(sXPathString){  
    	if(this.ownerDocument.selectSingleNode)
    		return this.ownerDocument.selectSingleNode(sXPathString, this);
    	else
    		throw "For XML Elements Only";
	};
}

/**
 * 
 * @param {} DOM
 * @return {} String
 */
function asXML(xml){
	if(xml.xml){//ie
		return xml.xml;
	}else{//FF
		if(typeof xmls=='undefined')
			xmls = new XMLSerializer();;
		return xmls.serializeToString(xml);
	}
}

function fushionChartConfigCreator(){
	//TODO nothing
}

fushionChartConfigCreator.prototype.newConfig=function(){
	var defaultConfig = parseText('<chart></chart>');
	var rootEl = defaultConfig.firstChild;
	var config = {'palette'				:'0',
					'caption'   		:'caption',
					'xAxisName' 		:'xAxisName',
					'yAxisName' 		:'yAxisName',
					'showValues'		:'0',
					'decimals'			:'0',
					'formatNumberScale'	:'0',
					chartRightMargin :'50',
					'useRoundEdges'		:'1'};
	for(var e in config)
		rootEl.setAttribute(e,config[e]);
	this.dom = defaultConfig;	
	return defaultConfig;
};
/**
 * 
 * @param {} configAndData{
 * 					'palette'				:'0',
					'caption'   		:'caption',
					'xAxisName' 		:'xAxisName',
					'yAxisName' 		:'yAxisName',
					'showValues'		:'0',
					'decimals'			:'0',
					'formatNumberScale'	:'0',
					'useRoundEdges'		:'1'
 	 *			categories:[{label:'categoryLabel1'}...],
 	 *			dataSets:[
	 * 							{   color:'red',
	 * 								seriesname:'eriesname',
	 * 								dataSet:{label:'label',value:'value',tips:'tips',click:'click'},
	 * 								...
	 * 							..}
	 * 						...]
 * 
 * }
 * 
 * @return {} DOM object xpath support 
 */
fushionChartConfigCreator.prototype.generateConfig=function(configAndData,rb){
	var defaultConfig = this.newConfig();
	//if(rb.length<1){
	//	return defaultConfig;
	//}
	var rootE = defaultConfig.documentElement;
	for(var e in configAndData){
		var config = configAndData[e];
		if(typeof config == 'string'){
			if(config){
				//defaultConfig[e]=config;
				rootE.setAttribute(e,config);
			}
		}
	}
	// 
	if(configAndData.setsRender){ // only the x axis ,no category
		for(var i = 0;i<configAndData.xMax;i++){
			var set = configAndData.setsRender.call(this,i,rb);
			var setNode = this.dom.createElement('set');
			rootE.appendChild(setNode);
			for(var p in set){
				var pa = set[p];
				if(typeof pa != 'undefined'){
					if(typeof pa == 'function'){
						setNode.setAttribute(p,pa());
					}else{
						setNode.setAttribute(p,pa);
					}
				}
			}
		}
		return defaultConfig;
	}
	if(configAndData.categories){
		
		var categoriesNode = this.dom.createElement('categories');
		rootE.appendChild(categoriesNode);
		var categories = configAndData.categories;
		for(var i = 0;i<categories.length;i++){
			var category = categories[i];
			if(category){
				var categoryNode = this.dom.createElement('category');//
				categoriesNode.appendChild(categoryNode);
				for(var e in category){
					var categoryE=category[e];
					if(typeof categoryE == 'function'){
						categoryNode.setAttribute(e,categoryE());
					}else{
						categoryNode.setAttribute(e,categoryE);
					}
				}
			}
		}
	}
	// 
	if(configAndData.dataSets){
		var dataSets = configAndData.dataSets;
		for(var i = 0;i<dataSets.length;i++){
			var dataSet = dataSets[i];
			var dataSetNode =this.dom.createElement('dataset'); 
			rootE.appendChild(dataSetNode);
			for(var e in dataSet){
				var el = dataSet[e];
				if(typeof el == 'array' || typeof el == 'object'){
					for(var j = 0;j<el.length;j++){
						var set = el[j];
						var setNode = this.dom.createElement('set');
						dataSetNode.appendChild(setNode);
						for(var p in set){
							var pa = set[p];
							if(typeof pa != 'undefined'){
								if(typeof pa == 'function'){
									setNode.setAttribute(p,pa());
								}else{
									setNode.setAttribute(p,pa);
								}
							}
						}
					}
				}else{
					if(typeof el == 'function'){
						dataSetNode.setAttribute(e,el());
					}else{
						dataSetNode.setAttribute(e,el);
					}
				}
			}
		}
	}
	// if exist renders use the renders
	if(!configAndData.xMax)configAndData.xMax=9;
	if(!configAndData.categoriesCount)configAndData.categoriesCount=2;
	if(!configAndData.xGradRender){
		configAndData.xGradRender = function(idx,rb){return {label:idx};};
	}
	var categoriesNode = this.dom.selectSingleNode('categories');
	if(!categoriesNode){
		categoriesNode = this.dom.createElement('categories');
		rootE.appendChild(categoriesNode);
	}
	for(var i = 0;i<configAndData.xMax;i++){
		var categoryNode = this.dom.createElement('category');//defaultConfig.selectSingleNode('//category['+i+']');
		categoriesNode.appendChild(categoryNode);
		var categoryConfig = configAndData.xGradRender.call(this,i,rb);
		if(!this.x)this.x=[];
		this.x.push(categoryConfig);
		for(var p in categoryConfig){
			var info = categoryConfig[p];
			if(typeof info == 'function'){
				categoryNode.setAttribute(p,info());
			}else{
				categoryNode.setAttribute(p,info);
			}
		}
	}
	
	if(!configAndData.categoryRender){
		configAndData.categoryRender = function(idx,rb){return {seriesname:idx,color:'1D8BD1'};};
	}
	if(!configAndData.tipsAndClickRender){
		configAndData.tipsAndClickRender = function(xIdx,categoryIdx,rb){return {tooltext:[xIdx,categoryIdx],link:'',value:[xIdx,categoryIdx]};};
	}
	for(var i = 0;i<configAndData.categoriesCount;i++){
		var dataSetNode = this.dom.createElement('dataset');
		rootE.appendChild(dataSetNode);
		var dataSetConfig = configAndData.categoryRender.call(this,i,rb);
		if(!this.category)this.category = [];
		this.category.push(dataSetConfig);
		for(var e in dataSetConfig){
			var info = dataSetConfig[e];
			if(typeof info == 'function'){
				dataSetNode.setAttribute(e,info());
			}else{
				dataSetNode.setAttribute(e,info);
			}
		}
		for(var j = 0;j<configAndData.xMax;j++){
			var setNode = this.dom.createElement('set');
			dataSetNode.appendChild(setNode);
			var setConfig = configAndData.tipsAndClickRender.call(this,j,i,rb);
			if(!this.value)this.value=[];
			if(!this.value[i])this.value[i]=[];
			this.value[i].push(setConfig);
			for(var e in setConfig){
				var value = setConfig[e];
				if(!value|| value==null||value=='null'||value=='')value = 0;
				if(typeof value == 'function'){
					setNode.setAttribute(e,value());
				}else{
					setNode.setAttribute(e,value);
				}
			}
		}
	}
	return defaultConfig;
};
if(typeof chartDataCreator=='undefined')chartDataCreator = new fushionChartConfigCreator();
if(typeof chart=='undefined')chart = new Object();
function loadChartData(renderTo,swfConfig,data,condition,swfChartDataProvider,beforeRenderChart){
	ajaxLoadResource(ApolloDomain+'/Apollo/ui.chart/js/FusionCharts.js',function(){
		/*alert('resource loaded')*/
		_loadChartData(renderTo,swfConfig,data,condition,swfChartDataProvider,beforeRenderChart);
	});
}
loadChartData.prototype.resize = function(size){
	
};
function _loadChartData(renderTo,swfConfig,data,condition,swfChartDataProvider,beforeRenderChart){
	
	//
	//initialize
	//var _self = this;
	if(typeof swfConfig == 'function')swfConfig = swfConfig();
	var chartType = swfConfig.chartType?swfConfig.chartType:'MSLine';
//	if(typeof this.chart == 'undefined'){
//		this.chartDataCreator = new fushionChartConfigCreator();
//	}
	var ChartIdNob = 'ChartId'+Math.random();
	this.chartDefaultConfig = {
		swf:ApolloDomain+'/Apollo/ui.chart/swf/'+chartType+'.swf',
		id:ChartIdNob,
		wid:'500',
		hid:'300',
		debugModeid:'0',
		registerWithJSid:'1'
	};
	
	this.chartDefaultConfig = $.extend(this.chartDefaultConfig,swfConfig);
	
	chart = new FusionCharts(this.chartDefaultConfig.swf,
							this.chartDefaultConfig.id, 
							this.chartDefaultConfig.wid, 
							this.chartDefaultConfig.hid, 
							this.chartDefaultConfig.debugModeid, 
							this.chartDefaultConfig.registerWithJSid); 
	//retrieve data
	if(typeof data == 'function')data = data();
	//alert(toString(data));
	if(data.index){
		ajaxQuery({
			data:data,
			success:function(rb){ // if success ,render chart
				//$debug(rb);
						if(typeof beforeRenderChart=='function'){
							var flag = beforeRenderChart.call(this,rb);
							if(!flag)return;
						}
						if(rb){
							var configAndData = swfChartDataProvider.call(this,rb);
							var xml = chartDataCreator.generateConfig(configAndData,rb);
							var xmlString = asXML(xml);
							chart.setDataXML(xmlString);
							chart.render(renderTo);
						}
					}
		});
	
	}else{
		if(typeof beforeRenderChart=='function'){
			var flag = beforeRenderChart.call(this,data);
			if(!flag)return;
		}
		if(data){
			var configAndData = swfChartDataProvider.call(this,data);
			var xml = chartDataCreator.generateConfig(configAndData,data);
			var xmlString = asXML(xml);
			//alert(xmlString)
			chart.setDataXML(xmlString);
			chart.render(renderTo);
		}
	}
}

//===================================
// for ajax
function GetHttpRequest() {
	if (window.XMLHttpRequest) // Gecko
		return new XMLHttpRequest();
	else if (window.ActiveXObject) // IE
		return new ActiveXObject("MsXml2.XmlHttp");
}

function ajaxLoadResource(url,successCallBack) {
	if(typeof ajaxResources=='undefined')ajaxResources = {};
	if(ajaxResources[url]){
		if(typeof successCallBack =='function')
			successCallBack.call(this);
		return;
	}
	var oXmlHttp = GetHttpRequest();
	oXmlHttp.onreadystatechange = function(){
		if (oXmlHttp.readyState == 4){
			if (oXmlHttp.status == 200 || oXmlHttp.status == 304){
				var flag=0;
				if(url.endWith('.js')){
					 flag = IncludeJS(url,oXmlHttp.responseText);
				}else if(url.endWith('.css')){
					 flag = IncludeCss(url,oXmlHttp.responseText);
				}else{
					alert('Only ".js" ,".css" is valid file extension!,Check function "ajaxLoadResource"');
				}
				ajaxResources[url]=oXmlHttp.responseText;
				if(flag && typeof successCallBack=='function')
					successCallBack.call(this);
			}else{
				alert('XML request error: ' + oXmlHttp.statusText + ' ('
						+ oXmlHttp.status + ')');
			}
		}
	};
	oXmlHttp.open('GET', url, true);
	oXmlHttp.send('');
}

function IncludeJS(fileUrl, source){
	if (source != null) {
		var oHead = document.getElementsByTagName('HEAD').item(0);
		var oScript = document.createElement("script");
		oScript.language = "javascript";
		oScript.type = "text/javascript";
		//oScript.id = sId;
		oScript.defer = true;
		oScript.text = source;
		oHead.appendChild(oScript);
		return true;
	}
}
function IncludeCss(fileUrl, source){
	if (source != null) {
		var oHead = document.getElementsByTagName('HEAD').item(0);
		var oStyle = document.createElement("link");
		oStyle.type="text/css";
		oStyle.rel="stylesheet";
		oStyle.href = fileUrl;
		oHead.appendChild(oStyle);
		return true;
	}
}
/**
 *  calculate the days between two date
 */
function DateDiff(sDate1, sDate2) { // sDate1和sDate2是2002-12-18格式
	var aDate, oDate1, oDate2, iDays;
	aDate = sDate1.split("-");
	oDate1 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0]); // 转换为12-18-2002格式
	aDate = sDate2.split("-");
	oDate2 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0]);
	iDays = parseInt(Math.abs(oDate1 - oDate2) / 1000 / 60 / 60 / 24); // 把相差的毫秒数转换为天数
	return iDays;
}
 

/**
 * 20100506 =>2010年05月06日
 */
function getLocaleDateString(dataString){
	if(dataString){
		var y = dataString.substring(0,4);
		var M = dataString.substring(4,6);
		var d = dataString.substring(6,8);
		return y+'年'+M+'月'+d+'日';
	}
}
/**
 * 返回结束日期
 * @param {} start_yyyyMMdd
 * @param {} n
 */
function AddDays(start_yyyyMMdd,n,format){
	//Month Day,Year Hours:Minutes:Seconds
	var y = start_yyyyMMdd.substring(0,4);
	var M = parseInt(start_yyyyMMdd.substring(4,6)-1)+'';
	var d = parseInt(start_yyyyMMdd.substring(6,8))+'';
	
	var nowDate = new Date(y,M,d);
	var date = _AddDays(nowDate,n);
	if(!format){
		return date.format('yyyyMMdd');//date.getYear()+''+date.getMonth()+''+date.getDay()+'';
	}
	return date.format(format);//date.getYear()+''+date.getMonth()+''+date.getDay()+'';
}

/**
 * 计算n天后的日期
 * @param {} startData
 * @param {} n
 */
function _AddDays(startData,n) {
	var newtimems = startData.getTime() + (n * 24 * 60 * 60 * 1000);
	startData.setTime(newtimems);
	//return startData.toLocaleString();
	return startData; 
}
//alert(AddDays(new Date(),30));
// ===================================
function loadXML(xmlFile){   
    var xmlDoc;   
    if(!window.ActiveXObject){   
        var parser = new DOMParser();   
        xmlDoc = parser.parseFromString(xmlFile,"text/xml");   
    }else{   
        xmlDoc = new ActiveXObject("Microsoft.XMLDOM");   
        xmlDoc.async="false";   
        xmlDoc.load(xmlFile);   
    }   
    return xmlDoc;   
}
	
//===
if(typeof dataProvider == 'undefined'){
	dataProvider ={
		
	};
}
dataProvider.getData = function(/*List or QueryParam*/opts,callBack){
	var param = opts.data;
	if(typeof param == 'object'){
		if(typeof param.index !='undefined'){
			ajaxQuery({
				data:param,
				success:function(data){
					if(data){
						if(typeof callBack == 'function'){
							callBack.call(this,data);
							$.data($('#'+opts.el)[0],'chartdata',data);
						}
						return data.rows;
					}
				}
			}); 
		}else if(typeof param.url !='undefined'){
			publicAjax({
				queryURL:param.url,
				data:param.param,
				success:function(data){
					if(data){
						if(typeof callBack == 'function'){
							callBack.call(this,data.rows);
							$.data($('#'+opts.el)[0],'chartdata',data.rows);
						}
						return data.rows;
					}
				}
			});
		}else{
			if(typeof callBack == 'function'){
				callBack.call(this,param);
			}
			return param;
		}
	}else if(typeof opts.result == 'object'){
		if(typeof callBack == 'function'){
			callBack.call(this,opts.result);
			$.data($('#'+opts.el)[0],'chartdata',opts.result);
		}
		return opts.result;
	}
	if(typeof param == 'string'){
		
	}
};

dataProvider.getRecommandChartDataProvider = function(opts,rawData){
    //TODO 这里分析原始数据,并提供图表数据
	var xLableField = opts.xLableField;
	var statCols = opts.statCols;
	var xCatalogNames = opts.xCatalogNames;
	var valueFixer = opts.valueFixer;
	var ret = null;
	if(!opts.statCols){
		ret = function swfChartDataProvider(rb){
			if(typeof opts.caption == 'function'){
				if(rb.length>0){
					opts.caption = opts.caption.call(this,rb);
				}else{
					opts.caption = 'no data';
				}
			}
			if(typeof opts.yAxisName == 'function'){
				if(rb.length>0){
					opts.yAxisName = opts.yAxisName.call(this,rb);
				}else{
					opts.yAxisName = 'no data';
				}
			}
			if(typeof opts.xAxisName == 'function'){
				if(rb.length>0){
					opts.xAxisName = opts.xAxisName.call(this,rb);
				}else{
					opts.xAxisName = 'no data';
				}
			}
			var config = {
				caption   			:opts.caption||'caption',
				xAxisName 			:opts.xAxisName||'x axis',
				yAxisName 			:opts.yAxisName||statCols[0]||'y axis',
				xMax				:opts.xMax || rb.length,
				setsRender          :opts.setsRender || function(idx,rb){
										var label = 'x-'+idx;
										if(typeof xLableField == 'function'){
											label = xLableField.call(this,rb,idx);
										}else if(typeof xLableField == 'string'){
											label = rb[idx][xLableField];
										}
										var value='0';
										var tooltext = label+':'+value;
										if(rb[idx]){
											value = rb[idx][statCols[0]];
											if(typeof valueFixer == 'function'){
												value = valueFixer.call(this,rb,idx,value);
											}
											tooltext = label+':'+value; 
										}
										return {label:label,value:value,tooltext:tooltext};
									}
			};
			for(var e in opts){
				if(typeof opts[e] != 'undefined' && typeof opts[e] != 'object'){
					config[e]=opts[e];
				}
			}
			return config;
		};
		
	}else{
		ret = function swfChartDataProvider(rb){
			if(typeof opts.caption == 'function'){
				if(rb.length>0){
					opts.caption = opts.caption.call(this,rb);
				}else{
					opts.caption = 'no data';
				}
			}
			if(typeof opts.yAxisName == 'function'){
				if(rb.length>0){
					opts.yAxisName = opts.yAxisName.call(this,rb);
				}else{
					opts.yAxisName = 'no data';
				}
			}
			if(typeof opts.xAxisName == 'function'){
				if(rb.length>0){
					opts.xAxisName = opts.xAxisName.call(this,rb);
				}else{
					opts.xAxisName = 'no data';
				}
			}
			var config = {
					caption   			:opts.caption||'caption',
					xAxisName 			:opts.xAxisName||'x axis',
					yAxisName 			:opts.yAxisName||'y axis',
					xMax				:opts.xMax||rb.length,
					categoriesCount		:opts.categoriesCount || statCols.length,
					xGradRender     	:opts.xGradRender || function(idx){
											var label = 'x-'+idx;
											if(typeof xLableField == 'function'){
												label = xLableField.call(this,rb,idx);
											}
											return {label:label || idx};
										},
					categoryRender		:opts.categoryRender || function(idx){// category
											var label = xCatalogNames?xCatalogNames[idx]:statCols[idx];
											return {seriesname:label,color:colors[idx%7]};
										},	
					tipsAndClickRender 	:opts.tipsAndClickRender || function(xIdx,categoryIdx){//value
											var value=0;
											value = rb != 'undefined' ? rb[xIdx][statCols[categoryIdx]] : '';
											if(typeof valueFixer == 'function'){
												value = valueFixer.call(this,rb,xIdx,value);
											}
											var xLable = 'x-'+xIdx;
											if(typeof xLableField == 'function'){
												xLable = xLableField.call(this,rb,xIdx);
											}
											var catalogLabel = xCatalogNames?xCatalogNames[categoryIdx]:statCols[categoryIdx];
											var label = xLable + '[' + catalogLabel + ']';
											return {
													tooltext	:label+':'+value,
													//link		:'j-chartLink-'+value+','+(xIdx+1),
													value		:value
													};
										}
			};
			for(var e in opts){
				if(typeof opts[e] != 'undefined' && typeof opts[e] != 'object'){
					config[e]=opts[e];
				}
			}
			return config;
		};
	}
    return ret;
};
dataProvider.computable = function(v){
	if(!v)return false;
	return !isNaN(v);
};
dataProvider.getChartOpts = function(opts,rawdata){
	//TODO 这里推导图表类型
	// to be choose the single seriase or the mutiple seriase and the 2D chart or the 3D chart.
	var chartType = 'Column3D';
	var statType = {};
	for(var i=0;i<rawdata.length;i++){
		var record = rawdata[i];
		for(var k in record){
			var field = record[k];
			if(typeof statType[k]=='undefined' || statType[k] === true){
				statType[k] = dataProvider.computable(field);
			} 
		}
	}//以上迭代用于查找记录中是字段是否为可统计的.
	var statCols = [];
	for(var e in statType){
		if(statType[e]){
			statCols.push(e);
		}
	}
	opts.statCols = opts.statCols || statCols;
	if(opts.statCols.length>1){// 可统计的所有列多于1个时,使用多系列图表
		chartType = 'MSColumn3D';
	}
	var ret = $.extend(true,{},{chartType:opts.chartType || chartType,wid:opts.wid||600,hid:opts.hid||310});
	return ret;
};
/**
 * 
 * @param {} opts
 * {
 * 		el:'chartDiv',*图表的html节点ID,必需
 * 		data:{index:'xxx'}*,图表数据来源,必需
 * 		dataProvider:function(){}, 如需细粒度控制图表,则定义此参数,不推荐使用此参数
 * 		caption:'xxxxxx图表',
 * 		xAxisName:'xxxx',
 * 		yAxisName:'yyyy',
 * 		onBefore:function(){},
 * 		statCols:['ATTR_NUM'],y轴显示记录的哪几列,
 * 		xCatalogNames:['属性名儿'],显示多组数据时,位于图下方描述一组数据的各个数据.
 * 		chartType:'MSColumn3D',图表类型,参考FusionChart文档
 * 		wid:600,宽
 * 		hid:310,高
 * 		xLableField:function(rb,idx){},x轴上组个刻度下方的描述
 * 		valueFixer:function(rb,idx){},数据需要处理的话重定义此函数
 * 		xMax:100,x轴最大值
 * 		categoriesCount:3,一组数据可以有
 * 		xGradRender:function(){},同xLableField
 * 		categoryRender:function(){},类别描述
 * 		tipsAndClickRender:function(){},文字提示
 * }
 */
function renderChart(opts){
	var el = opts.el||'chartDiv';
	opts.swfChartDataProvider = opts.dataProvider;
	dataProvider.getData(opts,function(ret){
//		if(ret.length<1)return true;
		var chartOpts = dataProvider.getChartOpts(opts,ret);
		var swfChartDataProvider = dataProvider.getRecommandChartDataProvider(opts,ret);
		if(typeof opts.swfChartDataProvider == 'function'){
			swfChartDataProvider = opts.swfChartDataProvider;
		}
		var nullCondition = function(){};
		if(!swfChartDataProvider)return false;
		_loadChartData(el,chartOpts,ret,nullCondition,swfChartDataProvider,opts.onBefore||function(){return true;});
	});
}
/*
 * jQuery extend
 */
(function($){
	$.fn.fusionchart=function(options,param){
		if (typeof options == 'string') {
			return $.fn.fusionchart.methods[options](this, param);
		}
		return this.each(function(){
			if(typeof options.el == 'undefined'){
				if(typeof $(this).attr("id") == 'undefined' || $(this).attr("id")==''){
					$(this).attr("id","chartDiv");
				}
				options.el = $(this).attr("id");
			}
			if(typeof options.wid == 'undefined'){
				options.wid = $(this).parent().width()-10;
			}
			if(typeof options.hid == 'undefined'){
				options.hid = $(this).parent().height()-40;
			}
			$.data(this,'options',options);
			renderChart(options);
		});
	};
	function reRender(el,incrementleParameters){
		var opts = $.data(el,'options');
		if(incrementleParameters){
			opts = $.extend(true,opts,incrementleParameters);
			return $(el).fusionchart(opts);
		}
	}
	$.fn.fusionchart.methods={
		refresh:function(jq,param){
			return reRender(jq[0],{data:$.data(jq[0],'chartdata')});
		},
		resize:function(jq,param){
			return reRender(jq[0],param);
		}
	};
})(jQuery);

function getFuncName(_callee) {
	var _text = _callee.toString();
	var _scriptArr = document.scripts;
	for (var i = 0; i < _scriptArr.length; i++) {
		var _start = _scriptArr[i].text.indexOf(_text);
		if (_start != -1) {
			if (/^function\s*\(.*\).*\r\n/.test(_text)) {
				var _tempArr = _scriptArr[i].text.substr(0, _start)
						.split('\r\n');
				return _tempArr[_tempArr.length - 1]
						.replace(/(var)|(\s*)/g, '').replace(/=/g, '');
			} else {
				return _text.match(/^function\s*([^\(]+).*\r\n/)[1];
			}
		}
	}
}
/*
function a() {
	return getFuncName(arguments.callee);
}
var b = function() {
	return getFuncName(arguments.callee);
}
alert(a());
alert(b());
*/