/**
 * Created by 11150221050069 on 2016/12/28.
 */
$(function(){
    $('.redit-table a.redit-detail').click(function(){
        $('.redit-detail').removeClass('on');
        $(this).addClass('on');
        var i = $(this).parent().parent().index() +1;
        $('.redit-pop').fadeIn();
/*        var src = 'image/redit-photo' + i +'.png' ;
        $('.redit-detail-table .detail-photo>img').attr('src',src);*/
        var name = $(this).parent().parent().children().eq(1).html();
        $('#name').html(name);
        var date;
        if(i==1){
            date ='1982.09';
        }else if(i==2){
            date ='1962.12';
        }else if(i==3){
            date ='1956.11';
        }
        $('#birthday').html(date);
        $('#name').html(name);
        var position = $(this).parent().parent().children().eq(3).html();
        $('#position').html(position);
    });

    $('.redit-pop-title .shut').click(function(){
        $('.redit-pop').hide();
        $('.redit-table .redit-detail').removeClass('on');
    })
});