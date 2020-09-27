/**
 * Created by 11150321050124 on 2017/1/14.
 */

$(function () {
    //得到每个公司的value值和label值
    $.post("/a/index/api", {
        _id: 'gzw_company_value'
    }, getCompanyData);

    /*循环每个公司的数据*/
    function getCompanyData(res){
        $.each(res,function(i,n){
            $.post("/a/index/api", {

                _id: 'gzw_bussiness_data_pie',
                cValue:n.CVALUE
            }, function(res1){

                var optionContent ;
                var divContent1 = '<a href="gzw-alarmRiskStatistics.html?='+ n.CVALUE + '" class="company-module" id="'+ n.CVALUE +'"></a>';
                var divContent2 = '<a href="javascript:void(0)" class="company-module bar-none" id="'+ n.CVALUE +'"></a>';
                if(res1.length!=0){
                   $('.data-exist').append(divContent1);
                    optionContent=getOptionWithData(n,res1);

                }else{
                    $('.data-not-exist').append(divContent2);
                    optionContent=getOptionWithoutData(n);

                }
                //需要插入echarts表的div
                var  targetElement = echarts.init(document.getElementById(n.CVALUE));


                targetElement.setOption(optionContent);
            });
        });
    }

   //得到没有数据的公司 option
    function getOptionWithoutData(data1){
        var option0 = {
            title : {
                text: data1.CLABEL,
                textStyle:{color:'#FFFFFF'},
                x:'center'
            },
            xAxis : [
                {
                    type : 'value',
                    splitLine:{show: false},
                    show: false
                }
            ],
            yAxis : [
                {
                    type : 'category',
                    splitLine:{show: false},
                    data : [''],
                    show: false
                }
            ],
            series : [
                {
                    type:'bar',
                    data:[0],
                    barWidth:'16'
                }
            ]
        };
        return option0;
    }

    //得到有数据的公司 option
    function getOptionWithData(data1,data2){
        var legendData = [],numData = [];

        $.each(data2,function(i,n){
            legendData.push(n.POWERNAME);
            numData.push({value: n.POWERNUM, name: n.POWERNAME});
        });
        var option1 = {
            backgroundColor: '#f2f2f2',
            /*color: ['#ffdb6d', '#89c9e1', '#ce77b6', '#f29e29'],*/
            title: {
                text: data1.CLABEL,
                x: 'center',
                top: '0%',
                textStyle: {
                    color: '#fff',
                    fontSize:20
                }
            },
            tooltip: {
                trigger: 'item',
                formatter: "{a} <br/>{b}: {c} ({d}%)"
            },
            legend: {
                orient: 'vertical',
                x: '2%',
                top: '30%',
                data: legendData,
                width:10,textStyle:{color:'#fff',fontSize:'12'}

            },
            series: [{
                name:data1.CLABEL,
                type: 'pie',
                center:[240,110],
                radius: ['30%', '60%'],
                center: ['80%', '60%'],
                avoidLabelOverlap: false,
                itemStyle: {
                    normal: {
                        label: {
                            show: false
                        },
                        labelLine: {
                            show: false
                        },
                        shadowBlur: 40,
                        shadowColor: 'rgba(40, 40, 40,0.5)',
                    }
                },
                label: {
                    normal: {
                        show: false,
                        position: 'center'
                    },
                    emphasis: {
                        show: true,
                        formatter: function(param) {
                            return param.percent.toFixed(0) + '%';
                        },
                        textStyle: {
                            fontSize: '30',
                            fontWeight: 'bold'
                        }
                    }
                },
                labelLine: {
                    normal: {
                        show: true
                    }
                },
                data: numData
            }]
        };
        return option1;
    }
});

