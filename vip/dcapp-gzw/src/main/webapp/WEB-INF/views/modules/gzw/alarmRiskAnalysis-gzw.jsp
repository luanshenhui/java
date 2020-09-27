<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<title>数据铁笼-融合分析-告警风险分析</title>
<link rel="stylesheet" type="text/css" href="/static/gzw/css/style.css" />
<link rel="stylesheet" type="text/css" href="/static/gzw/css/model.css" />
<link rel="stylesheet" type="text/css" href="/static/gzw/css/risk-level.css" />
<script type="text/javascript">var ctx = '${ctx}', ctxStatic='${ctxStatic}';</script>
<script src="/static/gzw/js/jquery-1.8.3.js"></script>
<script src="/static/gzw/js/echarts.min.js"></script>
<script src="/static/gzw/js/jquery.fusion.analysis.detail.js" type="text/javascript"></script>

<div class="wrap" id="fusionAnalysisDetailGZW">
	<div class="container">
		<div class="box">
			<div class="box-head">
				<input type="hidden" id="companyId" value="${companyId}">
				<a href="${ctx}/gzw/homepageInfo" class="arrow-back"><i></i>首页</a>
                <a href="${ctx}/gzw/businessDataVolume" class="arrow-back arrow-back2"><i></i>融合分析</a>
                <p class="box-title">${companyName}</p>
                <a href="javascript:void(0)" class="arrow-left"><i></i></a>
                <a href="javascript:void(0)" class="arrow-right"><i></i></a>
			</div>
            <div class="box-container">
                <div class="box-left">
                    <ul>
                        <li class="on" data-id="alarmRisk">
                            <a href="javascript:void(0)">告警风险分析</a>
                        </li>
                        <li data-id="riskDefine">
                            <a href="javascript:void(0)">风险界定分析</a>
                        </li>
                        <li data-id="riskTrend">
                            <a href="javascript:void(0)">风险走势分析</a>
                        </li>
                    </ul>
                </div>
                <div class="box-right">
                    <div class="box-right-title">
                        <p data-id="fusionAnalysisDetailTitle"><i></i>告警风险分析</p>
                    </div>
                    <div class="box-right-form risk-define-statistics">

                        <div class="risk-form-main alarm-risk-stat" data-id="main-fusionAnalysisDetail">
                        	<div data-id="company-alarmRisk">
	                            <div class="form-chart-left">
	                                <div id="main" class="main"></div>
	                                <div id="main1" class="main"></div>
	                            </div>
	                        	<div id="main2"></div>
                        	</div>
                        	<div data-id="company-riskDefine">
		                        <div id="risk-define-analysis" class="risk-define-analysis"></div>
                        	</div>
                        	<div data-id="company-riskTrend">
                        		<div id="risk-trend-analysis" class="risk-trend-analysis"></div>
                        	</div>
                        </div>
                    </div>
                </div>
                <div class="clear"></div>
            </div>
		</div>
	</div>
</div>
<!-- <script type="text/javascript">
    var myChart = echarts.init(document.getElementById('main'));
    option = {
        title:{text:'风险分析',textStyle:{fontSize:'24',color:'#fff'}},
        tooltip: {
            trigger: 'item',
            formatter: "{a} <br/>{b}: {c} ({d}%)"
        },
        legend: {
            orient: 'vertical',
            x: 'right',
            itemHeight: '10',
            padding: [90,0,20,20],
            data:['重大决策','重大事项','重要人事','大额资金'],textStyle:{fontSize:'20',color:'#fff'}
        },
        series: [
            {
                name:'访问来源',
                type:'pie',
                radius: ['30%', '70%'],
                avoidLabelOverlap: false,
                label: {
                    normal: {
                        show: true,
                        position: 'outside',
                        formatter: "{d}%",
                        textStyle:{
                            fontSize: '20',
                            fontWeight: 'bold'
                        }
                    },
                    emphasis: {
                        show: true,
                        textStyle: {
                            fontSize: '20',
                            fontWeight: 'bold'
                        }
                    }
                },
                labelLine: {
                    normal: {
                        show: true,
                        length:20
                    }
                },
                data:[
                    {value:20, name:'重大决策'},
                    {value:17, name:'重大事项'},
                    {value:26, name:'重要人事'},
                    {value:16, name:'大额资金'}
                ]
            }
        ]
    };
    myChart.setOption(option);

    var myChart1 = echarts.init(document.getElementById('main1'));
    option1 = {
        title:{text:'告警分析',textStyle:{fontSize:'24',color:'#fff'}},
        tooltip: {
            trigger: 'item',
            formatter: "{a} <br/>{b}: {c} ({d}%)"
        },
        legend: {
            orient: 'vertical',
            x: 'right',
            itemHeight: '10',
            padding: [60,0,20,20],
            data:['重大决策','重大事项','重要人事','大额资金'],textStyle:{fontSize:'20',color:'#fff'}
        },
        series: [
            {
                name:'访问来源',
                type:'pie',
                radius: ['30%', '70%'],
                avoidLabelOverlap: false,
                label: {
                    normal: {
                        show: true,
                        position: 'outside',
                        formatter: "{d}%",
                        textStyle:{
                            fontSize: '20',
                            fontWeight: 'bold'
                        }
                    },
                    emphasis: {
                        show: true,
                        textStyle: {
                            fontSize: '20',
                            fontWeight: 'bold'
                        }
                    }
                },
                labelLine: {
                    normal: {
                        show: true,
                        length:20
                    }
                },
                data:[
                    {value:15, name:'重大决策'},
                    {value:20, name:'重大事项'},
                    {value:25, name:'重要人事'},
                    {value:23, name:'大额资金'}
                ]
            }
        ]
    };
    myChart1.setOption(option1);

    var myChart2 = echarts.init(document.getElementById('main2'));
    option2 = {
        title:{text:'业务事项分析',textStyle:{fontSize:'24',color:'#fff'}},
        color: ['#3398DB'],
        tooltip : {
            trigger: 'axis',
            axisPointer : {            // 坐标轴指示器，坐标轴触发有效
                type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
            }
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            containLabel: true
        },
        xAxis : [
            {
                type : 'category',
                data: [{
                    value: '重大决策',
                    textStyle: {
                        fontSize: 20,
                        color: '#fff'
                    }
                },{
                    value: '重大事项',
                    textStyle: {
                        fontSize: 20,
                        color: '#fff'
                    }
                },{
                    value: '重要人事',
                    textStyle: {
                        fontSize: 20,
                        color: '#fff'
                    }
                },{
                    value: '大额资金',
                    textStyle: {
                        fontSize: 20,
                        color: '#fff'
                    }
                },{
                    value: '投资',
                    textStyle: {
                        fontSize: 20,
                        color: '#fff'
                    }
                },{
                    value: '担保',
                    textStyle: {
                        fontSize: 20,
                        color: '#fff'
                    }
                }],




                axisTick: {
                    alignWithLabel: true
                }

            }
        ],
        yAxis : [
            {
                type : 'value',
                axisLabel:{
                    textStyle:{
                        color:'#7a7a7a',
                        fontSize:20
                    }
                }
            }
        ],
        series : [
            {
                name:'业务事项分析',
                type:'bar',
                barWidth: '60%',
                data:[10, 52, 200, 334, 390, 330],
                label:{
                    normal:{
                        show:true,
                        position:'top',
                        textStyle:{
                            color:'#ffc700'
                        }
                    }
                }
            }
        ]
    };
    myChart2.setOption(option2);
</script> -->