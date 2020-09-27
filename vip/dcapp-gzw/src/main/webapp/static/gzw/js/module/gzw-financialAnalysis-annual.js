/**
 * Created by 11140721050132 on 2017/1/15.
 */
$(function () {
    $.post("/a/index/api",{
        // ds:'dcapp',
        _id:'gzw-financialAnalysis-annual'
    },function(res){
        if (res.length != 0) {
            $('#chart1').show();
            $('#nonechart').hide();
            var title = res[0].CREATE_Y+'年度财务数据分析';
            $('#corporate-title').append(title);
            var barnum = [];
            var label = [];
            for(var i=0;i<res.length;i++){
                var info;
                info = res[i].ERR_INFO.split(",");
                var num=0;
                for(var j=0;j<info.length/2;j++){
                    var z =(j+1)*2-1;
                    num += Number(info[z]);
                }
                label.push(res[i].LABEL);
                barnum.push(num);
            }
            chartbar(barnum,label);
        } else {
            $("#chart1").hide();
            $('#nonechart').show();
        }
    })

    $.post("/a/index/api", {
        // ds:'dcapp',
        _id: 'gzw-financialAnalysis-annual_2'
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
})

function chartbar(barnum,label) {
    var myChart1 = echarts.init(document.getElementById('chart1'));

    option1 = {
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
                itemStyle: {
                    normal:{
                        color:'#5B9BD5'
                    }
                },
                label: {show: false},
                data:barnum
            }
        ]
    };


    myChart1.setOption(option1);

}