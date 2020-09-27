/**
 * Created by 11150321050124 on 2017/1/12.
 */

$(function () {

    $.post("/a/index/api",{

        _id:'gzw_personnel_efficiency'

    },function (res1) {

        //console.log('*********',res1);

        var aId=[];
        var aTime=[],aCnt=[],aEvent=[];

        $.each(res1,function(i,o){
            aId[i] = res1[i].USER_ID;
            aTime[i] = res1[i].DATE;
            aCnt[i] = res1[i].COMMENT;
            aEvent[i] = res1[i].EVENT;
        });

        var idArr = [];
        var dataArr = [];
        var m1,m2= 0,m3= 0,m4;
        var meetArr = [];
        var checkArr = [];

        $.each(res1,function(i,n){

            if(idArr.indexOf(n.USER_ID)==-1){
                idArr.push(n.USER_ID);
                dataArr.push([n.USER_ID]);
            }
            $.each(dataArr,function(y,w){
                if(n.USER_ID==w[0]){
                    w.push(n.DATE);
                }
            });
        });

        $.each(dataArr,function(m5,o){
            for(m4=0;m4 < dataArr[m5].length;m4++) {
                if (dataArr[m5][m4]== dataArr[m5][m4-1]) {
                    dataArr[m5].splice(m4, 1);
                }
            }
        });

        for( m1=0;m1< dataArr.length;m1++){
            meetArr[m1] = [];checkArr[m1] = [];
            for(m2=0;m2<dataArr[m1].length-1;m2++){
                for(m3=0;m3 < aId.length;m3++) {
                    if (aId[m3] == dataArr[m1][0]) {
                        if (aTime[m3] == dataArr[m1][m2+1]) {
                            if (aEvent[m3] == '会议') {
                                meetArr[m1][m2] = aCnt[m3].toString().replace('||','<br>');
                            } else if (aEvent[m3] == '审核') {
                                checkArr[m1][m2] = aCnt[m3].toString().replace('||','<br>');
                            }
                        }
                    }
                }
            }
        }

        $.each(dataArr,function(a,o){
            $('.personnel-efficiency').append( '<div class="personal-div"><div class="person-photo"><img src="" alt=""/><p>'+ dataArr[a][0]  +'</p></div></div>' );
            for( var b=1;b<dataArr[a].length;b++){
                if(typeof(meetArr[a][b-1])==="undefined"){
                    meetArr[a][b-1] = '';
                }
                if(typeof(checkArr[a][b-1])==="undefined"){
                    checkArr[a][b-1] = '';
                }

                $('.personal-div').eq(a).append('<div class="person-info"><div><span class="person-info-title person-title-green">日期：</span><span class="info-time info-data">'+ dataArr[a][b] +'</span></div><div><span class="person-info-title person-title-orange">参加会议：</span><span class="info-data info-meeting">'+ meetArr[a][b-1]+ '</span></div><div><span class="person-info-title person-title-red">审核事项：</span><span class="info-data info-check">'+ checkArr[a][b-1] +'</span></div></div>');
            }
        });
          window.onload=scroll();
    });
        function scroll(){
            var cloneDiv = $('.personnel-efficiency').clone();
            $('.scroll-box').append(cloneDiv);
            $('.three-important1>div').eq(1).addClass('personnel-efficiency');
            var m = 0;
            var size = $('.scroll-box .personnel-efficiency').eq(0).children('div').size();
            //自动轮播
            var t = setInterval(function () {
                m++;
                move();
            },4000);
            //当鼠标放上去的时候，滚动停止，鼠标离开的时候滚动开始
            $(".scroll-box").hover(
                function () {
                    clearInterval(t);
                },
                function () {
                    t = setInterval(function(){ m++; move();},4000);
                }
            );
            //移动事件
            function move() {
                if (m == size+1 ) {
                    $(".scroll-box ").css({ top: 0 });
                    m=1;
                }
                $(".scroll-box").stop().animate({ top: -m * 360},2000);
            }
        }


});
