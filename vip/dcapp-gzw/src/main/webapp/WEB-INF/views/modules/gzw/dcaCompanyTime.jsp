<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>DacCompany管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript" src="/static/gzw/js/echarts.min.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
		    $.get(ctx+'/dca/dcaCompany/reportTimeData', {}, function (result) {
			if (!result) {
		            alertx('获取数据失败');
			}else {
				var data = JSON.parse(result);
				//console.log(data)
				if(data){
					drawWorkBar(data);
				}
			}
		});
	});
	
	function drawWorkBar(data){

    var titleName = '审核结果上传时间排名';
    var companyName = data.companylist;
    var labels = [];
    for(var i = 0,len = companyName.length;i < len;i++){
		labels[i] = companyName[i];
	}
    // 基于准备好的dom，初始化echarts实例
   	var workBar = echarts.init(document.getElementById('workStat'));  
	  
		option = {
		title: {
		  text: titleName
		 },
	    legend: {
         data: labels
        },

	    dataRange: {
	        min: 0,
	        max: companyName.length,
	        y: 'center',
	        text:['最先上传','最后上传'],           // 文本，默认为数值文本
	        color:['red','yellow'],
	        calculable : true
	    },
	      xAxis: {
    type: 'category',
    data: companyName,
    axisLabel:{
    	show : false
    }
},
         yAxis:  {
             type: 'value'
         },
	    series : [
	        {
	            name:labels,
	            type:'scatter',
	            symbolSize:1,
	            itemStyle:{
	            	normal:{
	            		label:{
	            			show:true,
	            			position:'top',
	            			formatter:'{b}',
	            			textStyle:{
	            				color: 'red',
	            				fontSize: 14,
	            				fontStyle:'oblique',
	            				fontWeight:'bolder'
	            			}
	            		}
	            	}
	            },
	            data: (function () {
	                var d = [];
	                var len = companyName.length;
	                var value;
	                while (len--) {
	                    value =len;
	                    d.push([
	                        value,
	                        value,
	                        value
	                    ]);
	                }
	                return d;
	            })()
	        }
	    ]
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