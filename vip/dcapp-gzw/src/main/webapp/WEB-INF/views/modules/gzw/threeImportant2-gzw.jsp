<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<title>数据铁笼三重一大2</title>
<link rel="stylesheet" type="text/css" href="/static/gzw/css/style.css" />
<link rel="stylesheet" type="text/css" href="/static/gzw/css/model.css" />
<link rel="stylesheet" type="text/css" href="/static/gzw/css/risk-level.css" />
<script src="/static/gzw/js/echarts.min.js"></script>
<script src="/static/gzw/js/jquery-1.8.3.js"></script>
<script src="/static/gzw/js/js.js"></script>
<div class="wrap">
	<div class="container">
		<div class="box">
			<div class="box-head">
				<a href="firstpage.html" class="arrow-back"><i></i>首页</a>
                <p class="box-title">三重一大</p>
               <!-- <a href="javascript:void(0)" class="arrow-left"><i></i></a>
                <a href="javascript:void(0)" class="arrow-right"><i></i></a>-->
			</div>
            <div class="box-container">
                <div class="box-left">
                    <ul>
                        <li class="on">
                            <a href="gzw-threeImportant1.html">重大事项</a>
                        </li>
                        <li>
                            <a href="gzw-majorProjectArrangement.html">重大项目</a>
                        </li>
                        <li>
                            <a href="gzw-majorPersonnel.html">重要人事</a>
                        </li>
                        <li>
                            <a href="gzw-largeAmount.html">大额资金</a>
                        </li>
                    </ul>
                </div>
                <div class="box-right">
                    <div class="box-right-title">
                        <p><i></i>重大事项
                            <span class="tab title-tab">
                                <a href="gzw-threeImportant1.html" class="title-tab1">流程节点分析</a>
                                <a href="javascript:void(0)" class="title-tab2 on">风险汇总分析</a>
                            </span>
                        </p>
                    </div>
                    <div class="box-right-form  three-important">
                        <div class="risk-form-main">
                           <div class="form-left">
                               <div class="decision-making">
                                   <ul>
                                       <li class="on">投资运营专委会</li>
                                       <li>业绩考核专委会</li>
                                       <li>经营性资产监管专委会</li>
                                       <li>产权管理专委会</li>
                                       <li>财务监督专委会</li>
                                       <li>改革重组专委会</li>
                                   </ul>
                               </div>
                               <div id="chart1"></div>
                           </div>
                           <div class="form-right">
                               <div class="lg-box">
                                   <p>各专委会风险状况</p>
                                    <span class="tab title-tab">
                                        <a href="javascript:void(0)" class="title-tab1 "><span class="">本月</span> </a>
                                        <a href="javascript:void(0)" class="title-tab3 on">近半年</a>
                                        <a href="javascript:void(0)" class="title-tab2"> <span class="">近一年</span></a>
                                     </span>
                                   <div id="chart2"></div>
                                   <div class="risk-color">
                                       <span class="chart2-title1"><i></i>投资运营</span>
                                       <span class="chart2-title2"><i></i>业绩考核</span>
                                       <span class="chart2-title4"><i></i>产权管理</span>
                                       <span class="chart2-title5"><i></i>财务监督</span>
                                       <span class="chart2-title6"><i></i>改革重组</span>
                                       <span class="chart2-title3"><i></i>经营性资产监管</span>
                                   </div>
                               </div>
                           </div>
                        </div>
                    </div>
                </div>
                <div class="clear"></div>
            </div>

		</div>
	</div>
 </div>
 <script type="text/javascript">
    var myChart1 = echarts.init(document.getElementById('chart1'));
    option = {
        tooltip: {
            trigger: 'axis'
        },
        toolbox: {
            feature: {
                saveAsImage: {show: true}
            }
        },
        legend: {
            data:['投资运营专委会','业绩考核专委会']
        },
        xAxis: [
            {
                type: 'category',
                data: ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月'],
                axisLabel:{textStyle:{fontSize:20,color:'#7a7a7a'}}
            }
        ],
        yAxis: [
            {
                type: 'value',
                axisLabel:{textStyle:{fontSize:20,color:'#7a7a7a'}}
            }
        ],
        series: [
            {
                name:'总量',
                type:'bar',
                barWidth:'20',
                itemStyle : { normal: {color:'#02bdf4',label : {show: true, position: 'top',textStyle:{fontSize:20 }}}},
                data:[45, 15, 70, 45, 25, 76, 60, 62, 32, 20, 64, 33]
            },
            {
                name:'总量',
                type:'line',
                itemStyle : { normal: {color:'#ffff00',textStyle:{fontSize:20 }}},
                data:[45, 15, 70, 45, 25, 76, 60, 62, 32, 20, 64, 33]

            }
        ]
    };
   myChart1.setOption(option);

   var myChart2 = echarts.init(document.getElementById('chart2'));
   option2 = {
       tooltip: {
           trigger: 'item',
           formatter: "{a} <br/>{b}: {c} ({d}%)"
       },
       series: [
           {
               type:'pie',
               selectedMode: 'single',
               radius: [0, 0],
               label: {
                   normal: {
                       position: 'inner'
                   }
               },
               labelLine: {
                   normal: {
                       show: false
                   }
               },
               data:[
                   {label:{normal:{position:'inner',textStyle:{fontSize:20,color:'#fff'}}},value:100, name:'风险', selected:true}
               ]
           },
           {
               type:'pie',
               radius: ['30%', '70%'],
               label: {
                   normal: {
                       position: 'out',
                       textStyle:{
                           fontSize:13
                       }
                   }
               },
               data:[
                   {value:5, name:'5%',itemStyle:{normal:{color:'#81c5f2'}}},
                   {value:10, name:'10%',itemStyle:{normal:{color:'#8c2766'}}},
                   {value:15, name:'15%',itemStyle:{normal:{color:'#2dbedc'}}},
                   {value:20, name:' 20%',itemStyle:{normal:{color:'#d22c2d'}}},
                   {value:20, name:'20%',itemStyle:{normal:{color:'#2cbe50'}}},
                   {value:30, name:'30%',itemStyle:{normal:{color:'#ec9320'}}}
               ]
           }
       ]
   };
   myChart2.setOption(option2);

</script>
