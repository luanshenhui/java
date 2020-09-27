/**
 * Created by 11150321050124 on 2017/1/12.
 */

$(function () {


	var refreshTime = 600000;
	// 定时刷新首页
	setInterval(function(){
		window.location.reload(); 
	}, refreshTime);
/*    $('.left-box').on('click','.l-content',function(){
        var cont = $(this).attr('id');
        window.location.href="index1table.html?cont="+cont;
    })*/

    //柱状图第一个
    $.post("/a/index/api",{
        // ds:'dcapp',
        _id:'gybank_leftbar1_1',
    },function(res){
        var barnum = [];
        for(var i=0;i<res.length;i++){
            barnum.push(res[i].NUM);
        }
        leftbar1(barnum);
    })

    //柱状图第二个
    $.post("/a/index/api",{
        // ds:'dcapp',
        _id:'gybank_leftbar2_1',
    },function(res){
            var barnum = [];
            for(var i=0;i<res.length;i++){
                barnum.push(res[i].NUM);
            }
            leftbar2(barnum);
    })
    $.post("/a/index/api",{
        // ds:'dcapp',
        _id:'gybank_rightbox_1',
    },function(res){
    //右侧告警滚动
    var alarmAndRiskList = res;
     if(alarmAndRiskList){
     var html = '';
     for(var i = 0; i < alarmAndRiskList.length; i++){
     // 级别
     var alarmLevel = alarmAndRiskList[i].A;
     // 业务操作人
     //var operPersonName = alarmAndRiskList[i].operPersonName;
     // 用于区分告警和风险（告警-1、风险-2）
     //var type = alarmAndRiskList[i].type;
     // 更新时间
     //var updateDate = alarmAndRiskList[i].updateDate;

     var iconClass = "";
         iconClass = "icon-green";
/*     if(alarmLevel == 0){
     iconClass = "icon-green";
     }else if(alarmLevel == 1){
     iconClass = "icon-yellow";
     }else if(alarmLevel == 2){
     iconClass = "icon-orange";
     }else if(alarmLevel == 3){
     iconClass = "icon-red";
     }*/
     
     /*var typeName = "";
     var fontColorClass = "";
     if(type == 1){
     typeName = "告警";
     fontColorClass = "yellow-font";
     }else if (type == 2){
     typeName = "风险";
     fontColorClass = "red-font";
     }*/
     //<i class="icon-green"></i>
     html = '<li style="height: 100px"><i class="'+iconClass+'"></i>'+ alarmAndRiskList[i].B +'</li>';
     $('#sp').append(html);
     }

     }else{
     $('#systemScroll').hide();
     $('#systemScrollHidden').show();
     }
    })
    var myar = setInterval('autoScroll("#systemScroll")', 3000);
    //当鼠标放上去的时候，滚动停止，鼠标离开的时候滚动开始
    $("#systemScroll").hover(
        function () {
            clearInterval(myar);
        },
        function () {
            myar = setInterval('autoScroll("#systemScroll")', 3000);
        }
    );

    //中间饼图1
    $.post("/a/index/api",{
        // ds:'dcapp',
        _id:'gybank_leftbar2_1',
    },function(res){
        var pienum = [];
        for(var i=0;i<res.length;i++){
            var ylpm;
            ylpm ={value:res[i].NUM,name:res[i].NAME};
            pienum.push(ylpm);
        }
        centerpie1(pienum);
    })

    //中间柱状图2
    $.post("/a/index/api",{
        // ds:'dcapp',
        _id:'gybank_center2_1',
    },function(res){
        var ylpmdata1 = [];
        var ylpmdata2 = [];
        var ylpm = [];
        var datestr;
        var month = 0;
        var year;
        var myDate = new Date();
        for (var j = 0; j < 5; j++) {
            month=myDate.getMonth()+1-5+j;
            year = myDate.getFullYear();
            if(month<=0){
                month = 12+month;
                year = myDate.getFullYear()-1;
            }
            datestr = year + '-' +month;
            ylpm.push(datestr);
        }
        for(var i=0;i<res.length;i++){
            var num;
            num = {name: res[i].NAME,
                type: 'bar',
                stack: '预警',
                barWidth: 30,//柱图宽度
                data:res[i].NUM.split(",")};
            ylpmdata1.push(num);
        }
        for(var i=0;i<res.length;i++){
            var num;
            num = {name: res[i].NAME,
                type: 'line',
                stack: '预警',
                barWidth: 30,//柱图宽度
                data:res[i].NUM.split(",")};
            ylpmdata2.push(num);
        }
        centerbar2(ylpmdata1,ylpm);
        centerline4(ylpmdata2,ylpm);
    })

    //中间折线图5
    $.post("/a/index/api",{
        // ds:'dcapp',
        _id:'gybank_center4_1',
    },function(res){
        var suma = [];
        var date = [];
        for(var i=0;i<res.length;i++){
            suma.push(res[i].NUM);
            date.push(res[i].DATEMONTH);
        }
        centerline5(suma,date);
    })
})

    //柱状图1
    function leftbar1(barnum) {
        var targetElement_1 = echarts.init(document.getElementById("option-left1"));
        var option_1 = {
            grid: {
                left: '3%',
                bottom: '-8%',
                top:'5%',
                containLabel: true
            },
            xAxis: [
                {
                    type: 'value',
                    splitLine: {show: false},
                    show: false
                }
            ],
            yAxis: [
                {
                    type: 'category',
                    splitLine: {show: false},
                    data: ['个人对外 投资监测','个人账户境外 大额消费预警','个人账户大额 资金异动预警','公司账户转 个人账户预警','投诉举报'],
                    axisLabel: {
                        show: true,
                        textStyle: {
                            color: '#fff',
                        },
                        interval: 0,
                        formatter:function(val){
                            return val.split(" ").join("\n"); //横轴信息文字竖直显示
                        },
                    }
                }
            ],
            series: [
                {
                    type: 'bar',
                    barWidth:'60%',
                    data: barnum,
                    itemStyle: {
                        normal: {
                            color: function (params) {
                                var colorList = ['#FF0000','#EA7500','#FFBB77','#FFD306','#FFFF93'];
                                return colorList[params.dataIndex]
                            },
                            label: {show: true, position: 'right'}
                        }
                    }
                }
            ]
        };
        targetElement_1.setOption(option_1);
    }

    //柱状图2
    function leftbar2(barnum) {
        var targetElement_2 = echarts.init(document.getElementById("option-left2"));
        var option_2 = {
            grid: {
                left: '3%',
                bottom: '-8%',
                top:'5%',
                containLabel: true
            },
            xAxis: [
                {
                    type: 'value',
                    splitLine: {show: false},
                    show: false
                }
            ],
            yAxis: [
                {
                    type: 'category',
                    splitLine: {show: false},
                    data: ['个人对外 投资监测','个人账户境外 大额消费预警','个人账户大额 资金异动预警','公司账户转 个人账户预警','投诉举报'],
                    axisLabel: {
                        show: true,
                        textStyle: {
                            color: '#fff',
                        },
                        interval: 0,
                        formatter:function(val){
                            return val.split(" ").join("\n"); //横轴信息文字竖直显示
                        },
                    }
                }
            ],
            series: [
                {
                    type: 'bar',
                    barWidth:'60%',
                    data: barnum,
                    itemStyle: {
                        normal: {
                            color: function (params) {
                                var colorList = ['#FF0000','#EA7500','#FFBB77','#FFD306','#FFFF93'];
                                return colorList[params.dataIndex]
                            },
                            label: {show: true, position: 'right'}
                        }
                    }
                }
            ]
        };
        targetElement_2.setOption(option_2);
    }
    //饼图1
    function centerpie1(pienum) {
        var targetElement_5 = echarts.init(document.getElementById("option-center1"));
        
        var option_5 = {
            title: {
                text: '年度预警统计',
                textStyle: {
                    color: '#fff'
                },
            },
            textStyle: {
                color: '#fff'
            },
            tooltip: {
                trigger: 'item',
                formatter: "{b} : {c}({d}%)"
/*                formatter: function (params,ticket,callback) {
						      if( params.name=='碎石'|| params.name=='机制砂') {return params.name+":"+params.value+"方";}
						      else {return params.name+":"+params.value+"吨";}
						    } */
            },
            series: [
                {
                    name: '原材料',
                    type: 'pie',
                    radius: '55%',
                    center: ['50%', '60%'],
                    data: pienum,
                    itemStyle: {
                        emphasis: {
                            shadowBlur: 10,
                            shadowOffsetX: 0,
                            shadowColor: 'rgba(0, 0, 0, 0.5)'
                        }
                    }
                }
            ]
        };
        targetElement_5.setOption(option_5);
    }
    //柱状图2
    function centerbar2(ylpmdata,ylpm) {
        var targetElement_6 = echarts.init(document.getElementById("option-center2"));
        var option_6 = {
            title: {
                text: '资金预警',
                textStyle: {
                    color: '#fff'
                },
            },
            textStyle: {
                color: '#fff'
            },
            tooltip: {
                trigger: 'axis',
                axisPointer: {            // 坐标轴指示器，坐标轴触发有效
                    type: 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                }
            },
            grid: {
                left: '3%',
                right: '4%',
                bottom: '3%',
                containLabel: true
            },
            xAxis: [
                {
                    type: 'category',
                    data: ylpm
                }
            ],
            yAxis: [
                {
                    type: 'value'
                }
            ],
            series: ylpmdata
        };
        targetElement_6.setOption(option_6);
    }
    //库存比例折线图4
    function centerline4(ylpmdata,ylpm) {
        var targetElement_8 = echarts.init(document.getElementById("option-center4"));
        var option_8 = {
            title: {
                text: '资金预警',
                textStyle: {
                    color: '#fff'
                },
            },
            textStyle: {
                color: '#fff'
            },
            tooltip: {
                trigger: 'axis'
            },
            calculable: true,
            xAxis: [
                {
                    type: 'category',
                    boundaryGap: false,
                    data:ylpm
                }
            ],
            yAxis: [
                {
                    type: 'value'
                }
            ],
            series:ylpmdata
        };

        targetElement_8.setOption(option_8);
    }
    //折线图5
    function centerline5(suma,date) {
        var targetElement_9 = echarts.init(document.getElementById("option-center5")); 
        var option_9 = {
            title: {
                text: '异动预警',
                subtextStyle: {
                    color: '#fff'
                },
                 textStyle: {
                    color: '#fff'
                }
            },
            textStyle: {
                color: '#fff'
            },
            tooltip: {
                trigger: 'axis',
                formatter: "{b} : {c}"
            },
            toolbox: {
                show: true
            },
            xAxis: [
                {
                    type: 'category',
                    boundaryGap: false,
                    data:date
                }
            ],
            yAxis: [
                {
                    type: 'value'
                }
            ],
            series: [
                {
                    name: '异动预警',
                    type: 'line',
                    data: suma
                }
            ]
        };

        targetElement_9.setOption(option_9);
    }

    function autoScroll(obj){
        $(obj).find("#sp:first").animate({marginTop: "-80px"}, 3000, function() {
            $(this).css({marginTop:"0px"}).find("li:first").appendTo(this);
        });
    }

