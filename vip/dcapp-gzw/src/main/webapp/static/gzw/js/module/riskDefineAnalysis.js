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
        _id:'gzw_riskDefineAnalysis',
        coid:co_id

    },function (res1) {
        var zero = 0;
        $.each(res1,function(i,o){
            if(o.DATA_CNT!=0){
                zero++;
            }else{
                zero;
            }
        });
        if(zero!=0){
            $("#main-nodata").hide();
            $("#main").show();
            var type=[];
            var num1=[];
            var num2=[];
            var num3=[];
            var sum=[];
            $.each(res1,function(i,val1){
                if(val1.KEY==01){
                    type.push("界定为风险");
                    num1.push(val1.DATA_CNT);
                }else if(val1.KEY==02){
                    type.push("界定为非风险");
                    num2.push(val1.DATA_CNT);
                }else if(val1.KEY==03){
                    type.push("未界定");
                    num3.push(val1.DATA_CNT);
                }
            });
            for(var i=0;i<12;i++){
                sum.push(num1[i]+num2[i]+num3[i]);
            }
            $.post("/a/index/api",{
                _id:'gzw_month',
                coid:co_id
            },function (res) {
                month = res[0].MON.split(',');
                bar(type,num1,num2,num3,sum,month);
            })
        }else{
            $("#main-nodata").show();
            $("#main").hide();
        }

    })
    // 风险界定分析柱状图
    function bar(type,num1,num2,num3,sum,month){
        var riskDefine = echarts.init(document.getElementById('main'));
        // 指定图表的配置项和数据
        var option = {
            title:{
                //text:'风险界定分析表（2016年）',
                textStyle:{color:'#fff',fontSize:'24'},
                left:'45%'
            },
            toolbox: {
                feature: {
                    dataView: {show: false, readOnly: false},
                    magicType: {show: false, type: ['line', 'bar']},
                    restore: {show: false},
                    saveAsImage: {show: false}
                }
            },
            legend: {
                data:type,
                right:'5%',
                textStyle:{
                    color:'#ffffff',
                    fontSize:18
                },
                itemGap:30
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
                    axisLabel:{
                        show: true,
                        textStyle:{
                            fontSize:20,
                            color:'#7a7a7a'
                        }
                    },
                    data : month
                }
            ],
            yAxis : [
                {
                    type : 'value',
                    axisTick:{
                        show: false
                    },
                    axisLabel:{
                        show: true,
                        textStyle:{
                            fontSize:20,
                            color:'#7a7a7a'
                        }
                    }

                }
            ],
            series : [
                {
                    name:'未界定',
                    type:'bar',
                    stack: '统计',
                    itemStyle: {
                        normal:{
                            color:'#1a64d3'
                        }
                    },
                    label: {
                        normal: {
                            show: true,
                            position: 'insideRight'
                        }
                    },
                    data:num3
                },
                {
                    name:'界定为非风险',
                    type:'bar',
                    stack: '统计',
                    itemStyle: {
                        normal:{
                            color:'#30ada0'
                        }
                    },
                    label: {
                        normal: {
                            show: true,
                            position: 'insideRight'
                        }
                    },
                    data:num2
                },
                {
                    name:'界定为风险',
                    type:'bar',
                    barWidth : 20,
                    itemStyle: {
                        normal:{
                            color:'#D20000'
                        }
                    },
                    stack: '统计',
                    label: {
                        normal: {
                            show: true,
                            position: 'insideRight'
                        }
                    },
                    data:num1
                },
                {
                    name:'总共',
                    type:'line',
                    lineStyle:{
                        normal:{
                            color:'#ffc700'
                        }
                    },
                    data:sum,
                    itemStyle: {
                        normal: {
                            barBorderWidth: 6,
                            barBorderRadius:0,
                            label : {
                                show: true,
                                position: 'top',
                                textStyle: {
                                    color: '#ffc700',
                                    fontSize:20
                                }
                            }
                        }
                    },

                }
            ]
        };
        // 使用刚指定的配置项和数据显示图表。
        riskDefine.setOption(option);
    }
    });


