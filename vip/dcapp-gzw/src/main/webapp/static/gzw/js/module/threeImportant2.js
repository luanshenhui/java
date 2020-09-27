/**
 * Created by 11150321050124 on 2017/1/12.
 */

$(function () {

    var arrId = ['01','02','04'];
    var arrTitle = ['A','B','C','D','E','F'];

    var j = $('.box-left>ul>li.on').index();

    if( j >= 2 ){ j=2 }

    var i = $('.three-important .decision-making>ul>li.on').index();

    funBar();

    $('.three-important .decision-making>ul>li').click(function(){
        $(this).addClass('on').siblings().removeClass('on');
        i = $(this).index();
        funBar();
    });

    function funBar(){
        $.post("/a/index/api",{
            _id:'gzw_three_important_risk_count',
            arr1: arrId[j],
            arr2: arrTitle[i]
        },function (res1) {
            var data1=[];
            $.each(res1,function(n1,o){
                data1[n1] = res1[n1].DATA_COUNT;
            });
            _riskCount(data1);
        });
    }

    function _riskCount(data1){
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
                    axisLabel:{
                        show: false
                    },
                    axisTick:{
                        show: false
                    }
                    //axisLabel:{textStyle:{fontSize:20,color:'#7a7a7a'}}
                }
            ],
            series: [
                {
                    name:'风险',
                    type:'bar',
                    barWidth:'20',
                    itemStyle : { normal: {color:'#02bdf4',label : {show: true, position: 'top',textStyle:{fontSize:20 }}}},
                    data:data1
                },
                {
                    name:'总量',
                    type:'line',
                    itemStyle : { normal: {color:'#ffff00',textStyle:{fontSize:20 }}},
                    data:data1
                }
            ]
        };
        myChart1.setOption(option);
    }

    var pieTitle = ['-1','-6','-12'];
    var pn = $('.form-right .pie-title>a.on').index();
    funPie();
    $('.form-right .pie-title>a').click(function(){
        pn = $(this).index();
        funPie();
    });

    function funPie(){
        $.post("/a/index/api",{
            _id:'gzw_three_important_pie',
            arr1: arrId[j],
            arr2: pieTitle[pn]
        },function (res2) {

            var data2=[];
            var legendData=[];
            $.each(res2,function(n2,o){
                data2.push(o.DATA_COUNT);
                legendData.push(o.DATA_TITLE);
            });
            _riskPie(data2,legendData);

        });
    }

    function _riskPie(data2,data3){
        var myChart2 = echarts.init(document.getElementById('chart2'));
        option2 = {
            tooltip: {
                trigger: 'item',
                formatter: "{a} <br/>{b}: {c} ({d}%)"
            },
            legend: {
                orient: 'horizontal',
                bottom: 'bottom',
                itemGap:30,
                //width: 80,
                textStyle:{fontSize:18,color:'#fff'},
                data: data3
            },
            series: [
                {
                    type:'pie',
                    selectedMode: 'single',
                    center: ['50%', '40%'],
                    radius: [0, 0],
                    label: {
                        normal: {
                            position: 'inner'
                        }
                    },
                    data:[
                        {label:{normal:{position:'inner',textStyle:{fontSize:20,color:'#fff'}}},value:100, name:'风险', selected:true}
                    ]
                },
                {
                    name:'各专委会风险状况：',
                    type:'pie',
                    center: ['50%', '40%'],
                    radius: ['30%', '70%'],
                    label: {
                        normal: {
                            show:false,
                            position: 'out',
                            textStyle:{
                                fontSize:13
                            }
                        }
                    },
                    data:[]
                }
            ]
        };


        var colors=['#81c5f2','#8c2766','#2dbedc','#d22c2d','#2cbe50','#ec9320','#e020ec','#1e04e8'];
        for(var i=0;i<=data2.length;i++){
            option2.series[1].data.push({value:data2[i], name:data3[i],itemStyle:{normal:{color:colors[i]}}})
             };

        myChart2.setOption(option2);
    }

});
