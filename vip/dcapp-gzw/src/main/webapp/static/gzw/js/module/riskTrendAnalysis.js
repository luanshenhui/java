/**
 * Created by Administrator on 2017/1/14.
 */
/**
 * Created by 11150321050124 on 2017/1/12.
 */

$(function () {
    var co_id = location.search.split('=')[1];
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
        _id:'gzw_riskTrendAnalysis',
        coid:co_id
    },function (res1) {
        if(res1.length!=0){
            $("#main-nodata").hide();
            $("#main").show();
            var lengend = new Array();
            var series = new  Array();
            var month;
            var colors = ['#ec023c','#01a0f2','#02fc08','#ff9000'];
            $.each(res1,function(i,o){
                lengend[i] = {
                    name:o.POWER_NAME,
                    icon:'circle'
                };
                series[i] = {
                    name: o.POWER_NAME,
                    type: 'line',
                    lineStyle:{
                        normal:{
                            color:colors[i]
                        }
                    },
                    data: o.DATA_CNT.split(',')
                }
            });
            $.post("/a/index/api",{
                _id:'gzw_month',
                coid:co_id
            },function (res) {
                month = res[0].MON.split(',');
                line(lengend,series,month);
            })
        }else{
            $("#main-nodata").show();
            $("#main").hide();
        }
    })
    // 风险界定分析柱状图
    function line(lengend,series,month){
        var riskTrend = echarts.init(document.getElementById('main'));
        var option = {
            color:['#ec023c','#01a0f2','#02fc08','#ff9000'],
            xAxis: {
                type : 'category',
                axisLabel:{
                    interval:0,
                    textStyle:{
                        color:'#7a7a7a',
                        fontSize:20
                    }
                },
                data: month,

            },
            legend: {
                align: 'left',
                data: lengend,
                textStyle: {
                    align: 'right',
                    baseline: 'middle',
                    fontFamily: '微软雅黑',
                    color:'#FFFFFF',
                    fontSize:'25'
                },
                itemGap:30
            },

            yAxis: {
                axisLabel:{
                    textStyle:{
                        color:'#7a7a7a',
                        fontSize:20
                    }
                }
            },
            series: series
        };

        riskTrend.setOption(option);
    }
    });


