/**
 * Created by Administrator on 2017/1/14.
 */
/**
 * Created by 11150321050124 on 2017/1/12.
 */

$(function () {
    var coType;
    var month;
    /*去后台获取数据*/
    var co_type = [];
    var firstType;
    $.post("/a/index/api",{
        _id:'gzw_corporateFinancialCompanyType'
    },function (type) {
        $.each(type,function(i,t){
            if(i==0){
                $('.corFinancial-title').append('<span class="on" id="'+t.LABEL+'">'+ t.LABEL+'</span>');
                firstType = t.LABEL;
            }else{
                $('.corFinancial-title').append('<span id="'+t.LABEL+'">'+ t.LABEL+'</span>');
            }
        });
        /*去后台获取数据*/
        $.post("/a/index/api",{
            _id:'gzw_corporateFinancialAnalysis-newsflashTop',
            co_name:firstType
        },function (res1) {
            if(res1.length!=0){
                $("#chart1-nodata").hide();
                $("#chart1").show();
                var num = [];
                var sum = [];
                $.each(res1,function(i,o){
                    if(o.ERR_INFO!=''|| o.ERR_INFO!=null){
                        num[i] = o.ERR_INFO.split(',');
                    }
                });
                $.each(num,function(i,o){
                    var sum1 = 0;
                    if(o[0].length>0){
                        for(var j=1;j<o.length;j=j+2){
                            sum1 +=  parseInt(o[j]);
                            sum[i] = sum1;
                        }
                    }else{
                        sum[i] = 0;
                    }
                });
                $.post("/a/index/api",{
                    _id:'gzw_month'
                },function (res) {
                    month = res[0].MON.split(',');
                    bar(month,sum,firstType);
                })
            }else{
                $("#chart1-nodata").show();
                $("#chart1").hide();
            }

        })
        /*去后台获取数据*/
        $.post("/a/index/api",{
            _id:'gzw_corporateFinancialAnalysis-newsflashBot',
            co_name:firstType
        },function (res2) {
            if(res2.length!=0) {
                $("#chart2-nodata").hide();
                $("#chart2").show();
                var day = [];
                $.each(res2, function (i, o) {
                    if (o.DD != "") {
                        day[i] = o.DD;
                    } else {
                        day[i] = 0;
                    }
                });
                $.post("/a/index/api", {
                    _id: 'gzw_month'
                }, function (res) {
                    month = res[0].MON.split(',');
                    line(month, day, firstType);
                })
            }else{
                $("#chart2-nodata").show();
                $("#chart2").hide();
            }
        })
        /*去后台获取数据*/
        $.post("/a/index/api",{
            _id:'gzw_corporateFinancialAnalysis-newsflashRight',
            co_name:firstType
        },function (res3) {
            $("#table-data").empty();
            if(res3.length!=0){
                $("#table-nodata").hide();
                $("#table-data").show();
                $.each(res3,function(i,n){
                    $("#table-data").append("<tr><td>"+n.DATE+"</td><td>"+n.DATE2+"</td></tr>");
                })
            }else{
                $("#table-nodata").show();
                $("#table-data").hide();
            }
        })
    })

    $(".corFinancial-title ").on('click','span',function(){
        $(this).addClass('on').siblings('span').removeClass('on');
        coType =$(".corFinancial-title .on").attr("id");
        /*去后台获取数据*/
        $.post("/a/index/api",{
            _id:'gzw_corporateFinancialAnalysis-newsflashTop',
            co_name:coType
        },function (res1) {
            if(res1.length!=0){
                $("#chart1-nodata").hide();
                $("#chart1").show();
                var num = [];
            var sum = [];
            $.each(res1,function(i,o){
                if(o.ERR_INFO!=''|| o.ERR_INFO!=null){
                    num[i] = o.ERR_INFO.split(',');
                }
            });
            $.each(num,function(i,o){
                var sum1 = 0;
                if(o[0].length>0){
                    for(var j=1;j<o.length;j=j+2){
                        sum1 +=  parseInt(o[j]);
                        sum[i] = sum1;
                    }
                }else{
                    sum[i] = 0;
                }
            });
            $.post("/a/index/api",{
                _id:'gzw_month'
            },function (res) {
                month = res[0].MON.split(',');
                bar(month,sum,coType);
            })
            }else{
                $("#chart1-nodata").show();
                $("#chart1").hide();
            }
        })
        /*去后台获取数据*/
        $.post("/a/index/api",{
            _id:'gzw_corporateFinancialAnalysis-newsflashBot',
            co_name:coType
        },function (res2) {
            if(res2.length!=0) {
                $("#chart2-nodata").hide();
                $("#chart2").show();
            var day = [];
            $.each(res2,function(i,o){
                if(o.DD!=""){
                    day[i] = o.DD;
                }else{
                    day[i] = 0;
                }
            });
            $.post("/a/index/api",{
                _id:'gzw_month'
            },function (res) {
                month = res[0].MON.split(',');
                line(month,day,coType);
            })
            }else{
                $("#chart2-nodata").show();
                $("#chart2").hide();
            }
        })
        /*去后台获取数据*/
        $.post("/a/index/api",{
            _id:'gzw_corporateFinancialAnalysis-newsflashRight',
            co_name:coType
        },function (res3) {
            $("#table-data").empty();
            if(res3.length!=0){
                $("#table-nodata").hide();
                $("#table-data").show();
            $.each(res3,function(i,n){
                $("#table-data").append("<tr><td>"+n.DATE+"</td><td>"+n.DATE2+"</td></tr>");
            })
            }else{
                $("#table-nodata").show();
                $("#table-data").hide();
            }
        })
    })
    // 企业财务月报快报分析柱状图
    function bar(month,sum,type){
        var cfa_newsflash1 = echarts.init(document.getElementById('chart1'));
        var option1 = {
            title:{
                text:type+'审核结果数据分析',
                textStyle:{fontSize:20,color:'#fff'}
            },
            tooltip : {
                show:false,
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
                    axisLabel:{textStyle:{fontSize:20,color:'#7a7a7a'}},
                    data : month
                }
            ],
            yAxis : [
                {
                    type : 'value',
                    axisLabel:{textStyle:{fontSize:20,color:'#7a7a7a'}}
                }
            ],
            series : [

                {
                    name:'总和',
                    type:'bar',
                    barWidth : 25,
                    stack: '总和',
                    itemStyle: {
                        normal:{
                            color:'#5B9BD5'
                        }
                    },
                    data:sum
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
                    }
                }
            ]
        };
        cfa_newsflash1.setOption(option1);
    }

    //企业财务月报快报分析折线图
    function line(month,day,coType){
        var cfa_newsflash2 = echarts.init(document.getElementById('chart2'));
        var option2 = {
            title: {
                text: '提交与审核走势分析',
                textStyle:{fontSize:20,color:'#fff'}
            },
            tooltip: {
                trigger: 'axis'
            },
            legend: {
                right:'5%',
                textStyle:{fontSize:20,color:'#fff'},
                data:['提交时间', '审核时间']
            },
            grid: {
                left: '3%',
                right: '5%',
                bottom: '5%',
                containLabel: true
            },
            toolbox: {
                feature: {
                    saveAsImage: {}
                }
            },
            xAxis: {
                type: 'category',
                axisLabel:{textStyle:{fontSize:20,color:'#7a7a7a'}},
                data: month
            },
            yAxis: {
                type: 'value',
                axisLabel:{textStyle:{fontSize:20,color:'#7a7a7a'}}
            },
            series: [
                {
                    name:'提交时间',
                    type:'line',
                    data:day,
                    lineStyle:{
                        normal:{color:'#ed7d31  '}
                    },
                    symbol:'circle',
                    symbolSize:'10'
                },

                {
                    name:'审核时间',
                    type:'line',
                    data:day,
                    lineStyle:{
                        normal:{color:'#5b9bd5  '}
                    },
                    symbol:'circle',
                    symbolSize:'10'
                }
            ]
        };
        cfa_newsflash2.setOption(option2);
    }
    });


