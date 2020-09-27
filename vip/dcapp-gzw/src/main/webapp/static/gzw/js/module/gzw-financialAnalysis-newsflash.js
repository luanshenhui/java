/**
 * Created by 11140721050132 on 2017/1/15.
 */
$(function () {
    post('1');
    labelbody('1');
    var myDate = new Date();
    var endmonth = myDate.getMonth();
    $('.financial-month .btn-group').on('click','li',function(){

        if($(this).index()<=endmonth){
            $(this).addClass('on').siblings('li').removeClass('on');
            post($(this).index()+1);
            labelbody($(this).index()+1);
        }
    });
    for(var k=0;k<endmonth+1;k++){
        $('.financial-month .btn-group li').eq(k).addClass('able');
    }
})
function post(param) {
    if(param<10){
        param = '0'+param;
    }
    $.post("/a/index/api", {
        // ds:'dcapp',
        _id: 'gzw-financialAnalysis-newsflash',
        create_ym: param
    }, function (res) {
        if (res.length != 0) {
            $('#chart1').show();
            $('#nonechart').hide();
            var barnum = [];
            var label = [];
            for (var i = 0; i < res.length; i++) {
                var info;
                info = res[i].ERR_INFO.split(",");
                var num = 0;
                for (var j = 0; j < info.length / 2; j++) {
                    var z = (j + 1) * 2 - 1;
                    num += Number(info[z]);
                }
                label.push(res[i].LABEL);
                barnum.push(num);
            }
            chartbar(barnum, label);
        } else {
            $("#chart1").hide();
            $('#nonechart').show();
        }
    })
}
function chartbar(barnum,label) {
    var myChart1 = echarts.init(document.getElementById('chart1'));
    option1 = {
        title :{
            text:'企业快报审核结果分析',
            textStyle:{fontSize:'24',color:'#fff'}
        },
        tooltip : {show:false},
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
                    formatter:function(val){
                        return val.split("").join("\n"); //横轴信息文字竖直显示
                    },},
                data : label
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
                axisLabel:{textStyle:{fontSize:20,color:'#7a7a7a'}}
            }
        ],
        series : [
            {
                name:'财务数据',
                type:'bar',
                barWidth : 30,
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
                data:barnum
            },
            {
                name:'财务数据',
                type:'line',
                yAxisIndex: 1,
                itemStyle: {
                    normal:{
                        color:'#5B9BD5'
                    }
                },
                data:barnum
            }
        ]
    };
    myChart1.setOption(option1);
}
function labelbody(param){
    $("#labelbody").children().remove();
    if(param<10){
        param = '0'+param;
    }
    $.post("/a/index/api", {
        // ds:'dcapp',
        _id: 'gzw-financialAnalysis-newsflash_2',
        uptime: param
    }, function (res) {
        if (res.length != 0) {
            $("#labelbody").show();
            $('#nonebody').hide();
            for (var i = 0; i < res.length; i++) {
                var html;
                html ='<tr><td>'+ res[i].LABEL +'</td><td>'+ res[i].DATE +'</td><td>'+ res[i].DATE +'</td></tr>';
                $("#labelbody").append(html);
            }
        } else {
            $("#labelbody").hide();
            $('#nonebody').show();
        }
    })
}