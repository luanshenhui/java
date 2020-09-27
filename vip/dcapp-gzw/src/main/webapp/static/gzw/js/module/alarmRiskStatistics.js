/**
 * Created by Administrator on 2017/1/14.
 */
/**
 * Created by 11150321050124 on 2017/1/12.
 */

$(function () {
    var co_id=location.search.split('=')[1];
    $('.box-left ul li a').eq(0).attr('href',$('.box-left ul li a').eq(0).attr('href')+'?='+co_id);
    $('.box-left ul li a').eq(1).attr('href',$('.box-left ul li a').eq(1).attr('href')+'?='+co_id);
    $('.box-left ul li a').eq(2).attr('href',$('.box-left ul li a').eq(2).attr('href')+'?='+co_id);
    $.post("/a/index/api",{
        _id:'gzw_companyId',
        coid:co_id
    },function (title) {
        $('.box-title').text(title[0].CO_NAME);
    })
    /*去后台获取数据*/
    $.post("/a/index/api",{
        _id:'gzw_alarmRiskStatisticsPieTop',
        coid:co_id

    },function (res1) {
        if(res1.length!=0){
            $("#main-nodata").hide();
            $("#main").show();
            var name=[];
            var num=[];
            $.each(res1,function(i,val1){
                name.push(val1.POWER_NAME);
                num.push(val1.CNT);
            });
            var arrays = new Array();
            for(var i = 0; i < res1.length; i++){
                arrays[i] = {
                    value:num[i],
                    name:name[i]
                }
            }
            pie1(name,arrays);
        }else{
            $("#main-nodata").show();
            $("#main").hide();
        }
    })

    /*去后台获取数据*/
    $.post("/a/index/api",{
        _id:'gzw_alarmRiskStatisticsPieBottom',
        coid:co_id

    },function (res2) {
        if(res2.length!=0){
            $("#main1-nodata").hide();
            $("#main1").show();
            var name=[];
            var num=[];
            $.each(res2,function(i,val2){
                name.push(val2.POWER_NAME);
                num.push(val2.CNT);
            });
            var arrays2 = new Array();
            for(var i = 0; i < res2.length; i++){
                arrays2[i] = {
                    value:num[i],
                    name:name[i]
                }
            }
            pie2(name,arrays2);
        }else{
            $("#main1-nodata").show();
            $("#main1").hide();
        }
    })

    /*去后台获取数据*/
    $.post("/a/index/api",{
        _id:'gzw_alarmRiskStatisticsBarRight',
        coid:co_id

    },function (res3) {
        if(res3.length!=0){
            $("#main2-nodata").hide();
            $("#main2").show();
            var name=[];
            var num=[];
            $.each(res3,function(i,val3){
                name.push(val3.POWER_NAME);
                num.push(val3.CNT);
            });
            var arrays3 = new Array();
            for(var i = 0; i < res3.length; i++){
                arrays3[i] = {
                    value: name[i],
                    textStyle: {
                        fontSize: 20,
                        color: '#fff'
                    }
                }
            }
            bar3(num,arrays3);
        }else{
            $("#main2-nodata").show();
            $("#main2").hide();
        }
    })

   //风险分析饼图
    function pie1(name,arrays){
        var alarmRisk1 = echarts.init(document.getElementById('main'));
        var option1 = {
            title:{text:'风险分析',textStyle:{fontSize:'24',color:'#fff'}},
            tooltip: {
                trigger: 'item',
                formatter: "{a} <br/>{b}: {c} ({d}%)"
            },
            legend: {
                left:20,
                orient: 'vertical',
                x: 'right',
                itemHeight: '10',
                padding: [90,0,20,20],
                data:name,textStyle:{fontSize:'20',color:'#fff'}
            },
            series: [
                {
                    center:['63%','50%'],
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
                    data:arrays
                }
            ]
        };
        alarmRisk1.setOption(option1);
    }

    //告警分析饼图
    function pie2(name,arrays2){
        var alarmRisk2 = echarts.init(document.getElementById('main1'));
        var option2 = {
            title:{text:'告警分析',textStyle:{fontSize:'24',color:'#fff'}},
            tooltip: {
                trigger: 'item',
                formatter: "{a} <br/>{b}: {c} ({d}%)"
            },
            legend: {
                left:20,
                orient: 'vertical',
                x: 'right',
                itemHeight: '10',
                padding: [60,0,20,20],
                data:name,textStyle:{fontSize:'20',color:'#fff'}
            },
            series: [
                {
                    center:['63%','50%'],
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
                    data:arrays2
                }
            ]
        };
        alarmRisk2.setOption(option2);
    }

    function bar3(num,arrays3){
        //业务事项柱状图
        var alarmRisk3 = echarts.init(document.getElementById('main2'));
        var option3 = {
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
                bottom: '10%',
                containLabel: true
            },
            xAxis : [
                {
                    type : 'category',
                    data: arrays3,
                    axisTick: {
                        alignWithLabel: true
                    },
                    axisLabel:{
                        formatter:function(val){
                            return val.split("").join("\n"); //横轴信息文字竖直显示
                        }
                    }
                }
            ],
            yAxis : [
                {
                    type : 'value',
                    axisLabel:{
                        show:false,
                        textStyle:{
                            color:'#7a7a7a',
                            fontSize:20
                        }
                    }
                }
            ],
            series : [
                {
                    name:'业务事项统计',
                    type:'bar',
                    barWidth: '35',
                    data:num,
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
        alarmRisk3.setOption(option3);
    }
    });


