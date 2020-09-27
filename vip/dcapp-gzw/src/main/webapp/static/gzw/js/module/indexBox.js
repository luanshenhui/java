/**
 * Created by 11150321050124 on 2017/1/12.
 */

$(function () {


    /*取仪表盘数据*/
    $.post("/a/index/api", {

        _id: 'gzw_index_box_gauge1'
    }, function (res1) {
        _drawGauge(res1[0]);
    });

    /*取风险等级/告警等级柱形图数据*/
    $.post("/a/index/api", {

        _id: 'gzw_index_box_bar2'
    }, function (res1) {

        //风险显示数字
        $('[data-id="riskGR"]').html(res1[0].redRiskDone);
        $('[data-id="riskGO"]').html(res1[0].orangeRiskDone);
        $('[data-id="riskGY"]').html(res1[0].yellowRiskDone);
        $('[data-id="riskRCount"]').html(res1[0].redRisk);
        $('[data-id="riskOCount"]').html(res1[0].orangeRisk);
        $('[data-id="riskYCount"]').html(res1[0].yellowRisk);
        //告警显示数字
        $('[data-id="alarmGR"]').html(res1[1].redRiskDone);
        $('[data-id="alarmGO"]').html(res1[1].orangeRiskDone);
        $('[data-id="alarmGY"]').html(res1[1].yellowRiskDone);
        $('[data-id="alarmRCount"]').html(res1[1].redRisk);
        $('[data-id="alarmOCount"]').html(res1[1].orangeRisk);
        $('[data-id="alarmYCount"]').html(res1[1].yellowRisk);
        //红色风险
        if(res1[0].redRisk!=0){
            var width1 = Math.ceil((res1[0].redRiskDone/res1[0].redRisk)*100);
            var width2 = 100-width1;
            $('[data-id="riskGR"]').css('width',width1+'%');
            $('[data-id="riskRR"]').css('width',width2+'%');
        }
        //橙色风险
        if(res1[0].orangeRisk!=0){
            var width1 = Math.ceil((res1[0].orangeRiskDone/res1[0].orangeRisk)*100);
            var width2 = 100-width1;
            $('[data-id="riskGO"]').css('width',width1+'%');
            $('[data-id="riskOO"]').css('width',width2+'%');
        }
        //黄色风险
        if(res1[0].yellowRisk!=0){
            var width1 = Math.ceil((res1[0].yellowRiskDone/res1[0].yellowRisk)*100);
            var width2 = 100-width1;
            $('[data-id="riskGY"]').css('width',width1+'%');
            $('[data-id="riskYY"]').css('width',width2+'%');
        }
        //红色告警
        if(res1[1].redRisk!=0){
            var width1 = Math.ceil((res1[1].redRiskDone/res1[1].redRisk)*100);
            var width2 = 100-width1;
            $('[data-id="alarmGR"]').css('width',width1+'%');
            $('[data-id="alarmRR"]').css('width',width2+'%');
        }
        //橙色告警
        if(res1[1].orangeRisk!=0){
            var width1 = Math.ceil((res1[1].orangeRiskDone/res1[1].orangeRisk)*100);
            var width2 = 100-width1;
            $('[data-id="alarmGO"]').css('width',width1+'%');
            $('[data-id="alarmOO"]').css('width',width2+'%');
        }
        //黄色告警
        if(res1[1].yellowRisk!=0){
            var width1 = Math.ceil((res1[1].yellowRiskDone/res1[1].yellowRisk)*100);
            var width2 = 100-width1;
            $('[data-id="alarmGY"]').css('width',width1+'%');
            $('[data-id="alarmYY"]').css('width',width2+'%');
        }

    });

    /*取柱形图数据*/
    $.post("/a/index/api", {
        _id: 'gzw_index_box_bar1'
    }, function (res1) {
        var riskVal = [], alarmVal = [];
        $.each(res1,function(i,n){
            alarmVal.push(n.ALARMCOUNT);
            riskVal.push(n.RISKCOUNT);
        });
        _drawBar(alarmVal, riskVal);
    });

    /*取雷达图数据*/
    $.post("/a/index/api", {
        _id: 'gzw_index_box_radar'
    }, function (res1) {

            //去仪表盘取效能
                $.post("/a/index/api", {

                    _id: 'gzw_index_box_gauge1'
                }, function (res2) {
                    var riskTypeCount = [];
                    $.each(res1,function(i,n){
                        if(n.NAME=='效能类风险'){
                            n.RISK_PERCENT=(100-res2[0].effectNum)/100;
                        }
                        riskTypeCount.push(n.RISK_PERCENT);
                    });
                    _drawRadar(riskTypeCount,res1);
                });
    });

    /*取气泡图数据*/
    $.post("/a/index/api", {
        _id: 'gzw_index_box_bubble'
    }, function (res1) {

      var _val = $.map(res1,function(o){
          return o.RISKCOUNT;
      });

        var num = Math.ceil(500/ Math.max.apply(null,_val));

        _drawBubble(res1, num);
    });


    //气泡图
    function _drawBubble(data1, num) {
        var myChart = echarts.init(document.getElementById('small-box-form6'));
        //echarts 的legend图例名称
        var dataLegend = [];
        /*气泡图 颜色数组*/
        var colors = [
            {c1: 'rgb(25, 183, 207)', c2: 'blue'},
            {c1: '#a7f9a3', c2: '#11c508'},
            {c1: '#f7c1cc', c2: '#ff0000'},
            {c1: '#a0ecf5', c2: '#0c97a8'},
            {c1: '#f7b5f7', c2: '#aa0ac2'},
            {c1: '#f5f48e', c2: '#f8fb01'}];
        var _pos = [{x: 150, y: 470},
            {x: 350, y: 450},
            {x: 250, y: 300},
            {x: 350, y: 200},
            {x: 60, y: 470},
            {x: 60, y: 300}];

        var _series = [];
        /*data1=[{"RISKCOUNT":1,"CNAME":"业绩考核"},
            {"RISKCOUNT":7,"CNAME":"产权管理"},
            {"RISKCOUNT":21,"CNAME":"投资运营"},
            {"RISKCOUNT":27,"CNAME":"改革重组"},
            {"RISKCOUNT":16,"CNAME":"经营性资产监管"},
            {"RISKCOUNT":80,"CNAME":"财务监督"}];*/
        $.each(data1, function (i, n) {

            n.RISKCOUNT && dataLegend.push(n.CNAME);

            if (n.RISKCOUNT) {
                var _args = {
                    name: n.CNAME || "",
                    data: [[_pos[i].x, _pos[i].y, n.RISKCOUNT, n.CNAME, n.CNAME]],
                    color: colors[i]
                }
                _series.push(getSeriesNode(_args));
            }

        });

        function getSeriesNode(args) {

            return {
                name: args.name,
                data: args.data,
                type: 'scatter',
                symbolSize: function (data) {

                    return  Math.sqrt(data[2]*40000000)/3e2;
                },
                label: {
                    normal: {
                        textStyle: {fontSize: '20'}, show: true,
                        formatter: function (param) {
                            return param.data[2];
                        }
                    },
                    emphasis: {
                        show: true,
                        formatter: function (param) {
                            return param.data[3];
                        },
                        position: 'top'

                    }
                },
                itemStyle: {
                    normal: {
                        shadowBlur: 10,
                        shadowColor: 'rgba(25, 100, 150, 0.5)',
                        shadowOffsetY: 5,
                        color: new echarts.graphic.RadialGradient(0.4, 0.3, 1, [{
                            offset: 0,
                            color: args.color.c1
                        }, {
                            offset: 1,
                            color: args.color.c2
                        }])
                    }
                }
            };

        }


        var option6 = {
            legend: {
                right: 10,
                data: dataLegend,
                padding: [400,  // 上
                    0, // 右
                    5,  // 下
                    0, // 左
                ], left: '40',
                textStyle: {
                    fontSize: '20',
                    color: '#fff'
                }, itemGap: 25
            },
            xAxis: {
                show: false
            },
            yAxis: {
                show: false
            },
            series: _series
        };
        myChart.setOption(option6);
    }

    //雷达图
    function _drawRadar(data,res1) {
        var targetElement = echarts.init(document.getElementById("center-form"));
        var option = {
            tooltip: {show:false},
            radar: {
                indicator: [{name: res1[0].NAME, max: 1.5},
                            {name: res1[1].NAME, max: 1.5},
                            {name: res1[2].NAME, max: 1.5},
                            {name: res1[3].NAME, max: 1.5},
                            {name: res1[4].NAME, max: 1.5},
                            {name: res1[5].NAME, max: 1.5},
                            {name: res1[6].NAME, max: 1.5}
                ],
                splitNumber: 4,
                splitArea: {
                    areaStyle: {
                        color: '#0D0D0D',
                        shadowColor: '#161617',
                        shadowBlur: 10
                    }
                },
                splitLine: {
                    show: true,
                    lineStyle: {
                        width: 3,
                        type: 'dotted',
                        color: ['red', 'green', 'yellow', 'orange']
                    }
                }
            },
            textStyle: {fontSize: '24', color: '#fff'},
            series: [{
                type: 'radar',

                tooltip: {
                    trigger: 'item'
                },
                itemStyle: {
                    normal: {
                        areaStyle: {type: 'default'},
                    }
                },
                data: [
                    {
                        value: data,
                        name: '风险数：',
                        areaStyle: {
                            normal: {
                                opacity: 0.5,
                                color: '#9f6bfe'
                            }
                        },
                        lineStyle: {normal: {color: '#038cec'}},
                        itemStyle: {
                            normal: {
                                color: '#ff0000',
                                borderWidth: 10,
                                borderType: 'dashed',
                                shadowColor: 'yellow',
                                shadowBlur: 5,
                                opacity: 1
                            }
                        }
                    }
                ]
            }]
        };
        targetElement.setOption(option);
    }

    //柱形图
    function _drawBar(data1, data2) {
        var targetElement4 = echarts.init(document.getElementById("small-box-form4"));
        var option1 = {
            tooltip: {
                trigger: 'axis'
            },
            calculable: true,
            grid:{
                right:'2%,' ,
                top:'15%'
            },
            xAxis: [
                {
                    type: 'category',
                    data: ['一季度', '二季度', '三季度', '四季度'],
                    nameTextStyle: {
                        fontSize: 12
                    }
                }
            ],
            yAxis: [
                {
                    type: 'value', name: '数量',
                    nameTextStyle: {
                        fontSize: 12
                    }
                }
            ], textStyle: {fontSize: "20", color: "#fff"},
            series: [
                {
                    name: '告警',
                    type: 'bar',
                    data: data1,
                    itemStyle: {
                        normal: {
                            color: '#007498'
                        }
                    }
                },
                {
                    name: '风险',
                    type: 'bar',
                    data: data2,
                    itemStyle: {
                        normal: {
                            color: '#ff0000'
                        }
                    }
                }
            ]
        };
        targetElement4.setOption(option1);
    }

    //仪表盘
    function _drawGauge(data) {

        //首页仪表盘js
        var businessGauge = echarts.init(document.getElementById('businessGauge'));
        var option8 = {
            backgroundColor: '#1b1b1b',
            tooltip: {
                formatter: "{a} <br/>{c} {b}"
            },
            series: [
                {
                    name: '效能',
                    type: 'gauge',
                    startAngle: 180,
                    endAngle: 0,
                    center: ['50%', '70%'],
                    min: 0,
                    max: 100,
                    splitNumber: 10,
                    radius: 170,
                    axisLine: {            // 坐标轴线
                        lineStyle: {       // 属性lineStyle控制线条样式
                            color: [[0.09, '#1e90ff'], [0.82, '#1e90ff'], [1, '#1e90ff']],
                            width: 3,
                            shadowColor: '#fff', //默认透明
                            shadowBlur: 10
                        }
                    },
                    axisTick: {            // 坐标轴小标记
                        length: 15,        // 属性length控制线长
                        lineStyle: {       // 属性lineStyle控制线条样式
                            color: 'auto',
                            shadowColor: '#fff', //默认透明
                            shadowBlur: 10
                        }
                    },
                    splitLine: {           // 分隔线
                        length: 25,         // 属性length控制线长
                        lineStyle: {       // 属性lineStyle（详见lineStyle）控制线条样式
                            width: 3,
                            color: '#fff',
                            shadowColor: '#fff', //默认透明
                            shadowBlur: 10
                        }
                    },
                    pointer: {           // 指针
                        shadowColor: '#fff', //默认透明
                        shadowBlur: 5
                    },
                    title: {
                        offsetCenter: [0, '30%'],
                        textStyle: {       // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                            fontWeight: 'bolder',
                            fontSize: 32,
                            color: '#fff'
                        }
                    },
                    detail: {
                        shadowColor: '#fff', //默认透明
                        shadowBlur: 5,
                        offsetCenter: [0, '-35%'],       // x, y，单位px
                        textStyle: {       // 其余属性默认使用全局文本样式，详见TEXTSTYLE
                            fontWeight: 'bolder',
                            color: '#ff8400',
                            fontSize: 50
                        }
                    },
                    data: [{value: data.effectNum, name: data.dataCount}]
                }
            ]
        };
        businessGauge.setOption(option8);
    }

   // _drawLineDataEngine();
    function _drawLineDataEngine() {

        // 基于准备好的dom，初始化echarts实例
        var dataEngineLine = echarts.init(document.getElementById('targetElement3'));

        var option = {
            grid: {
                top: '6%',
                left: '3%',
                right: '4%',
                bottom: '6%',
                containLabel: true
            },
            xAxis: [
                {
                    type: 'category',
                    boundaryGap: false,
                    axisLine: {
                        lineStyle: {
                            color: '#747474'
                        }
                    },
                    splitLine: {
                        show: true,
                        lineStyle: {
                            color: '#232325'
                        }
                    },
                    data: ['1', '2', '3', '4', '5', '6', '7', '8', '9']
                }
            ],
            yAxis: [
                {
                    type: 'value',
                    axisLine: {
                        lineStyle: {
                            color: '#747474'
                        }
                    },
                    splitLine: {
                        lineStyle: {
                            color: '#232325'
                        }
                    }
                }
            ],
            series: [
                {
                    type: 'line',
                    label: {
                        normal: {
                            show: true,
                            position: 'top'
                        }
                    },
                    lineStyle: {
                        normal: {
                            color: '#449ce6',
                            width: 1
                        }
                    },
                    areaStyle: {
                        normal: {
                            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{
                                offset: 0, color: 'rgba(73, 172, 255, 0.1)' // 0% 处的颜色
                            }, {
                                offset: 1, color: 'rgba(73, 172, 255, 1)' // 100% 处的颜色
                            }], false)
                        }
                    },
                    smooth: true,
                    smoothMonotone: 'x',
                    symbol: 'none',
                    sampling: 'average',
                    data: [70, 90, 81, 73, 79, 92, 65, 90, 81]
                }
            ]
        };

        // 使用刚指定的配置项和数据显示图表。
        dataEngineLine.setOption(option);
    }

});