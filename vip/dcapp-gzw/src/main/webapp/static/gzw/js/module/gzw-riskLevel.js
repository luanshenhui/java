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

                _id: 'gzw_risk_level_bar',
                cValue:n.CVALUE
            }, function(res1){

                var optionContent ;
                var divContent1 = '<a href="gzw-alarmRiskStatistics.html?='+ n.CVALUE + '" class="company-module" id="'+ n.CVALUE +'"></a>';
                var divContent2 = '<a href="javascript:void(0)" class="company-module bar-none" id="'+ n.CVALUE +'"></a>';

                if(dataExist(res1)){
                    //没有风险数
                    $('.data-not-exist').append(divContent2);
                    optionContent=getOptionWithoutData(n);
                }else{
                    //有风险数
                    $('.data-exist').append(divContent1);
                    optionContent=getOptionWithData(n,res1);
                }
                //需要插入echarts表的div
                var  targetElement = echarts.init(document.getElementById(n.CVALUE));


                targetElement.setOption(optionContent);
            });
        });
    }
    //此方法确定得到公司的风险数是否全为0
    function dataExist(res){
        return res[0].DATA_CNT==0&&res[1].DATA_CNT==0&&res[2].DATA_CNT==0;
    }
    //得到没有数据的公司的echarts的option
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
    //得到有数据的公司的echarts的option
    function getOptionWithData(data1,data2){

        var option1 = {
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
            series : []
        };
        $.each(data2,function(i,n){
            option1.series.push(getSeriesNode(i,n));
        });

        return option1;
    }
    function getSeriesNode(i,n){
        var colors=['#FF0000','#EA7500','#FFD306'];
        var seriesNode = {
            name: n.KEY,
            type:'bar',
            itemStyle : { normal: {
                barBorderWidth:'2',
                barBorderColor:'#090204',
                color:colors[i],label : {show: true, position: 'right'}}},
            data:[n.DATA_CNT],
            barWidth:'16'
        }
        return seriesNode;
    }
});

