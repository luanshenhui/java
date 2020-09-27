/**
 * Created by 11150321050124 on 2017/1/15.
 */
$(function(){
    //得到每个公司的value值和label值
    $.post("/a/index/api", {
        _id: 'gzw_company_value'
    }, getCompanyData);

    /*循环每个公司的数据*/
    function getCompanyData(res){
        $.each(res,function(i,n){
            $.post("/a/index/api", {
                _id: 'gzw_corporateFinancialAnalysis-annual',
                CNAME:n.CLABEL
            }, function(res1){

                var optionContent ;

                var divContent1 = '<div  class="company-module" id="'+ n.CVALUE +'"></div>';
                var divContent2 = '<div  class="company-module bar-none" id="'+ n.CVALUE +'"></div>';

                if(dataExist(res1)){
                    //没有风险数
                    $('.data-not-exist').append(divContent2);
                     optionContent=getOptionWithoutData(n);
                }else{
                    //有风险数
                    $('.data-exist').append(divContent1);
                    var yearArr=[],dataArr=[];
                    $.each(res1,function(num,target){
                        yearArr.push(target.YEAR+"年度");
                        var errorSum=0;
                        if(target.ERRORS==0){
                          //  console.log(num,'====',target.ERROR);
                        }else{
                            var errorArray = target.ERRORS.split(',');

                            for(var j=1;j<errorArray.length;j+=2){
                                errorSum += Number(errorArray[j]);
                            }
                        }
                        dataArr.push(errorSum);
                        optionContent=getOptionWithData(n,yearArr,dataArr);
                    });
                }
                //需要插入echarts表的div
                var  targetElement = echarts.init(document.getElementById(n.CVALUE));
                 targetElement.setOption(optionContent);
            });
        });
    }

    //此方法确定得到公司的风险数是否全为0
    function dataExist(res){

        return res[0].ERRORS==0&&res[1].ERRORS==0&&res[2].ERRORS==0&&res[3].ERRORS==0&&res[4].ERRORS==0;
    }

    //得到没有数据的公司的echarts的option
    function getOptionWithoutData(data1){
        var option0 = {
            title : {
                text:  data1.CLABEL,
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

    ////得到有数据的公司的echarts的option
    function getOptionWithData(data1,data2,data3){

        var option1 = {
            title:{
                    text:data1.CLABEL,
                    textStyle:{color:'#FFFFFF',fontSize:'18'},
                    x:'center'
                    },
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
                    axisLabel:{textStyle:{fontSize:20,color:'#7a7a7a'},
                        interval: 0,
                    },
                    data : data2
                }
            ],
            yAxis : [
                {
                    type : 'value',
                    axisLabel:{textStyle:{fontSize:20,color:'#7a7a7a'}}
                },
                {
                    type : 'value',
                    show:false,
                }
            ],
            series : [
                {
                    name:'年报错误数据',
                    type:'bar',
                    barWidth : 30,
                    stack: '检查',
                    itemStyle: {
                        normal:{
                            color:'#ED7D31'
                        }
                    },
                    label: {
                        normal: {
                            show: true,
                            textStyle: {
                                color: '#fff',
                                fontSize:20
                            }
                        }
                    },
                    data:data3
                }
            ]
        };
        return option1;
    }

});