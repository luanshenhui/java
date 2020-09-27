/**
 * Created by 11150321050124 on 2017/1/12.
 */

$(function () {


	var refreshTime = 600000;
	// 定时刷新首页
	setInterval(function(){
		window.location.reload(); 
	}, refreshTime);
    $('.left-box').on('click','.l-content',function(){
        var cont = $(this).attr('id');
        window.location.href="index1table.html?cont="+cont;
    })

    //柱状图第一个
    $.post("/a/index/api",{
        // ds:'dcapp',
        _id:'index1_leftbar1_1',
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
        _id:'index1_leftbar2_1',
    },function(res){
            var barnum = [];
            for(var i=0;i<res.length;i++){
                barnum.push(res[i].NUM);
            }
            leftbar2(barnum);
    })
    //柱状图第三个
    $.post("/a/index/api",{
        // ds:'dcapp',
        _id:'index1_leftbar3_1',
    },function(res){
        var barnum = [];
        for(var i=0;i<res.length;i++){
            barnum.push(res[i].NUM);
        }
        leftbar3(barnum);
    })
    //柱状图第四个
    $.post("/a/index/api",{
        // ds:'dcapp',
        _id:'index1_leftbar4_1',
    },function(res){
        var barnum = [];
        for(var i=0;i<res.length;i++){
            barnum.push(res[i].NUM);
        }
        leftbar4(barnum);
    })

    $.post("/a/index/api",{
        // ds:'dcapp',
        _id:'index1_rightbox_1',
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
     if(alarmLevel == 0){
     iconClass = "icon-green";
     }else if(alarmLevel == 1){
     iconClass = "icon-yellow";
     }else if(alarmLevel == 2){
     iconClass = "icon-orange";
     }else if(alarmLevel == 3){
     iconClass = "icon-red";
     }
     
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
        _id:'index1_centerpie1_1',
    },function(res){
        var pienum = [];
        for(var i=0;i<res.length;i++){
            var ylpm;
            ylpm ={value:res[i].SUMJZ,name:res[i].YLPM};
            pienum.push(ylpm);
        }
        centerpie1(pienum);
    })

    //中间柱状图2
    $.post("/a/index/api",{
        // ds:'dcapp',
        _id:'index1_centerbar2_1',
    },function(res){
        var ylpmdata = [];
        var ylpm = [];
        var datestr;
        var myDate = new Date();
        myDate.setTime(myDate.getTime() - 1000*60*60*24*5);
        for (var j = 0; j < 5; j++) {
            datestr=Number(myDate.getMonth()) + 1+ "-" + myDate.getDate();
            ylpm.push(datestr);
            myDate.setTime(myDate.getTime() + 1000*60*60*24);
        }
        for(var i=0;i<res.length;i++){
            var num;
            num = {name: res[i].YLPM,
                type: 'bar',
                stack: '原材料',
                barWidth: 30,//柱图宽度
                data:res[i].A.split(",")};
            ylpmdata.push(num);
        }
        centerbar2(ylpmdata,ylpm);
    })

    //中间饼图3
    $.post("/a/index/api",{
        // ds:'dcapp',
        _id:'index1_centerpie3_1',
    },function(res){
        var pienum = [];
        for(var i=0;i<res.length;i++){
            var ylpm;
            ylpm ={value:res[i].BRJC,name:res[i].YLMC_JC};
            pienum.push(ylpm);
        }
        centerpie3(pienum);
    })

    //中间折线图4
    $.post("/a/index/api",{
        // ds:'dcapp',
        _id:'index1_centerline4_1',
    },function(res){
        var ylpmdata = [];
        var ylpm = [];
        var datestr;
        var myDate = new Date();
        myDate.setTime(myDate.getTime() - 1000*60*60*24*5);
        for (var j = 0; j < 5; j++) {
            datestr=Number(myDate.getMonth()) + 1+ "-" + myDate.getDate();
            ylpm.push(datestr);
            myDate.setTime(myDate.getTime() + 1000*60*60*24);
        }
        for(var i=0;i<res.length;i++){
            var num;
            num = {name: res[i].YLMC_JC,
                type: 'line',
                stack: '原材料',
                barWidth: 30,//柱图宽度
                data:res[i].A.split(",")};
            ylpmdata.push(num);
        }
        centerline4(ylpmdata,ylpm);
    })

    //中间折线图5
    $.post("/a/index/api",{
        // ds:'dcapp',
        _id:'index1_centerline5_1',
    },function(res){
        var suma = [];
        var date = [];
        var sumvalue = '';
        for(var i=0;i<res.length;i++){
            suma.push(res[i].SUMA);
            date.push(res[i].B);
            sumvalue=res[i].C;
        }
        centerline5(suma,date,sumvalue);
    })

    //中间柱状图6
    $.post("/a/index/api",{
        // ds:'dcapp',
        _id:'index1_centerbar6_1',
    },function(res){
        var income = [];
        var cost = [];
        var date = [];
        for(var i=0;i<res.length;i++){
            income.push(res[i].INCOME);
            cost.push(res[i].COST);
            date.push(res[i].YYYYMM);
        }
        centerbar6(income,cost,date);
    })
})

    //柱状图1
    function leftbar1(barnum) {
        var targetElement_1 = echarts.init(document.getElementById("option-left1"));
        var option_1 = {
            grid: {
                x: '16%',
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
                    data: ['红色告警','橙色告警','黄色告警'],
                    axisLabel: {
                        show: true,
                        textStyle: {
                            color: '#fff',
                        }
                    }
                }
            ],
            series: [
                {
                    type: 'bar',
                    data: barnum,
                    itemStyle: {
                        normal: {
                            color: function (params) {
                                var colorList = ['#FF0000','#EA7500','#FFD306'];
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
                x: '16%',
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
                    data: ['红色告警','橙色告警','黄色告警'],
                    axisLabel: {
                        show: true,
                        textStyle: {
                            color: '#fff',
                        }
                    }
                }
            ],
            series: [
                {
                    type: 'bar',
                    data: barnum,
                    itemStyle: {
                        normal: {
                            color: function (params) {
                                var colorList = ['#FF0000','#EA7500','#FFD306'];
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
    //柱状图3
    function leftbar3(barnum) {
        var targetElement_3 = echarts.init(document.getElementById("option-left3"));
        var option_3 = {
            grid: {
                x: '16%',
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
                    data: ['红色告警','橙色告警','黄色告警'],
                    axisLabel: {
                        show: true,
                        textStyle: {
                            color: '#fff',
                        }
                    }
                }
            ],
            series: [
                {
                    type: 'bar',
                    data: barnum,
                    itemStyle: {
                        normal: {
                            color: function (params) {
                                var colorList = ['#FF0000','#EA7500','#FFD306'];
                                return colorList[params.dataIndex]
                            },
                            label: {show: true, position: 'right'}
                        }
                    }
                }
            ]
        };
        targetElement_3.setOption(option_3);
    }
    //柱状图4‘
    function leftbar4(barnum) {
        var targetElement_4 = echarts.init(document.getElementById("option-left4"));
        var option_4 = {
            grid: {
                x: '16%',
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
                    data:  ['红色告警','橙色告警','黄色告警'],
                    axisLabel: {
                        show: true,
                        textStyle: {
                            color: '#fff',
                        }
                    }
                }
            ],
            series: [
                {
                    type: 'bar',
                    data: barnum,
                    itemStyle: {
                        normal: {
                            color: function (params) {
                                var colorList = ['#FF0000','#EA7500','#FFD306'];
                                return colorList[params.dataIndex]
                            },
                            label: {show: true, position: 'right'}
                        }
                    }
                }
            ]
        };
        targetElement_4.setOption(option_4);
    }
    //原材料饼图1
    function centerpie1(pienum) {
        var targetElement_5 = echarts.init(document.getElementById("option-center1"));
        
        var option_5 = {
            title: {
                text: '今日原材料入库',
                textStyle: {
                    color: '#fff'
                },
            },
            textStyle: {
                color: '#fff'
            },
            tooltip: {
                trigger: 'item',
               // formatter: "{b} : {c}({d}%)"
                formatter: function (params,ticket,callback) { 
						      if( params.name=='碎石'|| params.name=='机制砂') {return params.name+":"+params.value+"方";}
						      else {return params.name+":"+params.value+"吨";}
						    } 
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
    //原材料柱状图2
    function centerbar2(ylpmdata,ylpm) {
        var targetElement_6 = echarts.init(document.getElementById("option-center2"));
        var option_6 = {
            title: {
                text: '每日原材料入库统计图',
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
    //库存量饼图3
    function centerpie3(pienum) {
        var targetElement_7 = echarts.init(document.getElementById("option-center3"));
        var option_7 = {
            title: {
                text: '现有库存量',
                textStyle: {
                    color: '#fff'
                },
            },
            textStyle: {
                color: '#fff'
            },
            tooltip: {
                trigger: 'item',
                //formatter: "{a} <br/>{b}: {c} ({d}%)"
                 formatter: function (params,ticket,callback) { 
						      if( params.name=='石'|| params.name=='砂') {return params.name+":"+params.value+"方";}
						      else {return params.name+":"+params.value+"吨";}
						      }
            },
            series: [
                {
                    name: '原材料',
                    type: 'pie',
                    radius: ['35%', '70%'],
                    avoidLabelOverlap: false,
                    label: {
                        normal: {
                            show: true
                        },
                        emphasis: {
                            show: true,
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
                    data: pienum
                }
            ]
        };

        targetElement_7.setOption(option_7);
    }
    //库存比例折线图4
    function centerline4(ylpmdata,ylpm) {
        var targetElement_8 = echarts.init(document.getElementById("option-center4"));
        var option_8 = {
            title: {
                text: '每日原材料库存统计',
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
    //销售出库数量折线图5
    function centerline5(suma,date,sumvalue) {
        var targetElement_9 = echarts.init(document.getElementById("option-center5")); 
        var option_9 = {
            title: {
                text: '商砼销售统计',
                subtext:'当月累计销售量：'+sumvalue+'方',
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
                formatter: "{b}: {c}"+"方"
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
                    name: '出库数',
                    type: 'line',
                    data: suma
                }
            ]
        };

        targetElement_9.setOption(option_9);
    }
    //每月销售收支双柱状图
    function centerbar6(income,cost,date) {
        var targetElement_10 = echarts.init(document.getElementById("option-center6"));
        var option_10 = {
            grid: {
                x: '15%',
            },
            title: {
                text: '材料成本与销售对比',
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
            toolbox: {
                show: true
            },
            xAxis: [
                {
                    type: 'category',
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
                    name: '收入',
                    type: 'bar',
                    barWidth: 25,
                    data: income
                },
                {
                    name: '支出',
                    type: 'bar',
                    barWidth: 25,
                    data: cost
                }
            ]
        };

        targetElement_10.setOption(option_10);
    }

    function autoScroll(obj){
        $(obj).find("#sp:first").animate({marginTop: "-80px"}, 3000, function() {
            $(this).css({marginTop:"0px"}).find("li:first").appendTo(this);
        });
    }

