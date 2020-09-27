/**
 * Created by 11150321050124 on 2017/1/12.
 */

$(function () {

    var arrId = ['D18','D03','D12','D13','D11','D09','D14','D10'];
    var arrTitle = ['拟办人意见','拟办负责人审批','专委会审批意见核准','专委会成员签名','专委会领导审批','分管领导审批','主要领导审批'];

    String.prototype.replaceAll = function(s1,s2) {
        return this.replace(new RegExp(s1,"gm"),s2);
    }
    var trace_Key = "'" + arrTitle.toString().replaceAll(",","','") + "'";

    var j = $('.box-left>ul>li.on').index();

    //取节点气泡中，业务数据量、风险数、告警数
    $.each(arrTitle,function(i,o){
        $.post("/a/index/api",{
            _id:'gzw_property_analyse_bubble',
            arr1: arrId[j],
            arr2: arrTitle[i]
        },function (res1) {
            var num1 = res1[0].c1;
            var num2 = res1[1].c1;
            var num3 = res1[2].c1;

            $('.form-left-tree .tree-step .bubble-num1').eq(i).html(num1);
            $('.bubble-num2').eq(i).html(num2);
            $('.bubble-num3').eq(i).html(num3);
        });
    });

    // 弹出层取数据
    $('.tree-step>span').click(function(){

        var tit = $(this).parent().find('.tree-title').html();

        // 告警数和风险数
        var alarmNum = $(this).find('.bubble-num2').html();
        var riskNum = $(this).find('.bubble-num3').html();
        $('.pop-main .pop-alarm-num').html(alarmNum);
        $('.pop-main .pop-risk-num').html(riskNum);

        //取告警约束数值
        $.post("/a/index/api",{
            _id:'gzw_property_analyse_pop_alarm',
            pop1: arrId[j],
            pop2: tit
        },function (res2) {

            var alram1 = res2[0].ALARM_CNT;
            var alram2 = res2[1].ALARM_CNT;
            var alram3 = res2[2].ALARM_CNT;
            var alram4 = res2[3].ALARM_CNT;

            $('.pop-alarm .pop-alarm-num1').html(alram1);
            $('.pop-alarm .pop-alarm-num2').html(alram4);
            $('.pop-alarm .pop-alarm-num3').html(alram3);
            $('.pop-alarm .pop-alarm-num4').html(alram2);
        });

        //取风险约束数值
        $.post("/a/index/api",{
            _id:'gzw_property_analyse_pop_risk',
            pop1: arrId[j],
            pop2: tit
        },function (res3) {

             var risk1 = res3[0].RISK_CNT;
             var risk2 = res3[1].RISK_CNT;
             var risk3 = res3[2].RISK_CNT;
             var risk4 = res3[3].RISK_CNT;

             $('.pop-risk .pop-risk-num1').html(risk1);
             $('.pop-risk .pop-risk-num2').html(risk4);
             $('.pop-risk .pop-risk-num3').html(risk3);
             $('.pop-risk .pop-risk-num4').html(risk2);
        });
    });

    //系统播报信息
    $.post("/a/index/api",{
        _id:'gzw_property_analyse_broadcast',
        arr: arrId[j]
    },function (res4) {

        var news1,news2;
        $.each(res4,function(n,o){
            news1 = res4[n].TYPE;
            news2 = res4[n].COMMENT;
            if (news1 == '风险：'){
                $('.form-right .news-box .news-main').append( "<div><span class='font-red news-type'>"+ news1  +"</span><span class='broadcast-risk'>"+ news2 +"</span></div>" );
            }
            if (news1 == '告警：'){
                $('.form-right .news-box .news-main').append( "<div><span class='font-yellow news-type'>"+ news1  +"</span><span class='broadcast-alarm'>"+ news2 +"</span></div>" );
            }
        });

        if( $('.form-right .news-box .news-main>div').length == 0  ){
            $('.form-right .news-box .news-main').append('<p class="news-none">暂无告警、风险数据</p>');
        }

        //当有告警风险数据时，滚屏
        if( $('.form-right .news-box .news-main>div').length > 1  ) {
            window.onload=scroll();
            function scroll() {
                var cloneDiv = $('.news-main').clone();
                $('.news-div').append(cloneDiv);
                //$('.news-div>div').eq(1).addClass('news-main');
                var m = 0;
                var size = $('.news-div .news-main').eq(0).children('div').size();

                console.log(size);

                //自动轮播
                var t = setInterval(function () {
                    m++;
                    move();
                }, 800);
                //当鼠标放上去的时候，滚动停止，鼠标离开的时候滚动开始
                $(".news-div").hover(
                    function () {
                        clearInterval(t);
                    },
                    function () {
                        t = setInterval(function () {
                            m++;
                            move();
                        }, 1300);
                    }
                );
                //移动事件
                function move() {
                    if (m == size + 1) {
                        $(".news-div ").css({top: 80});
                        m = 1;
                    }
                    $(".news-div").stop().animate({top: -m * 80}, 1300);
                }
            }
        }

    });




});
