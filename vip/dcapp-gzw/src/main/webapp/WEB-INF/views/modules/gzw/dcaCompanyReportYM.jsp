<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>DacCompany管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript" src="/static/gzw/js/echarts.min.js"></script>
	<script type="text/javascript">
	$(document).ready(function() {
    	   $.get(ctx+'/dca/dcaCompany/reportYmData', {}, function (result) {
    			if (!result) {
    	            alertx('获取数据失败');
    		}else {
    			var data = JSON.parse(result);
    			//console.log(data)
    			if(data){
    				_drawRiskLine(data);
    			}
    		}
    	   });
	});
	
	function _drawRiskLine(data){
 	   	
    	var labels = [];
    	var companyName = data.companylist;
    	for(var i = 0,len = companyName.length;i < len;i++){
    		labels[i] = companyName[i];
    	}

        var company = data.dcaCompany;
        var titleName =  company.companyName+ company.companyY+'年度每月审核结果';
    	// 基于准备好的dom，初始化echarts实例
       	var workBar = echarts.init(document.getElementById('workStat'));

       	var errdata = new Array();
       	var errdataCount = [];
       	var legendName = [];
    	var reviewTypelist = data.reviewTypelist;
    	for(var i = 0,len = reviewTypelist.length;i < len;i++){
    		legendName[i] = reviewTypelist[i];
    	}
    	legendName.push('合计');
    	
    	var typelist = data.typelist;
    	for(var i = 0,len = typelist.length;i < len;i++){
    		errdata[i] = new Array();
    		var typeCountClist = typelist[i];
    		for(var j = 0,len1 = typeCountClist.length;j < len1;j++){
    			errdata[i][j]=typeCountClist[j]
    		}
    	}

       	var errdatasum = [];
       	var sumlist = data.sumlist;
       	for(var i = 0,len = sumlist.length;i < len;i++){
       		errdatasum[i] = sumlist[i];
       	}
       	
       	option = {
     		   title: {
         text: titleName
        },
         legend: {
             data: legendName
         },
         grid: {
             left: '3%',
             right: '4%',
             bottom: '3%',
             containLabel: true
         },
         yAxis:  {
             type: 'value'
         },
         xAxis: {
             type: 'category',
             data: labels,
             axisTick: {
                 alignWithLabel: true
             }
         },

         toolbox: {
             feature: {
                 dataView: {show: true, readOnly: false},
                 magicType: {show: true, type: ['line', 'bar']},
                 restore: {show: true},
                 saveAsImage: {show: true}
             }
         },
         
         series:function(){ 
        	 var serie=[]; 
        	 //var aa = zhonglei[0].split(","); 
        	 for(var i = 0,len3 = reviewTypelist.length;i < len3;i++){
        	 var item={ 
        	 name:reviewTypelist[i], 
             type: 'bar',
             stack: '总量',
             label: {
                 normal: {
                     show: true,
                     position: 'insideRight'
                 }
             },
             barWidth:30,
        	 data:errdata[i]
        	 } 
        	 serie.push(item);
        	 }; 
        	 
        	 var item1={
    	             name: '合计',
    	             type: 'line',
    	             label: {
    	                 normal: {
    	                     show: true,
    	                     position: 'insideRight'
    	                 }
    	             },
    	             itemStyle: {
    	                 normal: {
    	                     barBorderWidth: 6,
    	                     barBorderRadius:0,
    	                     label : {
    	                         show: true, 
    	                         position: 'top',
    	                         textStyle: {
    	                             color: 'tomato'
    	                         }
    	                     }
    	                 }
    	             },
    	                 
    	             data: errdatasum 
        	 }
        	 serie.push(item1);
        	 
        	 return serie; 
        	 }()
     };
    	
    	// 使用刚指定的配置项和数据显示图表。
        workBar.setOption(option);
    }
	
	</script>
</head>

<body>
	<div id="workStat" style="height:400px;"></div>
	<li class="btns pull-right">
   <input id="btnCancel" class="btn-s btn-opear" type="button" value="     返 回    " onclick="history.go(-1)"/>
</li> 
</body>
</html>